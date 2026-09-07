package audio

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"time"

	"github.com/ol1n/AiStack/pkg/audioclient"
)

// AiStackProvider generuje lokálně na SPARKu přes services/audio.
type AiStackProvider struct {
	client *audioclient.Client

	// Hudba běží desítky sekund až minuty, SFX jednotky sekund. Dva timeouty,
	// aby zaseklý SFX job neblokoval běh na patnáct minut.
	musicTimeout time.Duration
	sfxTimeout   time.Duration
}

// NewAiStackProvider vytvoří providera nad danou base URL.
func NewAiStackProvider(baseURL, apiKey string) *AiStackProvider {
	opts := []audioclient.Option{}
	if apiKey != "" {
		opts = append(opts, audioclient.WithAPIKey(apiKey))
	}
	return &AiStackProvider{
		client:       audioclient.New(baseURL, opts...),
		musicTimeout: 20 * time.Minute,
		sfxTimeout:   5 * time.Minute,
	}
}

// Name vrací jméno providera.
func (p *AiStackProvider) Name() string { return "aistack" }

// GenerateMusic vyrobí jednu stopu.
func (p *AiStackProvider) GenerateMusic(ctx context.Context, req MusicRequest) (Asset, error) {
	spec := audioclient.MusicSpec{
		Prompt:       req.Prompt,
		DurationSec:  float64(req.DurationSec),
		Instrumental: true,
		BPM:          req.BPM,
		Key:          req.Key,
		Loop:         req.Loop,
		Format:       "ogg",
		Variations:   1,
	}
	if req.Seed != 0 {
		spec.Seed = &req.Seed
	}

	job, err := p.client.GenerateMusic(ctx, spec)
	if err != nil {
		return Asset{}, fmt.Errorf("zadání hudby: %w", err)
	}
	done, err := p.client.WaitJob(ctx, job.JobID, p.musicTimeout)
	if err != nil {
		return Asset{}, err
	}
	assets, err := p.collect(ctx, done)
	if err != nil {
		return Asset{}, err
	}
	return assets[0], nil
}

// GenerateSFX vyrobí požadovaný počet variant jednoho efektu.
func (p *AiStackProvider) GenerateSFX(ctx context.Context, req SFXRequest) ([]Asset, error) {
	variations := req.Variations
	if variations < 1 {
		variations = 1
	}
	spec := audioclient.SFXSpec{
		Prompt:      req.Prompt,
		DurationSec: req.DurationSec,
		Variations:  variations,
		Mono:        true,
		Format:      "ogg",
	}
	if req.Seed != 0 {
		spec.Seed = &req.Seed
	}

	job, err := p.client.GenerateSFX(ctx, spec)
	if err != nil {
		return nil, fmt.Errorf("zadání SFX: %w", err)
	}
	done, err := p.client.WaitJob(ctx, job.JobID, p.sfxTimeout)
	if err != nil {
		return nil, err
	}
	return p.collect(ctx, done)
}

func (p *AiStackProvider) collect(ctx context.Context, job audioclient.Job) ([]Asset, error) {
	if len(job.Outputs) == 0 {
		return nil, fmt.Errorf("job %s doběhl bez výstupu", job.JobID)
	}
	assets := make([]Asset, 0, len(job.Outputs))
	for _, out := range job.Outputs {
		var buf bytes.Buffer
		if _, err := p.client.Download(ctx, out, &buf); err != nil {
			return nil, fmt.Errorf("stažení %s: %w", out.Filename, err)
		}
		// Hash se počítá z toho, co dorazilo, ne co tvrdí služba — soubor
		// v repu musí sedět na to, co je v manifestu.
		sum := sha256.Sum256(buf.Bytes())
		assets = append(assets, Asset{
			Data:     buf.Bytes(),
			Ext:      "ogg",
			Seed:     out.Seed,
			Duration: out.Duration,
			LUFS:     out.LoudnessLUFS,
			SHA256:   hex.EncodeToString(sum[:]),
			Model:    job.Model,
		})
	}
	return assets, nil
}
