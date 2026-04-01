#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# sync-to-claudecode-sc.sh — Sync all files from this repo to msftse/claudecode-sc
# ─────────────────────────────────────────────────────────────────────────────
# Usage:
#   ./scripts/sync-to-claudecode-sc.sh
#
# Prerequisites:
#   - git must be installed and configured
#   - You must have write access to https://github.com/msftse/claudecode-sc
#   - Run from the root of msftnadavbh/claude-code-source-code
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

DEST_REPO="https://github.com/msftse/claudecode-sc.git"
TMP_DIR="/tmp/claudecode-sc"
SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "── Sync: claude-code-source-code → msftse/claudecode-sc ──"
echo "   Source : $SOURCE_DIR"
echo "   Dest   : $DEST_REPO"
echo "   Tmp    : $TMP_DIR"
echo ""

# Clean up any previous clone
if [ -d "$TMP_DIR" ]; then
  echo "── Removing existing $TMP_DIR ──"
  rm -rf "$TMP_DIR"
fi

echo "── Cloning $DEST_REPO ──"
git clone "$DEST_REPO" "$TMP_DIR"

echo "── Copying all files (excluding .git) ──"
rsync -av --exclude='.git' "$SOURCE_DIR/" "$TMP_DIR/"

echo "── Staging all changes ──"
cd "$TMP_DIR"
git add -A

if git diff --cached --quiet; then
  echo "── Nothing to commit — repos are already identical ──"
  exit 0
fi

echo "── Committing ──"
git commit -m "Sync all files from claude-code-source-code"

echo "── Pushing to origin main ──"
git push origin main

echo ""
echo "✓ Sync complete. msftse/claudecode-sc is now identical to claude-code-source-code."
