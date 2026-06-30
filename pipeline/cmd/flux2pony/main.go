// Command flux2pony is the img2img restyle pass (pass 2). It takes the flux
// images already generated for a source skin (pass 1, under
// output/assets/skins/<src>/), repaints each one through the Pony SDXL model
// with a paint-style prompt (watercolor, …) and writes the result to a new skin
// output/assets/skins/<src>_<style>/. The source skin is left untouched.
//
// Run postprocess + pack_atlas on the resulting skin exactly as for any other
// skin to produce game-ready assets.
package main

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"tyrian-pipeline/internal/comfyuiimage"
	"tyrian-pipeline/internal/generator"
	"tyrian-pipeline/internal/skin"
	"tyrian-pipeline/internal/style"
)

// ponyNegativeBaseline mirrors node "7" in pony_img2img.json. Style-specific
// negatives from the preset are appended to it. Keep in sync with the workflow.
const ponyNegativeBaseline = "score_4, score_5, score_6, worst quality, low quality, bad quality, jpeg artifacts, blurry, ugly, photo, photorealistic, realistic, 3d render, text, watermark, signature, logo, 1girl, 1boy, human, person, face, portrait, anthro, pony, furry"

// maxVariations caps the contiguous _v1.._vN scan per asset.
const maxVariations = 16

