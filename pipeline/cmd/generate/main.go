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
	"time"

	"tyrian-pipeline/internal/comfyuiimage"
	"tyrian-pipeline/internal/generator"
	"tyrian-pipeline/internal/imagegen"
	"tyrian-pipeline/internal/musicgen"
	"tyrian-pipeline/internal/pipeline"
	"tyrian-pipeline/internal/sfxgen"
	"tyrian-pipeline/internal/skin"
)

func main() {
	loadEnvFile(".env")

	skinID := flag.String("skin", "", "Skin ID to generate (empty = all skins)")
	outDir := flag.String("out", "output/assets/skins", "Output directory")
	workers := flag.Int("workers", 3, "Number of concurrent workers")
	model := flag.String("model", "flux-1-dev", "ComfyUI checkpoint name")
	dryRun := flag.Bool("dry-run", false, "Print prompts without calling API")
	force := flag.Bool("force", false, "Regenerate assets even if all variations already exist")
	assetType := flag.String("asset-type", "", "Filter by asset type (ship, explosion, bullet, enemy, structure, background, hud_icon, preview)")
	n := flag.Int("n", 4, "Number of variations per asset")
	resolution := flag.String("resolution", "1k", "Image resolution (1k, 2k)")
	sfxMode := flag.Bool("sfx", false, "Generate SFX via ElevenLabs instead of images")
	musicMode := flag.Bool("music", false, "Generate adaptive music via Eleven Music instead of images")
	comfyJobTimeout := flag.Duration("comfyui-job-timeout", 15*time.Minute, "Max time to wait for a single ComfyUI job")
	comfyWorkflow := flag.String("comfyui-workflow", "flux", "ComfyUI workflow: flux or pony")
	comfyCheckpoint := flag.String("comfyui-checkpoint", "", "Override checkpoint name in ComfyUI workflow node 4")
	tunedDir := flag.String("tuned-dir", "", "Directory of tuned prompt sidecars (e.g. tuned); empty = use templates only")
	flag.Parse()

	if *sfxMode {
		runSfxGeneration(*skinID, *outDir, *dryRun)
		return
	}

	if *musicMode {
		runMusicGeneration(*skinID, *outDir, *dryRun)
		return
	}

	var skins []skin.SkinDef
	if *skinID != "" {
		s, ok := skin.GetSkin(*skinID)
		if !ok {
			fmt.Fprintf(os.Stderr, "Error: unknown skin %q\nAvailable skins: %s\n", *skinID, availableSkins())
			os.Exit(1)
		}
		skins = append(skins, s)
	} else {
		skins = skin.AllSkins()
	}

	var client imagegen.ImageGenerator
	if !*dryRun {
		comfyURL := os.Getenv("COMFYUI_API_URL")
		if comfyURL == "" {
			fmt.Fprintln(os.Stderr, "Error: COMFYUI_API_URL is required (or use -dry-run)")
			os.Exit(1)
		}
		cfID := os.Getenv("CF_ACCESS_CLIENT_ID")
		cfSecret := os.Getenv("CF_ACCESS_CLIENT_SECRET")
		comfyOpts := []comfyuiimage.ClientOption{comfyuiimage.WithJobTimeout(*comfyJobTimeout)}
		if *comfyWorkflow == "pony" {
			comfyOpts = append(comfyOpts,
				comfyuiimage.WithWorkflow(comfyuiimage.PonyWorkflow()),
				comfyuiimage.WithNodeRoles(comfyuiimage.PonyNodeRoles()),
			)
		}
		if *comfyCheckpoint != "" {
			comfyOpts = append(comfyOpts, comfyuiimage.WithCheckpoint(*comfyCheckpoint))
		}
		client = comfyuiimage.NewClient(comfyURL, cfID, cfSecret, comfyOpts...)
	}

	promptStyle := ""
	if *comfyWorkflow == "pony" {
		promptStyle = "pony"
	}

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	orch := pipeline.NewOrchestrator(client, *outDir,
		pipeline.WithWorkers(*workers),
		pipeline.WithN(*n),
		pipeline.WithModel(*model),
		pipeline.WithResolution(*resolution),
		pipeline.WithDryRun(*dryRun),
		pipeline.WithForce(*force),
		pipeline.WithAssetType(*assetType),
		pipeline.WithPromptStyle(promptStyle),
		pipeline.WithTunedDir(*tunedDir),
	)

	start := time.Now()
	var totalGenerated, totalSkipped, totalFailed int

	for _, s := range skins {
		fmt.Printf("\n--- Generating: %s (%s) ---\n", s.Name, s.ID)

		stats := orch.Run(ctx, s)
		totalGenerated += stats.Generated
		totalSkipped += stats.Skipped
		totalFailed += stats.Failed

		if !*dryRun {
			skinDir := filepath.Join(*outDir, s.ID)
			specs := generator.AssetsForSkin(s)
			inputs := make([]skin.ManifestAssetInput, len(specs))
			for i, sp := range specs {
				inputs[i] = skin.ManifestAssetInput{
					Name: sp.Name, AssetType: sp.AssetType, OutputDir: sp.OutputDir,
					AspectRatio: sp.AspectRatio, Resolution: sp.Resolution,
				}
			}
			sfxDir := filepath.Join(skinDir, "sfx")
			if entries, err := os.ReadDir(sfxDir); err == nil {
				for _, e := range entries {
					if !e.IsDir() && (strings.HasSuffix(e.Name(), ".mp3") || strings.HasSuffix(e.Name(), ".ogg")) {
						baseName := strings.TrimSuffix(strings.TrimSuffix(e.Name(), ".mp3"), ".ogg")
						inputs = append(inputs, skin.ManifestAssetInput{
							Name: baseName, AssetType: "sfx", OutputDir: "sfx",
						})
					}
				}
			}
			musicDir := filepath.Join(skinDir, "music")
			if entries, err := os.ReadDir(musicDir); err == nil {
				for _, e := range entries {
					if !e.IsDir() && (strings.HasSuffix(e.Name(), ".mp3") || strings.HasSuffix(e.Name(), ".ogg")) {
						baseName := strings.TrimSuffix(strings.TrimSuffix(e.Name(), ".mp3"), ".ogg")
						inputs = append(inputs, skin.ManifestAssetInput{
							Name: baseName, AssetType: "music", OutputDir: "music",
						})
					}
				}
			}
			if err := skin.GenerateManifest(skinDir, s, *model, *n, inputs); err != nil {
				fmt.Fprintf(os.Stderr, "Warning: manifest generation failed for %s: %v\n", s.ID, err)
			}
		}
	}

	elapsed := time.Since(start)
	fmt.Printf("\n=== Summary ===\n")
	fmt.Printf("Generated: %d | Skipped: %d | Failed: %d\n", totalGenerated, totalSkipped, totalFailed)
	fmt.Printf("Elapsed: %s\n", elapsed.Round(time.Millisecond))
}

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

