package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"

	"tyrian-pipeline/internal/postprocess"
	"tyrian-pipeline/internal/skin"
)

func main() {
	skinID := flag.String("skin", "", "Skin ID to process (required)")
	input := flag.String("input", "output/assets/skins", "Pipeline output dir")
	output := flag.String("output", "../tyrian_mobile/assets/skins", "Game assets dir")
	variation := flag.Int("variation", 1, "Variation to use for assets with no recorded choice; with -variation given explicitly it overrides the record for whatever this run processes")
	only := flag.String("only", "", "Process a single asset by name (e.g. falcon3) instead of the whole skin")
	size := flag.Int("size", 128, "Max target dimension px")
	threshold := flag.Int("threshold", 60, "Background removal threshold")
	margin := flag.Int("margin", 20, "Background removal soft-edge margin")
	root := flag.String("root", ".", "Repo-relative root holding the selections/ record")
	flag.Parse()

	// Whether -variation was actually typed. Without this a bare
	// `-only starg` run would silently rewrite that asset's recorded choice to
	// the flag's default of 1.
	variationSet := false
	thresholdSet := false
	flag.Visit(func(f *flag.Flag) {
		switch f.Name {
		case "variation":
			variationSet = true
		case "threshold":
			thresholdSet = true
		}
	})

	if *only != "" && *skinID == "" {
		fmt.Fprintln(os.Stderr, "-only requires -skin")
		os.Exit(1)
	}

	var skinIDs []string
	if *skinID != "" {
		skinIDs = append(skinIDs, *skinID)
	} else {
		// Process all skins found in the input directory
		entries, err := os.ReadDir(*input)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading input dir: %v\n", err)
			os.Exit(1)
		}
		for _, e := range entries {
			if e.IsDir() {
				skinIDs = append(skinIDs, e.Name())
			}
		}
		if len(skinIDs) == 0 {
			fmt.Fprintln(os.Stderr, "No skin directories found in", *input)
			os.Exit(1)
		}
		fmt.Printf("Processing %d skins: %v\n\n", len(skinIDs), skinIDs)
	}

	for _, id := range skinIDs {
		selPath := postprocess.SelectionsPath(*root, id)
		sel, err := postprocess.LoadSelections(selPath, id)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading selections for %s: %v\n", id, err)
			continue
		}

		// A skin whose palette sits close to the plate the model draws it on
		// carries its own key threshold; a typed -threshold still wins, so a
		// one-off can be dialled in from the command line before it is written
		// down in the definition.
		bgThreshold := *threshold
		var paletteDesc string
		if def, ok := skin.GetSkin(id); ok {
			paletteDesc = def.PaletteDescription
			if !thresholdSet && def.BgThreshold > 0 {
				bgThreshold = def.BgThreshold
			}
		}

		cfg := postprocess.Config{
			SkinDir:            filepath.Join(*input, id),
			OutputDir:          filepath.Join(*output, id),
			Variation:          *variation,
			Only:               *only,
			Sel:                sel,
			TargetSize:         *size,
			BgThreshold:        bgThreshold,
			BgMargin:           *margin,
			PaletteDescription: paletteDesc,
		}

		// An explicit -variation is an instruction, not a default: it wins over
		// the record for the assets this run touches, and is then recorded so
		// the file keeps describing what is actually on disk.
		if variationSet {
			if *only != "" {
				sel.Set(*only, *variation)
			} else {
				cfg.Sel = nil // whole-skin re-roll: every asset takes the flag
			}
		}

		if err := postprocess.Run(cfg); err != nil {
			fmt.Fprintf(os.Stderr, "Error processing %s: %v\n", id, err)
			continue
		}

		// Record what was built. Assets that had no entry are pinned to the
		// variation they were actually derived from, so the presumption that
		// "everything is v1" becomes a fact on disk instead of folklore.
		if err := recordRun(sel, cfg, *input, id, *only, *variation, variationSet); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: could not record selections for %s: %v\n", id, err)
			continue
		}
		if err := sel.Save(selPath); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: could not write %s: %v\n", selPath, err)
		}
	}
}

// recordRun pins every asset this run produced to the variation it came from.
func recordRun(sel *postprocess.Selections, cfg postprocess.Config,
	input, skinID, only string, variation int, variationSet bool) error {
	names, err := postprocess.ManifestAssetNames(filepath.Join(input, skinID))
	if err != nil {
		return err
	}
	for _, n := range names {
		if only != "" && n != only {
			continue
		}
		switch {
		case variationSet:
			sel.Set(n, variation)
		default:
			sel.Set(n, sel.For(n, cfg.Variation))
		}
	}
	return nil
}
