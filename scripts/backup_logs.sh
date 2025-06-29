#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$ROOT_DIR/backups"
DATE=$(date +%Y%m%d)

mkdir -p "$BACKUP_DIR"

find "$ROOT_DIR" -type f \( -name '*.log' -o -name '*.csv' \) \
    -not -path "$BACKUP_DIR/*" \
    -print0 | tar --null -czf "$BACKUP_DIR/logs_${DATE}.tar.gz" --files-from -