func main() {
	loadEnvFile(".env")

	skinID := flag.String("skin", "", "Source skin ID whose flux images to restyle (required)")
	styleID := flag.String("style", "watercolor", "Paint style preset: "+strings.Join(style.IDs(), ", "))
	outSkinFlag := flag.String("out-skin", "", "Output skin ID (default: <skin>_<style>)")
	inDir := flag.String("in", "output/assets/skins", "Directory holding source skin assets")
	outDir := flag.String("out", "output/assets/skins", "Output directory for the restyled skin")
	denoise := flag.Float64("denoise", 0, "KSampler denoise 0..1 (0 = preset default; lower keeps more of the flux base)")
	assetType := flag.String("asset-type", "", "Filter by asset type or asset name (ship, background, …)")
	workers := flag.Int("workers", 2, "Number of concurrent ComfyUI jobs")
	comfyCheckpoint := flag.String("comfyui-checkpoint", "", "Override Pony checkpoint name")
	comfyJobTimeout := flag.Duration("comfyui-job-timeout", 15*time.Minute, "Max time to wait for a single ComfyUI job")
	dryRun := flag.Bool("dry-run", false, "Print prompts and paths without calling ComfyUI")
	flag.Parse()

	if *skinID == "" {
		fmt.Fprintln(os.Stderr, "Error: -skin is required")
		os.Exit(1)
	}
	src, ok := skin.GetSkin(*skinID)
	if !ok {
		fmt.Fprintf(os.Stderr, "Error: unknown skin %q\n", *skinID)
		os.Exit(1)
	}
	preset, ok := style.Get(*styleID)
	if !ok {
		fmt.Fprintf(os.Stderr, "Error: unknown style %q (have: %s)\n", *styleID, strings.Join(style.IDs(), ", "))
		os.Exit(1)
	}

	outSkin := *outSkinFlag
	if outSkin == "" {
		outSkin = src.ID + "_" + preset.ID
	}
	dn := *denoise
	if dn <= 0 {
		dn = preset.Denoise
	}

	srcDir := filepath.Join(*inDir, src.ID)
	outSkinDir := filepath.Join(*outDir, outSkin)

	specs := generator.AssetsForSkin(src)
	if *assetType != "" {
		filtered := specs[:0]
		for _, sp := range specs {
			if sp.AssetType == *assetType || sp.Name == *assetType {
				filtered = append(filtered, sp)
			}
		}
		specs = filtered
	}

	fmt.Printf("=== flux2pony: %s → %s (style=%s, denoise=%.2f) ===\n", src.ID, outSkin, preset.ID, dn)

	// Enumerate concrete (spec, variation) jobs from existing flux images.
	type job struct {
		spec      generator.AssetSpec
		variation int
		inPath    string
		outPath   string
	}
	var jobs []job
	maxVar := 0
	for _, sp := range specs {
		for i := 1; i <= maxVariations; i++ {
			inPath := filepath.Join(srcDir, sp.OutputDir, fmt.Sprintf("%s_v%d.jpg", sp.Name, i))
			info, err := os.Stat(inPath)
			if err != nil || info.Size() == 0 {
				break // contiguous: stop at first missing variation
			}
			outPath := filepath.Join(outSkinDir, sp.OutputDir, fmt.Sprintf("%s_v%d.jpg", sp.Name, i))
			jobs = append(jobs, job{spec: sp, variation: i, inPath: inPath, outPath: outPath})
			if i > maxVar {
				maxVar = i
			}
		}
	}
	if len(jobs) == 0 {
		fmt.Fprintf(os.Stderr, "Error: no flux images found under %s (run pass 1 first)\n", srcDir)
		os.Exit(1)
	}

	// Build the positive prompt for an asset: paint-style prefix + Pony subject.
	buildPrompt := func(sp generator.AssetSpec) (string, error) {
		subject, err := generator.BuildPromptForWorkflow(sp.AssetType, src, sp.ExtraVars, "pony")
		if err != nil {
			return "", err
		}
		return preset.Positive + ", " + subject, nil
	}
	negative := ponyNegativeBaseline
	if preset.Negative != "" {
		negative += ", " + preset.Negative
	}

	if *dryRun {
		fmt.Printf("Jobs: %d (from %d specs)\n\n", len(jobs), len(specs))
		for i, j := range jobs {
			prompt, err := buildPrompt(j.spec)
			if err != nil {
				fmt.Printf("[%d] %s/%s_v%d — ERROR: %v\n", i+1, j.spec.OutputDir, j.spec.Name, j.variation, err)
				continue
			}
			fmt.Printf("[%d] %s → %s\n    %s\n\n", i+1, j.inPath, j.outPath, prompt)
		}
		return
	}

	comfyURL := os.Getenv("COMFYUI_API_URL")
	if comfyURL == "" {
		fmt.Fprintln(os.Stderr, "Error: COMFYUI_API_URL is required (or use -dry-run)")
		os.Exit(1)
	}
	cfID := os.Getenv("CF_ACCESS_CLIENT_ID")
	cfSecret := os.Getenv("CF_ACCESS_CLIENT_SECRET")
	comfyOpts := []comfyuiimage.ClientOption{
		comfyuiimage.WithWorkflow(comfyuiimage.PonyImg2ImgWorkflow()),
		comfyuiimage.WithNodeRoles(comfyuiimage.Img2ImgNodeRoles()),
		comfyuiimage.WithJobTimeout(*comfyJobTimeout),
	}
	if *comfyCheckpoint != "" {
		comfyOpts = append(comfyOpts, comfyuiimage.WithCheckpoint(*comfyCheckpoint))
	}
	client := comfyuiimage.NewClient(comfyURL, cfID, cfSecret, comfyOpts...)

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	// Output dirs.
	for _, d := range []string{"sprites", "backgrounds", "ui", "sfx", "music", "shaders"} {
		os.MkdirAll(filepath.Join(outSkinDir, d), 0755)
	}

	// Worker pool, shared 2s rate limiter (matches the generate orchestrator).
	rateLimiter := time.NewTicker(2 * time.Second)
	defer rateLimiter.Stop()

	work := make(chan job, len(jobs))
	for _, j := range jobs {
		work <- j
	}
	close(work)

	var mu sync.Mutex
	var generated, skipped, failed int

	var wg sync.WaitGroup
	for i := 0; i < *workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for j := range work {
				if ctx.Err() != nil {
					return
				}
				// Resume: skip if output already exists.
				if info, err := os.Stat(j.outPath); err == nil && info.Size() > 0 {
					mu.Lock()
					skipped++
					mu.Unlock()
					fmt.Printf("  SKIP %s/%s_v%d (exists)\n", j.spec.OutputDir, j.spec.Name, j.variation)
					continue
				}

				prompt, err := buildPrompt(j.spec)
				if err != nil {
					mu.Lock()
					failed++
					mu.Unlock()
					fmt.Printf("  FAIL %s/%s_v%d: build prompt: %v\n", j.spec.OutputDir, j.spec.Name, j.variation, err)
					continue
				}
				baseImage, err := os.ReadFile(j.inPath)
				if err != nil {
					mu.Lock()
					failed++
					mu.Unlock()
					fmt.Printf("  FAIL %s/%s_v%d: read base: %v\n", j.spec.OutputDir, j.spec.Name, j.variation, err)
					continue
				}

				select {
				case <-ctx.Done():
					return
				case <-rateLimiter.C:
				}

				out, err := client.GenerateImg2Img(ctx, comfyuiimage.Img2ImgRequest{
					BaseImage:      baseImage,
					BaseFilename:   fmt.Sprintf("f2p_%s_%s_v%d.png", src.ID, j.spec.Name, j.variation),
					Prompt:         prompt,
					NegativePrompt: negative,
					FilenamePrefix: outSkin + "_" + j.spec.Name,
					Denoise:        dn,
				})
				if err != nil {
					mu.Lock()
					failed++
					mu.Unlock()
					fmt.Printf("  FAIL %s/%s_v%d: %v\n", j.spec.OutputDir, j.spec.Name, j.variation, err)
					continue
				}
				if err := os.WriteFile(j.outPath, out, 0644); err != nil {
					mu.Lock()
					failed++
					mu.Unlock()
					fmt.Printf("  FAIL %s/%s_v%d: write: %v\n", j.spec.OutputDir, j.spec.Name, j.variation, err)
					continue
				}
				mu.Lock()
				generated++
				mu.Unlock()
				fmt.Printf("  OK   %s/%s_v%d\n", j.spec.OutputDir, j.spec.Name, j.variation)
			}
		}()
	}
	wg.Wait()

	// Copy audio from the source so the restyled skin is playable as-is.
	copyAudio(srcDir, outSkinDir)

	// Write a manifest for the new skin (reuses the source's image specs).
	writeManifest(src, outSkin, preset, outSkinDir, maxVar)

	fmt.Printf("\n=== Summary: generated %d | skipped %d | failed %d ===\n", generated, skipped, failed)
	fmt.Printf("Next: go run ./cmd/postprocess -skin %s\n", outSkin)
}

