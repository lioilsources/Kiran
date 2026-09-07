package audio

import (
	"fmt"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// requireFFmpeg přeskočí test, když ffmpeg není. QA na něm stojí celá, ale
// Kirian CI Go pipeline nestaví, takže tvrdý fail by nikomu nepomohl.
func requireFFmpeg(t *testing.T) {
	t.Helper()
	if _, err := exec.LookPath("ffmpeg"); err != nil {
		t.Skip("ffmpeg není k dispozici")
	}
}

// makeOgg vyrobí testovací OGG z lavfi filtru se zadaným zeslabením.
func makeOgg(t *testing.T, name, lavfi string, gainDB float64) string {
	t.Helper()
	requireFFmpeg(t)
	path := filepath.Join(t.TempDir(), name)
	args := append([]string{"-v", "error", "-y", "-f", "lavfi", "-i", lavfi,
		"-af", fmt.Sprintf("volume=%.2fdB", gainDB)}, oggEncoder()...)
	out, err := exec.Command("ffmpeg", append(args, path)...).CombinedOutput()
	if err != nil {
		t.Fatalf("ffmpeg: %v\n%s", err, out)
	}
	return path
}

// oggEncoder vrací zabudovaný vorbis encoder místo libvorbis: ten na Macu
// v homebrew buildu ffmpeg chybí, kdežto nativní `vorbis` je vždycky.
// Vyžaduje stereo a -strict -2, protože je značený jako experimentální.
func oggEncoder() []string {
	return []string{"-ac", "2", "-c:a", "vorbis", "-strict", "-2"}
}

// measuredLUFS vrátí naměřenou hlasitost souboru, aby se testy délky a ticha
// nerozbíjely o toleranci hlasitosti.
func measuredLUFS(t *testing.T, path string) float64 {
	t.Helper()
	lufs, _, err := measureLoudness(path)
	if err != nil {
		t.Fatalf("measureLoudness: %v", err)
	}
	return lufs
}

func TestCheckAssetPassesCleanSFX(t *testing.T) {
	path := makeOgg(t, "sfx.ogg", "sine=frequency=800:duration=0.5", -15)
	entry := &Entry{ID: "fire_bullet", DurationS: 0.5}

	res, err := CheckAsset(path, entry, measuredLUFS(t, path))
	if err != nil {
		t.Fatalf("CheckAsset: %v", err)
	}
	if !res.OK() {
		t.Errorf("čistý efekt označen: %v", res.Flags)
	}
	if res.Duration < 0.4 || res.Duration > 0.6 {
		t.Errorf("délka = %.2f s", res.Duration)
	}
}

func TestCheckAssetFlagsWrongDuration(t *testing.T) {
	path := makeOgg(t, "long.ogg", "sine=frequency=800:duration=3", -15)
	entry := &Entry{ID: "fire_bullet", DurationS: 0.5}

	res, err := CheckAsset(path, entry, measuredLUFS(t, path))
	if err != nil {
		t.Fatalf("CheckAsset: %v", err)
	}
	if !hasFlag(res.Flags, "délka") {
		t.Errorf("špatná délka neoznačena: %v", res.Flags)
	}
}

func TestCheckAssetFlagsLoudnessDrift(t *testing.T) {
	path := makeOgg(t, "quiet.ogg", "sine=frequency=800:duration=2", -40)
	entry := &Entry{ID: "pickup", DurationS: 2}

	res, err := CheckAsset(path, entry, -18)
	if err != nil {
		t.Fatalf("CheckAsset: %v", err)
	}
	if !hasFlag(res.Flags, "hlasitost") {
		t.Errorf("tichý asset neoznačen: %v (%.1f LUFS)", res.Flags, res.LUFS)
	}
}

func TestCheckAssetFlagsLeadingSilence(t *testing.T) {
	requireFFmpeg(t)
	path := filepath.Join(t.TempDir(), "lead.ogg")
	// 0,3 s ticha, pak tón — přesně to, co má trim v post-processingu uříznout.
	// Náběhové ticho posouvá odezvu hry, proto je to samostatný QA příznak.
	filter := "anullsrc=r=44100:cl=mono,atrim=0:0.3[s];" +
		"sine=frequency=800:duration=0.5[t];[s][t]concat=n=2:v=0:a=1,volume=-15dB[o]"
	out, err := exec.Command("ffmpeg", append([]string{"-v", "error", "-y",
		"-filter_complex", filter, "-map", "[o]"}, append(oggEncoder(), path)...)...).CombinedOutput()
	if err != nil {
		t.Fatalf("ffmpeg: %v\n%s", err, out)
	}

	entry := &Entry{ID: "fire_bullet", DurationS: 0.8}
	res, err := CheckAsset(path, entry, measuredLUFS(t, path))
	if err != nil {
		t.Fatalf("CheckAsset: %v", err)
	}
	if !hasFlag(res.Flags, "ticho na začátku") {
		t.Errorf("náběhové ticho neoznačeno: %v", res.Flags)
	}
}

func TestLoopEntrySkipsLeadingSilenceCheck(t *testing.T) {
	// Hudební smyčka smí začínat tiše — to je hudební rozhodnutí, ne vada.
	requireFFmpeg(t)
	path := makeOgg(t, "loop.ogg", "sine=frequency=200:duration=8", -15)
	entry := &Entry{ID: "theme_1", DurationS: 10, Loop: true}

	res, err := CheckAsset(path, entry, measuredLUFS(t, path))
	if err != nil {
		t.Fatalf("CheckAsset: %v", err)
	}
	if hasFlag(res.Flags, "ticho na začátku") {
		t.Errorf("u smyčky se náběhové ticho neřeší: %v", res.Flags)
	}
}

func TestLoopLevelJumpDetectsSilentEnd(t *testing.T) {
	window := int(analysisWindowS * sampleRate)
	samples := make([]float32, window*10)
	for i := range samples {
		samples[i] = 0.5
	}
	if got := loopLevelJump(samples); got > 0.01 {
		t.Errorf("stejně hlasité konce = %.3f", got)
	}
	// Doběh do ticha na konci — to dělaly stopy z ElevenLabs.
	for i := len(samples) - window; i < len(samples); i++ {
		samples[i] = 0.0005
	}
	if got := loopLevelJump(samples); got < loopLevelThreshold {
		t.Errorf("doběh do ticha = %.3f, měl překročit %.2f", got, loopLevelThreshold)
	}
}

func TestLeadingSilenceMeasuresOffset(t *testing.T) {
	samples := make([]float32, sampleRate)
	for i := sampleRate / 2; i < len(samples); i++ {
		samples[i] = 0.5
	}
	if got := leadingSilence(samples, sampleRate); got < 0.45 || got > 0.55 {
		t.Errorf("ticho = %.3f s, čekal ~0,5", got)
	}
}

func TestClippedRunsIgnoresIsolatedPeaks(t *testing.T) {
	// Ojedinělé vzorky na stropu jsou artefakt Vorbisu, ne klip.
	if got := clippedRuns([]float32{0.1, 1.0, -1.0, 0.5, 0.99}); got != 0 {
		t.Errorf("izolované špičky nemají být klip, got=%d", got)
	}
	// Tři a víc za sebou = signál useknutý naplocho.
	if got := clippedRuns([]float32{0.2, 1.0, 1.0, 1.0, 0.2}); got != 1 {
		t.Errorf("useknutý úsek nebyl zachycen, got=%d", got)
	}
	if got := clippedRuns([]float32{1.0, 1.0, 1.0, 0.1, -1.0, -1.0, -1.0}); got != 2 {
		t.Errorf("dva úseky = %d", got)
	}
}

func TestCheckDurationToleratesLoopCrossfade(t *testing.T) {
	// Smyčka je o prolnutí kratší než zadání — to je záměr post-processingu.
	if flags := checkDuration(38, &Entry{DurationS: 40, Loop: true}); len(flags) != 0 {
		t.Errorf("38 s pro 40s smyčku nemá být příznak: %v", flags)
	}
	// Ořez ticha ubere víc než prolnutí — 32 s ze 40 je normální výsledek.
	if flags := checkDuration(32, &Entry{DurationS: 40, Loop: true}); len(flags) != 0 {
		t.Errorf("32 s pro 40s smyčku je po ořezu v normě: %v", flags)
	}
	if flags := checkDuration(20, &Entry{DurationS: 40, Loop: true}); len(flags) == 0 {
		t.Error("20 s pro 40s smyčku je hrubý propad a mělo být označeno")
	}
	// Jednorázovka po ořezu taky vyjde kratší — model dopadává tichem.
	if flags := checkDuration(7.5, &Entry{DurationS: 12}); len(flags) != 0 {
		t.Errorf("7,5 s pro 12s intro je po ořezu v normě: %v", flags)
	}
	if flags := checkDuration(4, &Entry{DurationS: 12}); len(flags) == 0 {
		t.Error("4 s pro 12s intro je hrubý propad a mělo být označeno")
	}
}

func hasFlag(flags []string, substr string) bool {
	for _, f := range flags {
		if strings.Contains(f, substr) {
			return true
		}
	}
	return false
}

func TestTrailingSilenceMeasuresTail(t *testing.T) {
	samples := make([]float32, sampleRate)
	for i := 0; i < sampleRate/2; i++ {
		samples[i] = 0.5
	}
	if got := trailingSilence(samples, sampleRate); got < 0.45 || got > 0.55 {
		t.Errorf("ticho na konci = %.3f s, čekal ~0,5", got)
	}
	loud := []float32{0.5, 0.5, 0.5}
	if got := trailingSilence(loud, sampleRate); got != 0 {
		t.Errorf("bez ticha na konci má vyjít 0, got %.4f", got)
	}
}
