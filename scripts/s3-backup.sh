#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  echo "Usage: $0 <source_directory> <s3_bucket> [s3_prefix]"
  exit 2
}

[[ $# -ge 2 && $# -le 3 ]] || usage
SOURCE_DIR="${1%/}"
BUCKET="$2"
PREFIX="${3:-linux-lab-backups}"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
HOST="$(hostname -s | tr -cd 'A-Za-z0-9.-')"
ARCHIVE="/tmp/${HOST}-${TIMESTAMP}.tar.gz"

[[ -d "$SOURCE_DIR" ]] || { echo "Source directory not found: $SOURCE_DIR" >&2; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "AWS CLI is required" >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "tar is required" >&2; exit 1; }

echo "Creating archive from: $SOURCE_DIR"
tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

DEST="s3://${BUCKET}/${PREFIX}/${HOST}-${TIMESTAMP}.tar.gz"
echo "Uploading archive to: $DEST"
aws s3 cp "$ARCHIVE" "$DEST" --only-show-errors

echo "Backup uploaded successfully: $DEST"
echo "Local archive retained at: $ARCHIVE"
