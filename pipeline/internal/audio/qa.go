package audio

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"math"
	"os/exec"
	"strconv"
	"strings"
)

// QA prahy. Nejsou to náhodná čísla: hlasitost cílí služba na −16/−18 LUFS
// s tolerancí, kterou dá normalizace krátkých stop; peak −0,5 dBTP je půl
// decibelu nad limiterem, takže cokoli výš znamená, že limiter neúčinkoval.
const (
	loudnessToleranceLU = 3.0
	peakCeilingDBTP     = -0.5
	maxLeadSilenceS     = 0.05
	maxTailSilenceS     = 0.15
	// Poměr hlasitosti obou konců smyčky. Hudba na krajích běžně kolísá
	// o pár decibelů (naměřeno 0,34 mezi dvěma sousedními okny uvnitř jedné
	// souvislé stopy), takže se hlídá až případ, kdy je jeden konec prakticky
	// ticho — což je přesně to, co dělaly stopy z ElevenLabs.
	loopLevelThreshold = 0.75
	analysisWindowS    = 0.05
)

// QAResult je výsledek kontroly jednoho souboru.
type QAResult struct {
	File     string
	Duration float64
	LUFS     float64
	PeakDBTP float64
	Flags    []string
}

// OK říká, jestli asset prošel bez připomínek.
func (r QAResult) OK() bool { return len(r.Flags) == 0 }

// CheckAsset proveří jeden vygenerovaný soubor.
//
// Nic nefailuje celý běh — vrací příznaky, které audiogen zapíše do manifestu.
// Jeden podezřelý asset z 384 nesmí shodit regeneraci ostatních; plán §4.4
// to říká výslovně.
func CheckAsset(path string, entry *Entry, targetLUFS float64) (QAResult, error) {
	res := QAResult{File: path}

	dur, err := probeDuration(path)
	if err != nil {
		return res, err
	}
	res.Duration = dur

	lufs, peak, err := measureLoudness(path)
	if err != nil {
		return res, err
	}
	res.LUFS, res.PeakDBTP = lufs, peak

	res.Flags = append(res.Flags, checkDuration(dur, entry)...)

	if math.Abs(lufs-targetLUFS) > loudnessToleranceLU {
		res.Flags = append(res.Flags, fmt.Sprintf("hlasitost %.1f LUFS mimo %.0f±%.0f", lufs, targetLUFS, loudnessToleranceLU))
	}
	if peak > peakCeilingDBTP {
		res.Flags = append(res.Flags, fmt.Sprintf("peak %.2f dBTP nad stropem %.1f — limiter neúčinkoval", peak, peakCeilingDBTP))
	}

	samples, err := decodeMono(path)
	if err != nil {
		return res, err
	}
	if len(samples) == 0 {
		res.Flags = append(res.Flags, "prázdný signál")
		return res, nil
	}

	if entry.Loop {
		if jump := loopLevelJump(samples); jump > loopLevelThreshold {
			res.Flags = append(res.Flags, fmt.Sprintf("konce smyčky mají jinou hlasitost (%.2f) — jeden je skoro ticho", jump))
		}
	} else {
		// Náběhové ticho posouvá herní odezvu: efekt zahraný na výstřel
		// dorazí o tolik později, kolik je ticha na začátku.
		if lead := leadingSilence(samples, sampleRate); lead > maxLeadSilenceS {
			res.Flags = append(res.Flags, fmt.Sprintf("ticho na začátku %.0f ms", lead*1000))
		}
		// Ticho na konci odezvu neposouvá, ale znamená, že ořez neproběhl —
		// a u efektu, který se přehrává stokrát za level, je to zbytečný
		// dekód i zbytečné bajty v buildu.
		if tail := trailingSilence(samples, sampleRate); tail > maxTailSilenceS {
			res.Flags = append(res.Flags, fmt.Sprintf("ticho na konci %.0f ms", tail*1000))
		}
	}

	if runs := clippedRuns(samples); runs > 0 {
		res.Flags = append(res.Flags, fmt.Sprintf("%d úseků na plném rozsahu — klip", runs))
	}
	return res, nil
}

func checkDuration(dur float64, entry *Entry) []string {
	target := entry.DurationS
	if target <= 0 {
		return nil
	}
	// Smyčka je o prolnutí kratší než zadání — to je záměr, ne chyba.
	lo, hi := target*0.8, target*1.2
	if entry.Loop {
		// Smyčka je kratší než zadání ze dvou důvodů: prolnutí ubere svou
		// délku a ořez ubere ticho, kterým model dopadává na požadovanou
		// stopáž. Naměřeno na ACE-Stepu: ze 40 s vyjde 32–37 s. Pro herní
		// smyčku je přesná délka jedno, hlídá se jen hrubý propad.
		lo, hi = target*0.7, target+1.0
	} else {
		// Jednorázovky (intro, stingery) jsou po ořezu taky kratší: model
		// dopadává na požadovanou stopáž tichem. Naměřeno: ze 12 s intra
		// zbude 7 s reálné hudby. Hlídá se jen hrubý propad.
		lo = target * 0.6
	}
	if dur < lo || dur > hi {
		return []string{fmt.Sprintf("délka %.2fs mimo očekávaných %.2f–%.2fs", dur, lo, hi)}
	}
	return nil
}

const sampleRate = 44100

func probeDuration(path string) (float64, error) {
	out, err := exec.Command("ffprobe", "-v", "error",
		"-show_entries", "format=duration",
		"-of", "default=noprint_wrappers=1:nokey=1", path).Output()
	if err != nil {
		return 0, fmt.Errorf("ffprobe %s: %w", path, err)
	}
	return strconv.ParseFloat(strings.TrimSpace(string(out)), 64)
}

