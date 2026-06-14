package prompttune

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

type textClient interface {
	Complete(ctx context.Context, system, user string) (string, error)
	Model() string
}

// Prompt is the positive + negative pair the builder produces.
type Prompt struct {
	Positive string
	Negative string // empty for Flux
	Workflow string // "pony" or ""
}

// Exchange is one request/response pair with the builder model.
type Exchange struct {
	Model    string
	Request  string
	Response string
}

// Builder rewrites an image prompt from validator feedback, keeping it in the
// correct dialect (Pony tag-soup vs Flux prose).
type Builder struct {
	c textClient
}

// NewBuilder wraps an instruct LLM client.
func NewBuilder(c textClient) *Builder { return &Builder{c: c} }

const builderSystem = `You are an expert prompt engineer for text-to-image models used in a 2D game asset pipeline.
You are given:
- The game sprite the image must depict (with constraints)
- The current image prompt
- A QA reviewer's critique of the last generated image

Rewrite the prompt so the NEXT generation fixes the reviewer's issues while still satisfying all constraints.

Rules:
- Keep the prompt in the required dialect (described below). Do not switch styles.
- Do not remove the game-specific constraint language (view angle, background, etc.)
- Output ONLY a JSON object, no prose:
  {"positive": "...", "negative": "..."}
  For Flux dialect, return an empty "negative".

Dialect: %s`

// dialectGuide returns prompt-writing instructions for the given workflow.
func dialectGuide(workflow string) string {
	if workflow == "pony" {
		return `Pony/SDXL dialect: comma-separated tag soup, NOT prose.
Always start with the quality preamble: "score_9, score_8_up, score_7_up, score_6_up, score_5_up, source_anime, rating_safe".
Use danbooru-style tags for the subject, pose, and setting. Weight emphasis with (tag:1.2).
Provide a full negative prompt of unwanted tags.`
	}
	return `Flux dialect: one natural-language sentence describing the subject, its attributes and constraints
(e.g. "A large rocky asteroid with cratered surface, top-down orthographic view, flat solid white background.").
Distilled Flux ignores negative prompts, so fold anything to avoid into the positive sentence. Leave "negative" empty.`
}

// Refine produces an improved prompt from validator feedback.
func (b *Builder) Refine(ctx context.Context, cur Prompt, t Target, v Verdict) (Prompt, Exchange, error) {
	system := fmt.Sprintf(builderSystem, dialectGuide(cur.Workflow))

	var user strings.Builder
	user.WriteString("Game sprite to depict:\n")
	user.WriteString(t.Describe())
	user.WriteString("\nCurrent positive prompt:\n")
	user.WriteString(cur.Positive)
	if cur.Negative != "" {
		user.WriteString("\n\nCurrent negative prompt:\n")
		user.WriteString(cur.Negative)
	}
	user.WriteString(fmt.Sprintf("\n\nReviewer score: %.1f/10\n", v.Score))
	if len(v.Issues) > 0 {
		user.WriteString("Reviewer issues:\n- ")
		user.WriteString(strings.Join(v.Issues, "\n- "))
		user.WriteString("\n")
	}
	if len(v.Suggestions) > 0 {
		user.WriteString("Reviewer suggestions:\n- ")
		user.WriteString(strings.Join(v.Suggestions, "\n- "))
		user.WriteString("\n")
	}

	ex := Exchange{Model: b.c.Model(), Request: user.String()}
	raw, err := b.c.Complete(ctx, system, user.String())
	if err != nil {
		return Prompt{}, ex, fmt.Errorf("builder call: %w", err)
	}
	ex.Response = raw

	jsonStr, err := extractJSON(raw)
	if err != nil {
		return Prompt{}, ex, fmt.Errorf("builder returned no JSON: %w", err)
	}
	var parsed struct {
		Positive string `json:"positive"`
		Negative string `json:"negative"`
	}
	if err := json.Unmarshal([]byte(jsonStr), &parsed); err != nil {
		return Prompt{}, ex, fmt.Errorf("parse builder JSON: %w", err)
	}
	if strings.TrimSpace(parsed.Positive) == "" {
		return Prompt{}, ex, fmt.Errorf("builder returned empty positive prompt")
	}
	return Prompt{Positive: parsed.Positive, Negative: parsed.Negative, Workflow: cur.Workflow}, ex, nil
}
