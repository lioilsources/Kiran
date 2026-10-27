package comfyuiimage

import "testing"

// The schnell preset in cmd/generate relies on these three overrides landing
// on the right nodes of the embedded flux workflow: UNETLoader "1",
// FluxGuidance "7", KSampler "8".
func TestBuildWorkflowAppliesSchnellOverrides(t *testing.T) {
	c := NewClient("http://example", "", "",
		WithCheckpoint("flux1-schnell.safetensors"),
		WithSteps(4),
		WithGuidance(1.0),
	)
	graph, err := c.buildWorkflow("p", "", "x", 1024, 2048, 1, 7)
	if err != nil {
		t.Fatalf("buildWorkflow: %v", err)
	}
	inputs := func(id string) map[string]any {
		return graph[id].(map[string]any)["inputs"].(map[string]any)
	}
	if got := inputs("1")["unet_name"]; got != "flux1-schnell.safetensors" {
		t.Errorf("unet_name = %v", got)
	}
	if got := inputs("8")["steps"]; got != 4 {
		t.Errorf("steps = %v (%T), want 4", got, got)
	}
	if got := inputs("7")["guidance"]; got != 1.0 {
		t.Errorf("guidance = %v, want 1.0", got)
	}
}

// Zero values must leave the workflow file's numbers alone (dev stays 20/3.5).
func TestBuildWorkflowKeepsDefaultsWithoutOverrides(t *testing.T) {
	c := NewClient("http://example", "", "")
	graph, err := c.buildWorkflow("p", "", "x", 1024, 1024, 1, 7)
	if err != nil {
		t.Fatalf("buildWorkflow: %v", err)
	}
	sampler := graph["8"].(map[string]any)["inputs"].(map[string]any)
	if sampler["steps"] != float64(20) {
		t.Errorf("steps = %v, want workflow default 20", sampler["steps"])
	}
	guidance := graph["7"].(map[string]any)["inputs"].(map[string]any)
	if guidance["guidance"] != 3.5 {
		t.Errorf("guidance = %v, want workflow default 3.5", guidance["guidance"])
	}
}

// A workflow without a guidance node (pony) must not fail on WithGuidance.
func TestBuildWorkflowGuidanceIgnoredWithoutNode(t *testing.T) {
	c := NewClient("http://example", "", "",
		WithWorkflow(PonyWorkflow()),
		WithNodeRoles(PonyNodeRoles()),
		WithGuidance(1.0),
		WithSteps(4),
	)
	graph, err := c.buildWorkflow("p", "n", "x", 1024, 1024, 1, 7)
	if err != nil {
		t.Fatalf("buildWorkflow: %v", err)
	}
	sampler := graph["3"].(map[string]any)["inputs"].(map[string]any)
	if sampler["steps"] != 4 {
		t.Errorf("steps = %v, want 4", sampler["steps"])
	}
}
