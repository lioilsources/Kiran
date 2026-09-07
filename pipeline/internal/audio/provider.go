// Package audio drží generování hudby a SFX nezávisle na tom, kdo je vyrábí.
//
// Do srpna 2026 to byl ElevenLabs; teď je výchozí AiStack se open-source
// modely na SPARKu. Pipeline zná jenom [Provider] — jméno modelu se v ní
// nikde nevyskytuje a nesmí.
package audio

import (
	"context"
	"fmt"
	"os"
)

// MusicRequest popisuje jednu hudební stopu.
type MusicRequest struct {
	Prompt      string
	DurationSec int
	BPM         int
	Key         string
	Loop        bool
	Seed        int64 // 0 = nech provider zvolit
}

// SFXRequest popisuje jeden zvukový efekt.
type SFXRequest struct {
	Prompt      string
	DurationSec float64
	Variations  int
	Seed        int64 // 0 = nech provider zvolit
}

// Asset je jeden vygenerovaný soubor.
type Asset struct {
	Data     []byte
	Ext      string  // "ogg" | "mp3"
	Seed     int64   // seed, kterým se dá stopa přesně zopakovat
	Duration float64 // sekundy, jak je změřil provider (0 = neznámo)
	LUFS     float64 // integrovaná hlasitost (0 = neměřeno)
	SHA256   string
	Model    string // co to vyrobilo — kvůli THIRD_PARTY_LICENSES
}

// Provider generuje audio. Implementace: [AiStackProvider], [ElevenLabsProvider].
type Provider interface {
	Name() string
	GenerateMusic(ctx context.Context, req MusicRequest) (Asset, error)
	GenerateSFX(ctx context.Context, req SFXRequest) ([]Asset, error)
}

// NewProviderFromEnv vybere providera podle AUDIO_PROVIDER.
//
// Výchozí je aistack. ElevenLabs zůstává jako fallback: klíč se dá odebrat
// z prostředí, ale kód se nemaže — kdyby lokální modely na něčem selhaly,
// je návrat otázkou jedné proměnné, ne revertu.
func NewProviderFromEnv() (Provider, error) {
	switch name := envOr("AUDIO_PROVIDER", "aistack"); name {
	case "aistack":
		return NewAiStackProvider(envOr("AISTACK_URL", "http://spark:8093"), os.Getenv("AISTACK_API_KEY")), nil
	case "elevenlabs":
		key := os.Getenv("ELEVENLABS_API_KEY")
		if key == "" {
			return nil, fmt.Errorf("AUDIO_PROVIDER=elevenlabs, ale ELEVENLABS_API_KEY chybí")
		}
		return NewElevenLabsProvider(key), nil
	default:
		return nil, fmt.Errorf("neznámý AUDIO_PROVIDER %q (aistack|elevenlabs)", name)
	}
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
