package postprocess

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sort"
)

// SelectionsDir is where the per-skin variant records live. Deliberately NOT
// under output/ — that directory is gitignored, and the whole point of this
// file is that the choice survives in version control. It is also not shipped
// inside the app: it is build-time provenance, not a game asset.
const SelectionsDir = "selections"

// Selections records which generated variation was chosen for each asset of a
// skin, keyed by asset name (as it appears in the pipeline manifest).
//
// Before this existed the choice lived nowhere: postprocess took a single
// skin-wide -variation and forgot it, so every shipped sprite was *presumed*
// to be v1 and re-picking one bad asset meant re-rolling the whole skin. That
// assumption was wrong in practice — a hand-audit found sprites shipped from
// other variations and one that came from no variation at all.
type Selections struct {
	Skin   string         `json:"skin"`
	Assets map[string]int `json:"assets"`
}

// SelectionsPath returns the record path for a skin, e.g. selections/rtype.json.
func SelectionsPath(root, skinID string) string {
	return filepath.Join(root, SelectionsDir, skinID+".json")
}

// LoadSelections reads a skin's record. A missing file is not an error — it
// means nothing has been recorded yet, which is the state every skin starts in.
func LoadSelections(path, skinID string) (*Selections, error) {
	s := &Selections{Skin: skinID, Assets: map[string]int{}}
	data, err := os.ReadFile(path)
	if os.IsNotExist(err) {
		return s, nil
	}
	if err != nil {
		return nil, fmt.Errorf("read selections: %w", err)
	}
	if err := json.Unmarshal(data, s); err != nil {
		return nil, fmt.Errorf("parse selections %s: %w", path, err)
	}
	if s.Assets == nil {
		s.Assets = map[string]int{}
	}
	s.Skin = skinID
	return s, nil
}

// Save writes the record back, creating the directory if needed. Keys are
// sorted by encoding/json's map handling, so the file stays diff-friendly.
func (s *Selections) Save(path string) error {
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		return fmt.Errorf("create selections dir: %w", err)
	}
	data, err := json.MarshalIndent(s, "", "  ")
	if err != nil {
		return fmt.Errorf("encode selections: %w", err)
	}
	return os.WriteFile(path, append(data, '\n'), 0644)
}

// For returns the recorded variation for an asset, or fallback when the asset
// has no record yet.
func (s *Selections) For(asset string, fallback int) int {
	if s == nil {
		return fallback
	}
	if v, ok := s.Assets[asset]; ok && v > 0 {
		return v
	}
	return fallback
}

// Set records a choice.
func (s *Selections) Set(asset string, variation int) {
	if s.Assets == nil {
		s.Assets = map[string]int{}
	}
	s.Assets[asset] = variation
}

// Names returns the recorded asset names in stable order (for reporting).
func (s *Selections) Names() []string {
	out := make([]string, 0, len(s.Assets))
	for k := range s.Assets {
		out = append(out, k)
	}
	sort.Strings(out)
	return out
}
