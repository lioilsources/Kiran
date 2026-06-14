package prompttune

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

type visionClient interface {
	CompleteVision(ctx context.Context, system, user string, img []byte) (Verdict, error)
	Model() string
}

// visionAdapter wraps an llm.Client (which returns string) to satisfy visionClient.
// We keep llm.Client dependency-free of prompttune by using an adapter here.
type RawVisionClient interface {
	CompleteVision(ctx context.Context, system, user string, img []byte) (string, error)
	Model() string
}

// Verdict is the validator's judgement of one image.
type Verdict struct {
	Score       float64  `json:"score"`
	Pass        bool     `json:"pass"`
	Issues      []string `json:"issues"`
	Suggestions []string `json:"suggestions"`
	Model       string   `json:"-"`
	RawRequest  string   `json:"-"`
	RawResponse string   `json:"-"`
}

// Validator scores how well a generated image satisfies the target using a
// vision-language model.
type Validator struct {
	c RawVisionClient
}

// NewValidator wraps a vision-capable LLM client.
func NewValidator(c RawVisionClient) *Validator { return &Validator{c: c} }

const validatorSystem = `You are a strict visual QA reviewer for a 2D space-shooter game asset pipeline.
You are shown one AI-generated image and a description of the game sprite it must depict.
Judge ONLY whether the image satisfies ALL of the listed constraints and correctly shows the described subject.

Respond with ONLY a JSON object, no prose, in exactly this shape:
{"score": <0-10 number>, "pass": <true|false>, "issues": ["..."], "suggestions": ["concrete prompt changes to fix the issues"]}

Scoring guide:
10 = perfect: correct subject, all constraints satisfied, sprite-ready
8-9 = correct subject, minor nits on style or framing
5-7 = recognizable but with notable constraint violations (wrong angle, wrong background color, etc.)
0-4 = wrong subject, background not flat, or critical constraint broken

Set "pass" to true only for score >= 8.
For "suggestions", give specific prompt wording changes — do not say "add more detail", say what detail to add.`

// Validate sends the image and target to the vision model and parses its verdict.
func (v *Validator) Validate(ctx context.Context, img []byte, t Target) (Verdict, error) {
	user := "Game sprite to evaluate:\n" + t.Describe() + "\nReview the attached image against all constraints above."
	raw, err := v.c.CompleteVision(ctx, validatorSystem, user, img)
	if err != nil {
		return Verdict{Model: v.c.Model(), RawRequest: user}, fmt.Errorf("validator call: %w", err)
	}
	jsonStr, err := extractJSON(raw)
	if err != nil {
		return Verdict{Model: v.c.Model(), RawRequest: user, RawResponse: raw},
			fmt.Errorf("validator returned no JSON: %w", err)
	}
	var verdict Verdict
	if err := json.Unmarshal([]byte(jsonStr), &verdict); err != nil {
		return Verdict{Model: v.c.Model(), RawRequest: user, RawResponse: raw},
			fmt.Errorf("parse validator JSON: %w", err)
	}
	verdict.Model = v.c.Model()
	verdict.RawRequest = user
	verdict.RawResponse = raw
	return verdict, nil
}

// extractJSON finds the first {...} block in s.
func extractJSON(s string) (string, error) {
	start := strings.Index(s, "{")
	end := strings.LastIndex(s, "}")
	if start == -1 || end == -1 || end <= start {
		return "", fmt.Errorf("no JSON object found")
	}
	return s[start : end+1], nil
}