// measureLoudness vrátí integrovanou hlasitost a true peak přes loudnorm.
// Krátké soubory se doplní tichem na 3 s, jinak loudnorm měření odmítne.
func measureLoudness(path string) (lufs, peak float64, err error) {
	cmd := exec.Command("ffmpeg", "-hide_banner", "-nostats", "-i", path,
		"-af", "apad=whole_dur=3,loudnorm=print_format=json", "-f", "null", "-")
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return 0, 0, fmt.Errorf("loudnorm %s: %w", path, err)
	}
	text := stderr.String()
	lufs, err = jsonNumber(text, "input_i")
	if err != nil {
		return 0, 0, err
	}
	peak, err = jsonNumber(text, "input_tp")
	if err != nil {
		return 0, 0, err
	}
	return lufs, peak, nil
}

// jsonNumber vytáhne "klíč" : "číslo" z loudnorm výstupu bez plného parsování —
// loudnorm ho tiskne na stderr promíchaný s logem.
func jsonNumber(text, key string) (float64, error) {
	idx := strings.LastIndex(text, `"`+key+`"`)
	if idx < 0 {
		return 0, fmt.Errorf("loudnorm nevrátil %s", key)
	}
	rest := text[idx+len(key)+2:]
	start := strings.Index(rest, `"`)
	if start < 0 {
		return 0, fmt.Errorf("%s: chybí hodnota", key)
	}
	rest = rest[start+1:]
	end := strings.Index(rest, `"`)
	if end < 0 {
		return 0, fmt.Errorf("%s: neuzavřená hodnota", key)
	}
	value := strings.TrimSpace(rest[:end])
	if value == "-inf" {
		return -70, nil
	}
	return strconv.ParseFloat(value, 64)
}

// decodeMono načte soubor jako mono float32 přes ffmpeg.
func decodeMono(path string) ([]float32, error) {
	out, err := exec.Command("ffmpeg", "-v", "error", "-i", path,
		"-ac", "1", "-ar", strconv.Itoa(sampleRate),
		"-f", "f32le", "-acodec", "pcm_f32le", "-").Output()
	if err != nil {
		return nil, fmt.Errorf("dekódování %s: %w", path, err)
	}
	samples := make([]float32, len(out)/4)
	for i := range samples {
		samples[i] = math.Float32frombits(binary.LittleEndian.Uint32(out[i*4:]))
	}
	return samples, nil
}

// Detekce lupnutí na úrovni vzorků tu záměrně není.
//
// Vorbis je lapped transform a dekodér každý soubor rozjíždí náběhem přes
// první okno — naměřeno 128 až 256 vzorků (3–6 ms), než se dostane na plnou
// úroveň. Na švu smyčky to vypadá jako nespojitost, ale je to vlastnost
// kontejneru, ne assetu: mají ji všechny OGG, které hra veze, včetně těch
// původních. Metrika postavená na rozdílu sousedních vzorků by tedy označila
// každou smyčku a neřekla nic o tom, co pipeline vyrobila. Co smysl dává, je
// rozdíl hlasitosti konců — přesně ta vada, kterou měly stopy z ElevenLabs
// (doběh do ticha).

// loopLevelJump porovnává hlasitost obou konců smyčky (0 = shodná, 1 = jeden je ticho).
func loopLevelJump(samples []float32) float64 {
	window := int(analysisWindowS * sampleRate)
	if len(samples) < 2*window {
		return 0
	}
	head := rms(samples[:window])
	tail := rms(samples[len(samples)-window:])
	loudest := math.Max(head, tail)
	if loudest < 1e-6 {
		return 0
	}
	return math.Abs(head-tail) / loudest
}

func rms(samples []float32) float64 {
	var sum float64
	for _, s := range samples {
		sum += float64(s) * float64(s)
	}
	return math.Sqrt(sum / float64(len(samples)))
}

func leadingSilence(samples []float32, rate int) float64 {
	const threshold = 0.003 // ≈ −50 dBFS
	for i, s := range samples {
		if math.Abs(float64(s)) > threshold {
			return float64(i) / float64(rate)
		}
	}
	return float64(len(samples)) / float64(rate)
}

func trailingSilence(samples []float32, rate int) float64 {
	const threshold = 0.003 // ≈ −50 dBFS
	for i := len(samples) - 1; i >= 0; i-- {
		if math.Abs(float64(samples[i])) > threshold {
			return float64(len(samples)-1-i) / float64(rate)
		}
	}
	return float64(len(samples)) / float64(rate)
}

// clippedRuns počítá úseky aspoň tří po sobě jdoucích vzorků na plném rozsahu.
//
// Jednotlivé vzorky na stropu nestačí: Vorbis je ztrátový a dekodér špičku
// běžně přestřelí o kousek, takže se i v čistě znormalizované stopě najde pár
// vzorků na 1.0, aniž by tam byl slyšet klip (měřeno: 40 vzorků z 1,7 milionu).
// Skutečný klip signál usekne naplocho, tedy v sérii.
func clippedRuns(samples []float32) int {
	const (
		ceiling = 0.9995
		minRun  = 3
	)
	var runs, run int
	for _, s := range samples {
		if math.Abs(float64(s)) >= ceiling {
			run++
			if run == minRun {
				runs++
			}
			continue
		}
		run = 0
	}
	return runs
}