// writeManifest builds a manifest for the restyled skin from the source's image
// specs plus any copied sfx/music, applying the preset's font / post-process.
func writeManifest(src skin.SkinDef, outSkin string, preset style.Preset, outSkinDir string, n int) {
	out := src
	out.ID = outSkin
	out.Name = src.Name + " (" + preset.Name + ")"
	if preset.GoogleFont != "" {
		out.GoogleFont = preset.GoogleFont
	}
	if preset.PostProcess != "" {
		out.PostProcess = skin.PostProcessEffect(preset.PostProcess)
	}

	specs := generator.AssetsForSkin(src)
	inputs := make([]skin.ManifestAssetInput, 0, len(specs)+8)
	for _, sp := range specs {
		inputs = append(inputs, skin.ManifestAssetInput{
			Name: sp.Name, AssetType: sp.AssetType, OutputDir: sp.OutputDir,
			AspectRatio: sp.AspectRatio, Resolution: sp.Resolution,
		})
	}
	for _, sub := range []string{"sfx", "music"} {
		entries, err := os.ReadDir(filepath.Join(outSkinDir, sub))
		if err != nil {
			continue
		}
		for _, e := range entries {
			if e.IsDir() {
				continue
			}
			name := e.Name()
			if !strings.HasSuffix(name, ".mp3") && !strings.HasSuffix(name, ".ogg") {
				continue
			}
			base := strings.TrimSuffix(strings.TrimSuffix(name, ".mp3"), ".ogg")
			inputs = append(inputs, skin.ManifestAssetInput{Name: base, AssetType: sub, OutputDir: sub})
		}
	}
	if err := skin.GenerateManifest(outSkinDir, out, "pony-img2img:"+preset.ID, n, inputs); err != nil {
		fmt.Fprintf(os.Stderr, "Warning: manifest generation failed: %v\n", err)
	}
}

// copyAudio copies sfx/ and music/ files from src to dst (skin stays playable).
func copyAudio(srcDir, dstDir string) {
	for _, sub := range []string{"sfx", "music"} {
		from := filepath.Join(srcDir, sub)
		entries, err := os.ReadDir(from)
		if err != nil {
			continue
		}
		to := filepath.Join(dstDir, sub)
		os.MkdirAll(to, 0755)
		for _, e := range entries {
			if e.IsDir() {
				continue
			}
			dstPath := filepath.Join(to, e.Name())
			if info, err := os.Stat(dstPath); err == nil && info.Size() > 0 {
				continue // already copied
			}
			data, err := os.ReadFile(filepath.Join(from, e.Name()))
			if err != nil {
				continue
			}
			os.WriteFile(dstPath, data, 0644)
		}
	}
}

// loadEnvFile loads KEY=VALUE lines from path into the environment (does not
// override values already set). Mirrors cmd/generate.
func loadEnvFile(path string) {
	f, err := os.Open(path)
	if err != nil {
		return
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		key, val, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		key = strings.TrimSpace(key)
		val = strings.TrimSpace(val)
		if os.Getenv(key) == "" {
			os.Setenv(key, val)
		}
	}
}
