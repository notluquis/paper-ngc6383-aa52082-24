#!/usr/bin/env python3
"""Verifica que los ficheros vendorizados (ver tools/VENDORED.toml) no se movieron de su
commit declarado.

`tools/manuscript_gate.py` es una copia tal cual de erotica (github.com/notluquis/erotica),
copiada en vez de traida como submodulo porque un submodulo del monorepo arrastraria ~306 MB
de historia sin filtrar. Este script recalcula el sha256 de cada fichero declarado y falla si
no coincide -- que es exactamente lo que pasa si alguien lo edita localmente sin actualizar la
declaracion. Solo libreria estandar: corre en CI sin pip install, antes del gate.

Uso: python3 tools/check_vendored.py
"""

from __future__ import annotations

import hashlib
import sys
import tomllib
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent


def main() -> int:
    toml_path = HERE / "VENDORED.toml"
    data = tomllib.loads(toml_path.read_text())
    entries = data.get("file", [])
    if not entries:
        print(f"FALLA  {toml_path} no declara ningun [[file]]", file=sys.stderr)
        return 1

    problems = []
    for entry in entries:
        rel_path = entry["path"]
        path = ROOT / rel_path
        if not path.exists():
            problems.append(f"{rel_path}: no existe")
            continue
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        expected = entry["sha256"]
        if actual != expected:
            problems.append(
                f"{rel_path}: sha256 no coincide con VENDORED.toml "
                f"(declarado {expected}, real {actual}) -- se edito sin actualizar la declaracion"
            )
        else:
            print(
                f"ok  {rel_path}: sha256 coincide con el commit {entry['commit']} "
                f"de {entry['origin']}"
            )

    if problems:
        for p in problems:
            print(f"FALLA  {p}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
