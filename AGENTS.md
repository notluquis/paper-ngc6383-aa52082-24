# paper-ngc6383-aa52082-24 — orientación para agentes

Repo del paper A&A **aa52082-24** (NGC 6383), aceptado 2026-09-15. Extraído de
`github.com/notluquis/erotica` (tag `p01-pre-extraction`) con historia filtrada -- ver
`README.md` y `provenance/erotica-commit-map.txt`. En el hub privado del programa
(`~/phd`, no público) este paper se identifica como **P01**; ese nombre no aparece en
ningún otro texto público de este repo.

## Fuente de verdad

- El manuscrito: `submission_package/clean_source/aa52082-24.tex`. Nada más lo deriva --
  `submission_package/aa52082-24_revised_clean.pdf` es un build, no una segunda fuente.
- El catálogo entregado al CDS: `cds_final/table2.dat` + `cds_final/ReadMe`.
- Las cartas de la ronda 3 en `submission_package/letters/` son registro, no se
  reenvían (el paper ya fue aceptado); no las edites para "actualizarlas".

## El gate

`submission_package/gate.py` es el comando que tiene que pasar antes de tocar el
manuscrito o subir algo. Antes de cualquier PR: `python3 gate.py --allow-skips` desde
`submission_package/`. Ver `README.md` § "Cómo correr el gate" para el resto de los
comandos y por qué `--allow-skips` es necesario acá (el check `[kb]` depende del hub
privado, que no existe fuera de la máquina del autor).

Antes de endurecer o aflojar cualquier check del gate, lee `tools/manuscript_gate.py`
-- es un vendored de erotica (`tools/VENDORED.toml` declara commit + sha256;
`tools/check_vendored.py` lo verifica en CI). No lo edites acá: un cambio real va en
erotica y se re-vendoriza después.

## Qué no tocar

- `_legacy/`, `referee_round2/`, `referee_round3/` -- registro histórico, no se
  reescribe con hindsight.
- Los zips gitignorados en `submission_package/` (`aa52082-24_source.zip`,
  `aa52082-24_cds_table2.zip`) son artefactos regenerables que el gate necesita
  localmente; no los comitees.
- `review_repo/` y `validation/ngc6383_selection_function.py` hardcodean rutas
  absolutas a `/Users/notluquis/erotica/...` (30 ficheros) -- ver README, no se
  reescriben en esta extracción.
- Nunca dos compilaciones LaTeX a la vez sobre el mismo árbol.

## Fuera de alcance de este repo

El paquete Python `erotica` (clustering, isochrone fitting, todo lo que regenera el
análisis desde cero) vive en `github.com/notluquis/erotica`; este repo sólo contiene
el paper y los scripts de validación que producen sus cifras.
