package prompttune

import (
	"fmt"
	"os"
	"path/filepath"
	"time"

	"gopkg.in/yaml.v3"
)

// TunedEntry is the winning prompt for one asset in one workflow, as produced
// by the tuning loop. Saved as a sidecar YAML so the orchestrator can reuse it.
type TunedEntry struct {
	SkinID    string  `yaml:"skin_id"`
	Workflow  string  `yaml:"workflow"`
	AssetName string  `yaml:"asset_name"`
	Positive  string  `yaml:"positive"`
	Negative  string  `yaml:"negative,omitempty"`
	Seed      int64   `yaml:"seed"`
	Score     float64 `yaml:"score"`
	Iters     int     `yaml:"iters"`
	UpdatedAt string  `yaml:"updated_at"`
}

// tunedPath returns pipeline/tuned/<skinID>/<workflow>/<assetName>.yaml.
// workflow "" is stored as "flux".
func tunedPath(tunedDir, skinID, workflow, assetName string) string {
	wf := workflow
	if wf == "" {
		wf = "flux"
	}
	return filepath.Join(tunedDir, skinID, wf, assetName+".yaml")
}

// SaveEntry writes a tuned entry atomically (temp + rename).
func SaveEntry(tunedDir, skinID, workflow, assetName string, e TunedEntry) error {
	e.UpdatedAt = time.Now().UTC().Format(time.RFC3339)
	data, err := yaml.Marshal(e)
	if err != nil {
		return fmt.Errorf("marshal tuned entry: %w", err)
	}

	p := tunedPath(tunedDir, skinID, workflow, assetName)
	if err := os.MkdirAll(filepath.Dir(p), 0755); err != nil {
		return fmt.Errorf("create tuned dir: %w", err)
	}

	tmp, err := os.CreateTemp(filepath.Dir(p), "."+assetName+".*.tmp")
	if err != nil {
		return fmt.Errorf("create temp file: %w", err)
	}
	tmpName := tmp.Name()
	defer os.Remove(tmpName)

	if _, err := tmp.Write(data); err != nil {
		tmp.Close()
		return fmt.Errorf("write temp file: %w", err)
	}
	if err := tmp.Close(); err != nil {
		return fmt.Errorf("close temp file: %w", err)
	}
	if err := os.Rename(tmpName, p); err != nil {
		return fmt.Errorf("rename temp file: %w", err)
	}
	return nil
}

// LoadEntry reads a saved tuned entry. Returns (entry, true) if found and
// (zero, false) if the file does not exist.
func LoadEntry(tunedDir, skinID, workflow, assetName string) (TunedEntry, bool) {
	p := tunedPath(tunedDir, skinID, workflow, assetName)
	data, err := os.ReadFile(p)
	if err != nil {
		return TunedEntry{}, false
	}
	var e TunedEntry
	if err := yaml.Unmarshal(data, &e); err != nil {
		return TunedEntry{}, false
	}
	return e, true
}