func runSfxGeneration(skinID, outDir string, dryRun bool) {
	apiKey := os.Getenv("ELEVENLABS_API_KEY")
	if apiKey == "" && !dryRun {
		fmt.Fprintln(os.Stderr, "Error: ELEVENLABS_API_KEY is required for SFX generation (or use -dry-run)")
		os.Exit(1)
	}

	var skins []skin.SkinDef
	if skinID != "" {
		s, ok := skin.GetSkin(skinID)
		if !ok {
			fmt.Fprintf(os.Stderr, "Error: unknown skin %q\nAvailable skins: %s\n", skinID, availableSkins())
			os.Exit(1)
		}
		skins = append(skins, s)
	} else {
		skins = skin.AllSkins()
	}

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	var client *sfxgen.Client
	if !dryRun {
		client = sfxgen.NewClient(apiKey)
	}

	start := time.Now()
	var generated, skipped int

	for _, s := range skins {
		if s.SfxStyle == "" {
			fmt.Printf("Skipping %s (no SfxStyle defined)\n", s.ID)
			continue
		}

		sfxDir := filepath.Join(outDir, s.ID, "sfx")
		if err := os.MkdirAll(sfxDir, 0755); err != nil {
			fmt.Fprintf(os.Stderr, "Error creating dir %s: %v\n", sfxDir, err)
			continue
		}

		fmt.Printf("\n--- SFX: %s (%s) ---\n", s.Name, s.ID)

		for _, spec := range sfxgen.SfxSpecs {
			outPath := filepath.Join(sfxDir, spec.Name+".mp3")
			if _, err := os.Stat(outPath); err == nil {
				fmt.Printf("  [skip] %s (exists)\n", spec.Name)
				skipped++
				continue
			}

			prompt := sfxgen.BuildSfxPrompt(s.SfxStyle, spec)
			if dryRun {
				fmt.Printf("  [dry] %s: %s\n", spec.Name, prompt)
				continue
			}

			fmt.Printf("  [gen] %s ...", spec.Name)
			data, err := client.Generate(ctx, sfxgen.GenerateRequest{
				Text:            prompt,
				DurationSeconds: spec.Duration,
				PromptInfluence: 0.5,
			})
			if err != nil {
				fmt.Printf(" FAILED: %v\n", err)
				continue
			}
			if err := os.WriteFile(outPath, data, 0644); err != nil {
				fmt.Printf(" WRITE ERROR: %v\n", err)
				continue
			}
			fmt.Printf(" OK (%d bytes)\n", len(data))
			generated++

			select {
			case <-ctx.Done():
				fmt.Println("\nInterrupted")
				return
			case <-time.After(2 * time.Second):
			}
		}
	}

	elapsed := time.Since(start)
	fmt.Printf("\n=== SFX Summary ===\n")
	fmt.Printf("Generated: %d | Skipped: %d\n", generated, skipped)
	fmt.Printf("Elapsed: %s\n", elapsed.Round(time.Millisecond))
}

