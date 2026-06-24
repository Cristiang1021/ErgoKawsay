#!/usr/bin/env python3
"""Genera lib/core/localization/tr.dart desde translations.yaml."""

import re
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
YAML_PATH = ROOT / "translations.yaml"
OUT_PATH = ROOT / "lib" / "core" / "localization" / "tr.dart"


def to_camel(parts: list[str]) -> str:
    def seg(s: str) -> str:
        bits = s.split("_")
        return bits[0] + "".join(b[:1].upper() + b[1:] for b in bits[1:])

    if not parts:
        return "value"
    result = seg(parts[0])
    for part in parts[1:]:
        piece = seg(part)
        result += piece[:1].upper() + piece[1:]
    return result


def to_pascal(parts: list[str]) -> str:
    return "".join(p[:1].upper() + p[1:] for p in parts)


def dart_string(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$") + '"'


def walk(node, path: list[str], leaves: list[tuple[list[str], str, str]]):
    if isinstance(node, dict):
        if "es" in node and "kichwa" in node:
            leaves.append((path, node["es"], node["kichwa"]))
            return
        for k, v in node.items():
            walk(v, path + [k], leaves)
    elif isinstance(node, list):
        for i, v in enumerate(node):
            walk(v, path + [str(i)], leaves)


def main():
    data = yaml.safe_load(YAML_PATH.read_text(encoding="utf-8"))
    leaves: list[tuple[list[str], str, str]] = []
    walk(data["translations"], [], leaves)

    lines = [
        "// GENERATED from translations.yaml — do not edit by hand.",
        "// Regenerate: python tools/gen_translations.py",
        "",
        "/// Traducciones oficiales es / kichwa.",
        "abstract final class Tr {",
        "  Tr._();",
        "",
        "  static String pick(bool isKichwa, String es, String qu) =>",
        "      isKichwa ? qu : es;",
        "",
    ]

    getters: list[str] = []
    for path, es, qu in leaves:
        base = to_camel(path)
        es_name = base + "Es"
        qu_name = base + "Qu"
        fn_name = base
        lines.append(f"  static const String {es_name} = {dart_string(es)};")
        lines.append(f"  static const String {qu_name} = {dart_string(qu)};")
        getters.append(
            f"  static String {fn_name}(bool isKichwa) => "
            f"pick(isKichwa, {es_name}, {qu_name});"
        )
        lines.append("")

    lines.extend(getters)
    lines.append("}")
    lines.append("")

    OUT_PATH.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {len(leaves)} entries to {OUT_PATH}")


if __name__ == "__main__":
    main()
