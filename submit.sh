#!/usr/bin/env bash
set -euo pipefail

# Unity WebGL 出力元
SOURCE_DIR="$HOME/Setup Guide In-Editor Tutorial/webapp"

# このスクリプトのあるリポジトリを作業ディレクトリにする
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

usage() {
  echo "Usage: $0 [-r|-t]"
  echo "  no option: deploy to repository root"
  echo "  -r       : deploy to ./release/YYYYMMDD"
  echo "  -t       : deploy to ./release/YYYYMMDD_HHMM"
}

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

TARGET_DIR="."
COMMIT_MSG="update webapp"

if [[ $# -gt 1 ]]; then
  usage
  exit 1
fi

if [[ $# -eq 1 ]]; then
  case "$1" in
    -r)
      TODAY="$(date +%Y%m%d)"
      TARGET_DIR="./release/$TODAY"
      rm -rf "$TARGET_DIR"
      mkdir -p "$TARGET_DIR"
      COMMIT_MSG="$TODAY"
      ;;
    -t)
      TIMESTAMP="$(date +%Y%m%d_%H%M)"
      TARGET_DIR="./release/$TIMESTAMP"
      rm -rf "$TARGET_DIR"
      mkdir -p "$TARGET_DIR"
      COMMIT_MSG="$TIMESTAMP"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
fi

# Unityのビルド成果物をコピー（既存は上書き）
cp -R "$SOURCE_DIR"/. "$TARGET_DIR"/

git status
git add -A

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git commit -m "$COMMIT_MSG"
git push origin HEAD
