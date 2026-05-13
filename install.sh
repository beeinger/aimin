#!/usr/bin/env bash
set -euo pipefail

REPO="beeinger/aimin"
INSTALL_DIR="${HOME}/.aimin"
BIN_DIR="${HOME}/.local/bin"
BIN_NAME="aimin"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}⚠${NC} $1"; }

echo ""
echo "  Installing aimin..."
echo ""

if ! command -v git &>/dev/null; then
  echo "  git is required. Install it and retry."
  exit 1
fi

if [ -d "$INSTALL_DIR/.git" ]; then
  git -C "$INSTALL_DIR" fetch origin main --quiet
  git -C "$INSTALL_DIR" reset --hard origin/main --quiet
  ok "updated existing install at $INSTALL_DIR"
elif [ -d "$INSTALL_DIR" ]; then
  echo "  $INSTALL_DIR exists but is not a git repo."
  echo "  Remove it and retry:  rm -rf $INSTALL_DIR"
  exit 1
else
  git clone --depth 1 "https://github.com/$REPO.git" "$INSTALL_DIR" --quiet
  ok "cloned to $INSTALL_DIR"
fi

mkdir -p "$BIN_DIR"
chmod +x "$INSTALL_DIR/bin/$BIN_NAME"
ln -sfn "$INSTALL_DIR/bin/$BIN_NAME" "$BIN_DIR/$BIN_NAME"
ok "cli → $BIN_DIR/$BIN_NAME"

if ! echo "$PATH" | tr ':' '\n' | grep -q "^${BIN_DIR}$"; then
  echo ""
  warn "$BIN_DIR is not in your PATH"
  echo "  Add to your shell rc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
exec "$BIN_DIR/$BIN_NAME" setup