func runMusicGeneration(skinID, outDir string, dryRun bool) {
	apiKey := os.Getenv("ELEVENLABS_API_KEY")
	if apiKey == "" && !dryRun {
		fmt.Fprintln(os.Stderr, "Error: ELEVENLABS_API_KEY is required for music generation (or use -dry-run)")
		os.Exit(1)
	}

	var skins []skin.SkinDef
	if skinID != "" {
		s, ok := skin.GetSkin(skinID)
		if !ok {
			fmt.Fprintf(os.Stderr, "Error: unknown skin %q\nAvailable skins: %s\n", skinID, availableSkins())
			os.Exit(1)
		}
		skins = append(skins, s)
	} else {
		skins = skin.AllSkins()
	}

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	var client *musicgen.Client
	if !dryRun {
		client = musicgen.NewClient(apiKey)
	}

	fmt.Println("Note: Eleven Music is billed per generation and is far heavier than SFX —")
	fmt.Printf("      %d tracks/skin × %d skin(s). Generate in phases and verify quality.\n", len(musicgen.MusicSpecs), len(skins))

	start := time.Now()
	var generated, skipped int

	for _, s := range skins {
		if s.MusicStyle == "" {
			fmt.Printf("Skipping %s (no MusicStyle defined)\n", s.ID)
			continue
		}

		musicDir := filepath.Join(outDir, s.ID, "music")
		if err := os.MkdirAll(musicDir, 0755); err != nil {
			fmt.Fprintf(os.Stderr, "Error creating dir %s: %v\n", musicDir, err)
			continue
		}

		fmt.Printf("\n--- Music: %s (%s) ---\n", s.Name, s.ID)

		for _, spec := range musicgen.MusicSpecs {
			outPath := filepath.Join(musicDir, spec.Name+".mp3")
			if _, err := os.Stat(outPath); err == nil {
				fmt.Printf("  [skip] %s (exists)\n", spec.Name)
				skipped++
				continue
			}

			prompt := musicgen.BuildMusicPrompt(s.MusicStyle, s.MusicTempo, s.MusicKey, spec)
			if dryRun {
				fmt.Printf("  [dry] %s (%ds): %s\n", spec.Name, spec.DurationSec, prompt)
				continue
			}

			fmt.Printf("  [gen] %s (%ds) ...", spec.Name, spec.DurationSec)
			data, err := client.Generate(ctx, musicgen.GenerateRequest{
				Prompt:        prompt,
				MusicLengthMs: spec.DurationSec * 1000,
			})
			if err != nil {
				fmt.Printf(" FAILED: %v\n", err)
				continue
			}
			if err := os.WriteFile(outPath, data, 0644); err != nil {
				fmt.Printf(" WRITE ERROR: %v\n", err)
				continue
			}
			fmt.Printf(" OK (%d bytes)\n", len(data))
			generated++

			// Music generation is expensive — pace requests conservatively.
			select {
			case <-ctx.Done():
				fmt.Println("\nInterrupted")
				return
			case <-time.After(5 * time.Second):
			}
		}
	}

	elapsed := time.Since(start)
	fmt.Printf("\n=== Music Summary ===\n")
	fmt.Printf("Generated: %d | Skipped: %d\n", generated, skipped)
	fmt.Printf("Elapsed: %s\n", elapsed.Round(time.Millisecond))
}

func availableSkins() string {
	skins := skin.AllSkins()
	ids := make([]string, len(skins))
	for i, s := range skins {
		ids[i] = s.ID
	}
	return strings.Join(ids, ", ")
}
