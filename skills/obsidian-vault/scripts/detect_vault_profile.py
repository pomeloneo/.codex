#!/usr/bin/env python3
"""Detect the user's known Obsidian vault root and profile."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


KNOWN_VAULTS = [
    {
        "machine": "work",
        "root": Path("/Users/bytedance/Documents/Obsidian Vault"),
        "profile": "work",
        "config_dir": ".obsidian_work",
    },
    {
        "machine": "personal",
        "root": Path("/Users/neo/Documents/Obsidian Vault"),
        "profile": "personal",
        "config_dir": ".obsidian_personal",
    },
]


def is_relative_to(path: Path, root: Path) -> bool:
    try:
        path.resolve().relative_to(root.resolve())
        return True
    except ValueError:
        return False


def find_vault_from_path(path: Path) -> dict | None:
    resolved = path.resolve()
    for vault in KNOWN_VAULTS:
        if is_relative_to(resolved, vault["root"]):
            return dict(vault)

    current = resolved if resolved.is_dir() else resolved.parent
    for candidate in [current, *current.parents]:
        if (candidate / ".obsidian").exists() or (candidate / ".obsidian_work").exists() or (
            candidate / ".obsidian_personal"
        ).exists():
            return {
                "machine": "unknown",
                "root": candidate,
                "profile": "unknown",
                "config_dir": "unknown",
            }
    return None


def active_symlink_profile(root: Path) -> str | None:
    obsidian = root / ".obsidian"
    if not obsidian.is_symlink():
        return None
    target = obsidian.resolve()
    if target.name == ".obsidian_work":
        return "work"
    if target.name == ".obsidian_personal":
        return "personal"
    return None


def detect(path: Path) -> dict:
    vault = find_vault_from_path(path)
    if vault is None:
        return {
            "status": "not_found",
            "input": str(path),
            "message": "Path is not inside a known Obsidian vault.",
        }

    root = Path(vault["root"])
    symlink_profile = active_symlink_profile(root)
    profile = symlink_profile or vault["profile"]
    config_dir = {
        "work": ".obsidian_work",
        "personal": ".obsidian_personal",
    }.get(profile, vault["config_dir"])

    return {
        "status": "ok",
        "input": str(path),
        "machine": vault["machine"],
        "vault_root": str(root),
        "profile": profile,
        "profile_source": "symlink" if symlink_profile else "path",
        "config_dir": config_dir,
        "config_path": str(root / config_dir) if config_dir != "unknown" else None,
        "config_exists": (root / config_dir).exists() if config_dir != "unknown" else False,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Detect known Obsidian vault root/profile.")
    parser.add_argument("path", nargs="?", default=os.getcwd())
    parser.add_argument("--format", choices=["json", "text"], default="text")
    args = parser.parse_args()

    result = detect(Path(args.path))
    if args.format == "json":
        print(json.dumps(result, ensure_ascii=False, indent=2))
    elif result["status"] == "ok":
        print(f"vault_root: {result['vault_root']}")
        print(f"profile: {result['profile']} ({result['profile_source']})")
        print(f"config_dir: {result['config_dir']}")
        print(f"config_exists: {result['config_exists']}")
    else:
        print(result["message"])
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
