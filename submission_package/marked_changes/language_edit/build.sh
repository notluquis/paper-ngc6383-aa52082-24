#!/bin/sh
# Rebuilds the marked PDF for the A&A language editor: our changes, in red, over her corr.tex.
#   corr_noLEt.tex  her aa52082-24corr.tex with only her three \LEt notes removed (commit a46d3cd,
#                   plus the \varpi fix of adb7fd8)
#   final.tex       copy of ../../clean_source/aa52082-24.tex at the end of the language-edit pass
# Inserted text: red wavy underline. Deleted text: red strikeout. Output:
#   ../../aa52082-24_language_edit_marked.pdf
set -e
cd "$(dirname "$0")"
cmp -s final.tex ../../clean_source/aa52082-24.tex || { echo "final.tex is stale: copy clean_source/aa52082-24.tex first" >&2; exit 1; }
# --append-textcmd=tablefoot: without it latexdiff treats the table notes as opaque and swaps the
#   whole note without marking the change (measured: "The values of" in Table 1, "Here," in Table D.2).
# The perl step: when only a suffix changes (assume -> assume[d]), latexdiff writes
#   "assume\DIFaddbegin \DIFadd{d}\DIFaddend  that" and TeX swallows the space after the control word,
#   printing "assumedthat". A {} after the end marker keeps the space. Only for a letters-only
#   insertion glued to a word: a deleted or inserted hyphen (over-density, 0.025--0.20) must stay
#   glued. Second rule: latexdiff leaves "over-density ." with a space before the punctuation.
latexdiff -t UNDERLINE --encoding=utf8 --append-textcmd=tablefoot corr_noLEt.tex final.tex \
  | sed 's/\\providecommand{\\DIFaddtex}\[1\]{{\\protect\\color{blue}\\uwave{#1}}}/\\providecommand{\\DIFaddtex}[1]{{\\protect\\color{red}\\uwave{#1}}}/' \
  | perl -pe 's/([A-Za-z]\\DIFaddbegin \\DIFadd\{[A-Za-z]+\}\\DIFaddend)( +)(?=[A-Za-z\$])/$1\{\}$2/g; s/(\\DIFdelend [A-Za-z]+) ([.,;:])/$1$2/g' \
  > aa52082-24_language_edit_marked.tex
grep -q 'DIFaddtex}\[1\]{{\\protect\\color{red}' aa52082-24_language_edit_marked.tex || { echo "red markup not applied" >&2; exit 1; }
T=$(mktemp -d)
cp aa52082-24_language_edit_marked.tex "$T/"
for f in aa.cls aa.bst linenoaa.sty cites.bib; do cp ../../clean_source/$f "$T/"; done
cp -R ../../clean_source/Figures "$T/"
( cd "$T" && latexmk -pdf -bibtex -interaction=nonstopmode aa52082-24_language_edit_marked.tex >/dev/null 2>&1 || true )
grep -c 'LaTeX Error' "$T/aa52082-24_language_edit_marked.log" && { echo "LaTeX errors" >&2; exit 1; } || true
grep 'Output written' "$T/aa52082-24_language_edit_marked.log"
cp "$T/aa52082-24_language_edit_marked.pdf" ../../aa52082-24_language_edit_marked.pdf
cp "$T/aa52082-24_language_edit_marked.log" ./build.log
