package audio

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"

	"tyrian-pipeline/internal/musicgen"
	"tyrian-pipeline/internal/sfxgen"
)

// ElevenLabsProvider je původní cloudová cesta. Zůstává jako fallback pro
// případ, že by lokální modely vypadly; do produkce se nepoužívá.
//
// Varianty generuje opakovaným voláním, protože ElevenLabs API bere jeden
// prompt = jeden zvuk, a seed neumí vrátit — proto [Asset.Seed] zůstává 0
// a assety z něj nejsou deterministicky reprodukovatelné. To je hlavní důvod,
// proč je výchozí aistack.
type ElevenLabsProvider struct {
	music *musicgen.Client
	sfx   *sfxgen.Client
}

// NewElevenLabsProvider vytvoří providera nad ElevenLabs API klíčem.
func NewElevenLabsProvider(apiKey string) *ElevenLabsProvider {
	return &ElevenLabsProvider{
		music: musicgen.NewClient(apiKey),
		sfx:   sfxgen.NewClient(apiKey),
	}
}

// Name vrací jméno providera.
func (p *ElevenLabsProvider) Name() string { return "elevenlabs" }

// GenerateMusic zavolá Eleven Music compose.
func (p *ElevenLabsProvider) GenerateMusic(ctx context.Context, req MusicRequest) (Asset, error) {
	data, err := p.music.Generate(ctx, musicgen.GenerateRequest{
		Prompt:        req.Prompt,
		MusicLengthMs: req.DurationSec * 1000,
	})
	if err != nil {
		return Asset{}, err
	}
	return mp3Asset(data), nil
}

// GenerateSFX zavolá Sound Effects API tolikrát, kolik je variant.
func (p *ElevenLabsProvider) GenerateSFX(ctx context.Context, req SFXRequest) ([]Asset, error) {
	variations := req.Variations
	if variations < 1 {
		variations = 1
	}
	assets := make([]Asset, 0, variations)
	for i := 0; i < variations; i++ {
		data, err := p.sfx.Generate(ctx, sfxgen.GenerateRequest{
			Text:            req.Prompt,
			DurationSeconds: req.DurationSec,
			PromptInfluence: 0.5,
		})
		if err != nil {
			return nil, fmt.Errorf("varianta %d: %w", i, err)
		}
		assets = append(assets, mp3Asset(data))
	}
	return assets, nil
}

func mp3Asset(data []byte) Asset {
	sum := sha256.Sum256(data)
	return Asset{
		Data:   data,
		Ext:    "mp3",
		SHA256: hex.EncodeToString(sum[:]),
		Model:  "elevenlabs",
	}
}
