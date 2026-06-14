// Command tune runs the iterative prompt-tuning loop for a single Kiran game
// asset. It generates an image via ComfyUI, validates it with a vision LLM,
// refines the prompt with an instruct LLM, and repeats until the score crosses
// the threshold or the iteration cap is hit. The winning prompt is saved to a
// YAML sidecar under --tuned-dir so the main generate pipeline can use it.
//
// Usage:
//
//	go run ./cmd/tune \
//	  --skin nex_machina --asset asteroid \
//	  --workflow pony --comfyui-checkpoint "ponyDiffusionV6XL_v6StartWithThisOne.safetensors" \
//	  --llm-url $LLM_URL --llm-model $LLM_MODEL \
//	  --max-iters 4 --threshold 8.0
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
	"tyrian-pipeline/internal/llm"
	"tyrian-pipeline/internal/prompttune"
	"tyrian-pipeline/internal/skin"
)

func main() {
	loadEnvFile(".env")

	skinID := flag.String("skin", "nex_machina", "Skin ID to tune")
	assetName := flag.String("asset", "asteroid", "Asset name to tune (e.g. asteroid, falcon, laser)")
	workflow := flag.String("workflow", "pony", "Prompt workflow: pony or flux")
	tunedDir := flag.String("tuned-dir", "tuned", "Directory to store tuned prompt sidecars")
	outDir := flag.String("out-dir", "tuned_images", "Directory to save generated images for inspection")
	maxIters := flag.Int("max-iters", 4, "Maximum tuning iterations")
	threshold := flag.Float64("threshold", 8.0, "Score threshold to accept a prompt (0-10)")
	comfyURL := flag.String("comfyui-url", "", "ComfyUI server URL (overrides COMFYUI_API_URL env)")
	comfyCheckpoint := flag.String("comfyui-checkpoint", "", "Override ComfyUI checkpoint name")
	comfyJobTimeout := flag.Duration("comfyui-job-timeout", 15*time.Minute, "Max time to wait for a ComfyUI job")
	llmURL := flag.String("llm-url", "", "LLM server base URL (overrides LLM_URL env)")
	llmModel := flag.String("llm-model", "", "Instruct model for prompt refinement (overrides LLM_MODEL env)")
	vlModel := flag.String("vl-model", "", "Vision-language model for image validation (overrides VL env)")
	dryRun := flag.Bool("dry-run", false, "Print initial prompt and exit without calling any API")
	flag.Parse()

	// Resolve env overrides
	if *comfyURL == "" {
		*comfyURL = os.Getenv("COMFYUI_API_URL")
	}
	if *llmURL == "" {
		*llmURL = os.Getenv("LLM_URL")
	}
	if *llmModel == "" {
		*llmModel = os.Getenv("LLM_MODEL")
	}
	if *vlModel == "" {
		*vlModel = os.Getenv("VL_MODEL")
	}

	// Validate skin
	s, ok := skin.GetSkin(*skinID)
	if !ok {
		fmt.Fprintf(os.Stderr, "Error: unknown skin %q\nAvailable: %s\n", *skinID, availableSkins())
		os.Exit(1)
	}

	// Find the asset spec and build the initial prompt
	spec, found := findSpec(*assetName, s)
	if !found {
		fmt.Fprintf(os.Stderr, "Error: unknown asset %q — run with --dry-run to see available assets\n", *assetName)
		os.Exit(1)
	}

	initPrompt, err := buildInitialPrompt(spec, s, *workflow)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error building initial prompt: %v\n", err)
		os.Exit(1)
	}

	target := buildTarget(spec, s, *workflow)

	if *dryRun {
		fmt.Printf("Skin:     %s (%s)\n", s.Name, s.ID)
		fmt.Printf("Asset:    %s [%s]\n", spec.Name, spec.AssetType)
		fmt.Printf("Workflow: %s\n", *workflow)
		fmt.Printf("\nInitial positive prompt:\n%s\n", initPrompt.Positive)
		if initPrompt.Negative != "" {
			fmt.Printf("\nInitial negative prompt:\n%s\n", initPrompt.Negative)
		}
		fmt.Printf("\nTarget:\n%s\n", target.Describe())
		return
	}

	// Validate required flags
	if *comfyURL == "" {
		fmt.Fprintln(os.Stderr, "Error: --comfyui-url or COMFYUI_API_URL is required")
		os.Exit(1)
	}
	if *llmURL == "" {
		fmt.Fprintln(os.Stderr, "Error: --llm-url or LLM_URL is required")
		os.Exit(1)
	}
	if *llmModel == "" {
		fmt.Fprintln(os.Stderr, "Error: --llm-model or LLM_MODEL is required")
		os.Exit(1)
	}
	if *vlModel == "" {
		fmt.Fprintln(os.Stderr, "Error: --vl-model or VL_MODEL is required")
		os.Exit(1)
	}

	// Build ComfyUI client
	cfID := os.Getenv("CF_ACCESS_CLIENT_ID")
	cfSecret := os.Getenv("CF_ACCESS_CLIENT_SECRET")
	comfyOpts := []comfyuiimage.ClientOption{comfyuiimage.WithJobTimeout(*comfyJobTimeout)}
	if *workflow == "pony" {
		comfyOpts = append(comfyOpts,
			comfyuiimage.WithWorkflow(comfyuiimage.PonyWorkflow()),
			comfyuiimage.WithNodeRoles(comfyuiimage.PonyNodeRoles()),
		)
	}
	if *comfyCheckpoint != "" {
		comfyOpts = append(comfyOpts, comfyuiimage.WithCheckpoint(*comfyCheckpoint))
	}
	imageClient := comfyuiimage.NewClient(*comfyURL, cfID, cfSecret, comfyOpts...)

	// Separate clients: vision model for validation, instruct model for refinement.
	vlClient := llm.NewClient(*llmURL, *vlModel, cfID, cfSecret)
	builderClient := llm.NewClient(*llmURL, *llmModel, cfID, cfSecret)
	validator := prompttune.NewValidator(vlClient)
	builder := prompttune.NewBuilder(builderClient)

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	fmt.Printf("Tuning %s/%s [workflow=%s] — up to %d iterations, threshold=%.1f\n",
		*skinID, *assetName, *workflow, *maxIters, *threshold)
	fmt.Printf("Initial prompt: %s\n\n", truncate(initPrompt.Positive, 120))

	result, err := prompttune.Tune(ctx, imageClient, validator, builder, initPrompt, target, prompttune.Options{
		MaxIters:       *maxIters,
		ScoreThreshold: *threshold,
		AspectRatio:    spec.AspectRatio,
		Resolution:     spec.Resolution,
		Log:            os.Stdout,
	})
	if err != nil {
		fmt.Fprintf(os.Stderr, "Tune error: %v\n", err)
		os.Exit(1)
	}

	// Save tuned entry
	entry := prompttune.TunedEntry{
		SkinID:    *skinID,
		Workflow:  *workflow,
		AssetName: *assetName,
		Positive:  result.Prompt.Positive,
		Negative:  result.Prompt.Negative,
		Seed:      result.Seed,
		Score:     result.Score,
		Iters:     result.Iters,
	}
	if err := prompttune.SaveEntry(*tunedDir, *skinID, *workflow, *assetName, entry); err != nil {
		fmt.Fprintf(os.Stderr, "Warning: failed to save tuned entry: %v\n", err)
	} else {
		fmt.Printf("\nSaved tuned prompt to %s\n",
			filepath.Join(*tunedDir, *skinID, *workflow, *assetName+".yaml"))
	}

	// Save the final image for inspection
	if len(result.Image) > 0 {
		imgDir := filepath.Join(*outDir, *skinID, *workflow)
		os.MkdirAll(imgDir, 0755)
		imgPath := filepath.Join(imgDir, *assetName+"_tuned.jpg")
		if err := os.WriteFile(imgPath, result.Image, 0644); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: failed to save image: %v\n", err)
		} else {
			fmt.Printf("Saved final image to %s\n", imgPath)
		}
	}

	status := "NOT PASSED"
	if result.Passed {
		status = "PASSED"
	}
	if result.ValidatorErr != nil {
		status = fmt.Sprintf("VALIDATOR ERROR: %v", result.ValidatorErr)
	}
	fmt.Printf("\nResult: score=%.1f [%s] in %d iterations\n", result.Score, status, result.Iters)
}

