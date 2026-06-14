package prompttune

import (
	"context"
	"crypto/rand"
	"fmt"
	"io"
	"math/big"

	"tyrian-pipeline/internal/imagegen"
)

// Options configures the tuning loop.
type Options struct {
	MaxIters       int     // iteration cap (default 4)
	ScoreThreshold float64 // accept when validator score >= this (default 8.0)
	AspectRatio    string  // default "1:1"
	Resolution     string  // default "1k"
	Log            io.Writer
}

// IterRecord captures one generate→validate→refine round.
type IterRecord struct {
	N       int
	Prompt  Prompt
	Seed    int64
	Verdict Verdict
	Refine  *Exchange // nil if accepted or last iteration
}

// Result is the outcome of tuning one asset.
type Result struct {
	Image        []byte
	Prompt       Prompt
	Seed         int64
	Score        float64
	Passed       bool
	Iters        int
	Transcript   []IterRecord
	ValidatorErr error
}

// Tune runs the iterative loop for a single asset and returns the final image
// and the prompt that produced it. It always keeps the last generated result.
func Tune(
	ctx context.Context,
	gen imagegen.ImageGenerator,
	val *Validator,
	bld *Builder,
	init Prompt,
	t Target,
	opts Options,
) (Result, error) {
	maxIters := opts.MaxIters
	if maxIters <= 0 {
		maxIters = 4
	}
	threshold := opts.ScoreThreshold
	if threshold <= 0 {
		threshold = 8.0
	}
	aspect := opts.AspectRatio
	if aspect == "" {
		aspect = "1:1"
	}
	res := opts.Resolution
	if res == "" {
		res = "1k"
	}

	var out Result
	cur := init
	for i := 1; i <= maxIters; i++ {
		seed := randSeed()
		resp, err := gen.Generate(ctx, imagegen.GenerateRequest{
			Prompt:         cur.Positive,
			NegativePrompt: cur.Negative,
			N:              1,
			AspectRatio:    aspect,
			Resolution:     res,
			ResponseFormat: "b64_json",
			Seed:           seed,
			FilenamePrefix: t.AssetName + "_tune" + fmt.Sprintf("%02d", i),
		})
		if err != nil {
			return out, fmt.Errorf("generate (iter %d): %w", i, err)
		}
		if len(resp.Data) == 0 {
			return out, fmt.Errorf("generate (iter %d): no image returned", i)
		}
		img, err := resp.Data[0].Bytes()
		if err != nil {
			return out, fmt.Errorf("decode image (iter %d): %w", i, err)
		}

		verdict, verr := val.Validate(ctx, img, t)
		rec := IterRecord{N: i, Prompt: cur, Seed: seed, Verdict: verdict}

		out.Image = img
		out.Prompt = cur
		out.Seed = seed
		out.Score = verdict.Score
		out.Passed = verdict.Score >= threshold
		out.Iters = i

		if verr != nil {
			out.ValidatorErr = verr
			out.Transcript = append(out.Transcript, rec)
			logf(opts.Log, "  [tune] iter %d: validator error: %v\n", i, verr)
			break
		}

		logIter(opts.Log, rec, threshold)

		if out.Passed || i == maxIters {
			out.Transcript = append(out.Transcript, rec)
			break
		}

		next, ex, rerr := bld.Refine(ctx, cur, t, verdict)
		rec.Refine = &ex
		out.Transcript = append(out.Transcript, rec)
		if rerr != nil {
			logf(opts.Log, "  [tune] refine failed, keeping last image: %v\n", rerr)
			break
		}
		logRefine(opts.Log, cur, next)
		cur = next
	}
	return out, nil
}

func randSeed() int64 {
	max := new(big.Int).Lsh(big.NewInt(1), 63)
	n, err := rand.Int(rand.Reader, max)
	if err != nil {
		return 1
	}
	return n.Int64()
}

func logf(w io.Writer, format string, args ...any) {
	if w != nil {
		fmt.Fprintf(w, format, args...)
	}
}

func logIter(w io.Writer, rec IterRecord, threshold float64) {
	if w == nil {
		return
	}
	status := "FAIL"
	if rec.Verdict.Score >= threshold {
		status = "PASS"
	}
	fmt.Fprintf(w, "  [tune] iter %d: score=%.1f [%s]", rec.N, rec.Verdict.Score, status)
	if len(rec.Verdict.Issues) > 0 {
		fmt.Fprintf(w, " issues: %v", rec.Verdict.Issues)
	}
	fmt.Fprintln(w)
}

func logRefine(w io.Writer, cur, next Prompt) {
	if w == nil {
		return
	}
	if cur.Positive != next.Positive {
		fmt.Fprintf(w, "  [tune] refined positive prompt\n")
	}
	if cur.Negative != next.Negative {
		fmt.Fprintf(w, "  [tune] refined negative prompt\n")
	}
}
