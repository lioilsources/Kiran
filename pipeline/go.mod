module tyrian-pipeline

go 1.23

require (
	github.com/ol1n/AiStack/pkg/audioclient v0.0.0
	gopkg.in/yaml.v3 v3.0.1
)

// AiStack není publikovaný modul (repo je lioilsources/AiStack, cesta modulu
// github.com/ol1n/AiStack/… se nedá stáhnout), takže se bere z pracovní kopie
// vedle tohohle repa. Kirian CI Go pipeline nestaví — buildí se jen Flutter —
// takže tahle závislost je čistě pro lokální regeneraci assetů.
replace github.com/ol1n/AiStack/pkg/audioclient => ../../AiStack/pkg/audioclient