func findSpec(assetName string, s skin.SkinDef) (generator.AssetSpec, bool) {
	for _, spec := range generator.AssetsForSkin(s) {
		if spec.Name == assetName {
			return spec, true
		}
	}
	return generator.AssetSpec{}, false
}

func buildInitialPrompt(spec generator.AssetSpec, s skin.SkinDef, workflow string) (prompttune.Prompt, error) {
	pos, err := generator.BuildPromptForWorkflow(spec.AssetType, s, spec.ExtraVars, workflow)
	if err != nil {
		return prompttune.Prompt{}, err
	}
	// For Pony, the negative prompt is baked into the workflow JSON; we start
	// with an empty negative so the builder can add one if needed.
	return prompttune.Prompt{Positive: pos, Workflow: workflow}, nil
}

func buildTarget(spec generator.AssetSpec, s skin.SkinDef, workflow string) prompttune.Target {
	style := s.StyleKeywords
	if workflow == "pony" && s.PonyStyleKeywords != "" {
		style = s.PonyStyleKeywords
	}
	directive := spec.ExtraVars["StructureDirective"]
	if directive == "" {
		directive = spec.ExtraVars["EnemyDirective"]
	}
	if directive == "" {
		directive = spec.ExtraVars["BulletDirective"]
	}
	if directive == "" {
		directive = spec.ExtraVars["LayerDesc"]
	}
	if directive == "" {
		directive = spec.AssetType
	}
	return prompttune.Target{
		AssetType: spec.AssetType,
		AssetName: spec.Name,
		Directive: directive,
		SkinStyle: style,
		Workflow:  workflow,
	}
}

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n] + "..."
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
		key, val = strings.TrimSpace(key), strings.TrimSpace(val)
		if os.Getenv(key) == "" {
			os.Setenv(key, val)
		}
	}
}

func availableSkins() string {
	skins := skin.AllSkins()
	ids := make([]string, len(skins))
	for i, s := range skins {
		ids[i] = s.ID
	}
	return strings.Join(ids, ", ")
}
