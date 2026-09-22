# paper-ngc6383-aa52082-24

Fuente completa del paper de Astronomy & Astrophysics **aa52082-24**, "Characterizing NGC 6383: A
study of fundamental properties, pre-main sequence stars, mass segregation, and age using Gaia
DR3 and 2MASS data" (Pulgar-Escobar, Henríquez-Salgado, Mennickent, Cerulo), **aceptado el
2026-09-15**.

## Identifiers

| tipo | valor | estado |
|---|---|---|
| manuscrito A&A | `aa52082-24` | existe |
| DOI del artículo | `10.1051/0004-6361/202452082` (patrón esperado, sin confirmar) | pendiente |
| arXiv | `10.48550/arXiv.2405.09145` (v1 = versión ronda 1) | existe |
| bibcode ADS | — | pendiente |
| catálogo CDS | `J/A+A/...` | pendiente |
| DOI Zenodo de este repo | — | pendiente |

Ver `CITATION.cff` para el registro tipado completo (formato CFF 1.2.0, validado contra el schema
oficial; los identificadores pendientes están comentados ahí con `# TODO al publicar:`).

## Estructura

```
submission_package/   el paquete que se sube a A&A: gate.py, clean_source/, marked_changes/,
                       letters/, cds/, zips de entrega (algunos ignorados, ver abajo)
cds_final/             ReadMe + table2.dat que va al CDS (fuera de submission_package porque el
                       CDS ahora recibe el envío directo, no vía NESTOR)
_legacy/                cds_round2_submitted/cds.zip y cds_superseded/cds.zip -- líneas base de
                       lo que NESTOR tuvo en rondas previas, trackeadas a la fuerza pese a que el
                       directorio está en .gitignore (ver el comentario ahí)
referee_round2/, referee_round3/   registro de las rondas de arbitraje, no se reconstruyen
review_repo/            auditoría independiente de la ronda de revisión (scripts regen_*.py,
                       notas de verificación); 30 de sus ficheros hardcodean rutas absolutas a
                       erotica -- ver "Dependencia de EROTICA" abajo
clustering_audit/, radius_robustness/, hd159176_gaia_quality/, rauw_halpha/
                       auditorías de robustez que el paper cita
validation/            8 scripts (`ngc6383_*.py`, `ngc6383_profile_comparison.json`) que producen
                       cifras citadas en el paper, incl. el generador de table2.dat; vivían en
                       erotica/tools/validation/
tools/manuscript_gate.py   motor genérico del gate, vendorizado desde erotica (ver "El gate" abajo)
provenance/erotica-commit-map.txt   mapa SHA viejo -> SHA nuevo de la extracción de historia
```

## Cómo compilar

```bash
cd submission_package/clean_source
latexmk -pdf aa52082-24.tex
```

Nunca corras dos compilaciones LaTeX a la vez sobre el mismo árbol (los `.aux`/`.bbl` se pisan).

## Cómo correr el gate

El gate es el chequeo de consistencia que tiene que pasar antes de subir o comitear el
manuscrito -- compara el `.tex` contra las cartas, el ReadMe del CDS, la nota del grafo de
conocimiento y el catálogo entregado, y falla si alguno se desalineó en silencio.

```bash
cd submission_package
python3 gate.py --quick --allow-skips   # ~5 s, no compila LaTeX
python3 gate.py --allow-skips           # ~4 min, compila los dos documentos y arma el zip

python3 test_gate_behaviour.py          # el gate cumple lo que promete de si mismo
python3 test_gate_mutations.py --allow-skips   # cada check, roto a propósito, se pone rojo
```

`--allow-skips` es necesario porque `[kb] root = "~/phd/kb"` en `gate.toml` apunta al hub privado
del programa, que no existe fuera de la máquina del autor ni en CI -- ese único check se omite, no
falla. El mismo gate corre en GitHub Actions (`.github/workflows/manuscript.yml`).

**El gate completo (`gate.py` sin `--quick`) necesita un `.bbl` real en `clean_source/`.** El
check "el zip enviado compila solo" compara cada fichero de `aa52082-24_source.zip` byte a byte
contra `clean_source/`, y el zip trae `aa52082-24.bbl` -- un artefacto de compilación,
gitignorado, que un checkout limpio no tiene. En un árbol recién clonado con el zip copiado (ver
"Qué no viene acá"), ese check falla con "aa52082-24.bbl no existe en clean_source" hasta que
compiles una vez de más en el sitio real:

```bash
cd submission_package/clean_source && latexmk -pdf -bibtex -interaction=nonstopmode aa52082-24.tex
```

En CI esto no aplica: el zip está gitignorado, así que el checkout de GitHub Actions no lo trae y
el check se omite (`Skipped`) en vez de fallar -- el paquete que se sube se arma y valida en la
máquina del autor, donde el zip sí existe localmente.

## De dónde viene

Extraído de `github.com/notluquis/erotica` (rama `dev`, tag `p01-pre-extraction` =
`b3386f2d62b15d7b074ec53b905b2273a56cd23b`) el 2026-09-21, con `git filter-repo` sobre un clon --
la historia de commits que tocan estas rutas se conserva, todo lo demás del monorepo (el paquete
Python, otros papers) no. `provenance/erotica-commit-map.txt` traduce cada SHA viejo de erotica al
SHA nuevo de este repo. erotica en sí **no se purgó**: sigue teniendo estos mismos ficheros en su
propia historia hasta que se retiren de ahí en un paso posterior.

## Dependencia de EROTICA

El paquete Python `erotica` (`import erotica`) no viaja con este repo. Dos partes de este árbol lo
importan:

- `review_repo/` -- varios de sus scripts (`regen_*.py`, `convergence_audit*.py`, etc.)
- `validation/ngc6383_clustering_audit.py`

La versión que fija los resultados del paper es el árbol `dev` de erotica en el commit
`b3386f2d62b15d7b074ec53b905b2273a56cd23b` -- dicho así porque no es derivable a un release
etiquetado: no hay sidecar de procedencia que lo registre, y ese commit es posterior al único tag
existente (`v0.1.0` = `a61f41f`, el que está publicado en PyPI como `erotica` y en Zenodo con DOI
concepto `10.5281/zenodo.21769959`).

**30 ficheros** de este repo (29 en `review_repo/`, 1 en `validation/ngc6383_selection_function.py`)
hardcodean la ruta absoluta `/Users/notluquis/erotica/data/test/NGC6383/...` hacia datos que se
quedan en erotica (no se copiaron ni se reescribieron acá; ver `agent-findings/p01-extraction-plan.md`
en el hub para la clasificación original). Correr esos scripts fuera de una máquina con erotica
clonado en esa ruta exacta va a fallar por `FileNotFoundError`, no en silencio.

## Qué no viene acá

- El zip que sí se subió a NESTOR/CDS existe congelado en `_legacy/` y `cds_final/`, no se
  reconstruye.
- `data/`, `ASteCA/`, `MIST/`, `PARSEC/`, `25/`, `Tex_File/` (todo lo necesario para *regenerar*
  el análisis desde cero, en vez de sólo compilar el manuscrito ya escrito) se quedan en erotica.
- `submission_package/aa52082-24_source.zip` y `submission_package/aa52082-24_cds_table2.zip`
  están en el árbol de trabajo pero **gitignorados** (igual que en erotica): son artefactos
  regenerables que el gate necesita localmente para verificar el paquete que se sube, no fuente.
