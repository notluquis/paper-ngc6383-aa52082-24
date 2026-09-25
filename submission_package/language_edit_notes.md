# Edición de lenguaje de A&A (aa52082-24): notas de la editora

Recibida el 2026-09-25. Plazo: tres semanas. Es un paso obligatorio del proceso editorial y **no es una
revisión científica**: no cambia ninguna cifra, afirmación ni método. Nuestros cambios sobre su texto
están en `language_edit_changes.md`.

## Insumos

| fichero | qué es |
|---|---|
| `aa52082-24corr.tex` | el .tex corregido por la editora; ella exige usarlo como base. Commiteado sin tocar en `478a2ed` |
| `aa52082-24_diff.pdf` | 37 páginas: en azul lo que insertó, en rojo lo que tachó y sus notas. No está en el repo |
| `AA_English-Guide.pdf` | *A&A language guide for authors*, 7 páginas. No está en el repo: es un documento de A&A |

## El correo

**Es la paráfrasis que le pasaron al agente; el texto original no está en este repo.**

- Corrigió en su totalidad el resumen, la introducción, las conclusiones y los títulos de tablas y
  figuras.
- En el resto hizo ediciones no exhaustivas.
- Dejó instrucciones para aplicar en todo el texto.
- Si un cambio suyo contradice el significado, hay que reformularlo.
- Si queremos que revise nuestros cambios, se marcan (por ejemplo en rojo) y ese PDF se sube como
  fichero adicional. El fuente tiene que ser el .tex limpio, sin marcas.
- Pidió reactivar los paquetes y `\input` desactivados. **Verificado: no hay ninguno.** El
  preámbulo de `corr.tex` es idéntico byte a byte al nuestro (hasta `\begin{document}`). Trae los
  mismos seis `\usepackage` y ningún `\input` ni `\include`, y no queda ninguna línea comentada
  fuera de los `%` de final de línea de las tablas.

## Sus tres notas `\LEt{...}`, textuales

El macro está definido en `aa.cls` (L174 y L177) y se imprime en rojo como `[Note n: ...]`. Las
líneas son las de `corr.tex`.

| # | línea | texto | en la práctica |
|---|---|---|---|
| 1 | 179 (Sect. 4.1) | `Commas needed around units when preceded by the full name. ***` | símbolos o variables que siguen a su nombre completo van entre comas: "the mean, $\mu$," |
| 2 | 209 (Sect. 4.3) | `Only proper names ought to be capitalized***` | "Kernel Density Estimation" pasa a "kernel density estimation" |
| 3 | 332 (Sect. 7) | `Past tense required for the specific steps of the study, while general methods and results can remain in the present ***` | pasado para los pasos propios; presente para métodos generales y resultados |

La guía agrega, entre otras cosas, que **la editora no revisa los apéndices ni los agradecimientos**.
Por eso los apéndices quedan a nuestro cargo.

## Qué editó ella (medido contra nuestro fuente anterior, `88907e8`)

Hay 199 operaciones de palabra y todas son de lenguaje:

- comas alrededor de símbolos tras su nombre completo;
- "two-dimensional" y afines pasan a 2D/3D/1D/5D;
- "pre-main-sequence" pasa a PMS (o a "pre-main sequence" en su primera aparición);
- "main-sequence" pasa a "main sequence";
- voz y tiempo verbal ("we adopt" → "we adopted");
- "i.e.," → "namely,";
- dos párrafos de Sect. 3.2 reorganizados;
- minúsculas en nombres de métodos.

En los tokens que ella editó y que contienen dígitos, math, `\cite` o `\ref`, **no cambió ningún
valor**. Las únicas diferencias numéricas son 1D/2D/3D/5D y la coma que quedó dentro de
`$\tilde{p},$`.

## Rangos con guion

Cambió 3 de los 64 rangos de `$a$--$b$` (en dash) a `$a$-$b$` (hyphen): L179 (`0.025-0.20 kpc`), L244
(`60-70 arcmin`) y L356 (`factor of 3-7`). La guía no trae ninguna regla sobre esto. **Decisión del
autor (2026-09-25):** los 64 van con en dash, por coherencia.

## Preguntas abiertas para la editora

La primera no se aplicó. La segunda sí, en un commit propio que se puede revertir entero. Las dos se ven en el PDF marcado.

- L53: "the age of the cluster would be estimated between 6.00 and 10.0 Myr". ¿Va "estimated to be
  between"?
- "overdensity" (nueve sitios, commit propio `0962412`). Es el prefijo sin guion que pide la guía,
  pero la palabra no figura en Merriam-Webster. Si prefiere "over-density", se revierte ese commit.
