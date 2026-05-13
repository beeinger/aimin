#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/.aimin"
BIN_DIR="${HOME}/.local/bin"
BIN_NAME="aimin"
GREEN='\033[0;32m'
NC='\033[0m'

ok() { echo -e "  ${GREEN}✓${NC} $1"; }

echo ""
echo "  Uninstalling aimin..."
echo ""

# Teardown all tool links first
if [ -x "$BIN_DIR/$BIN_NAME" ] || [ -L "$BIN_DIR/$BIN_NAME" ]; then
  "$INSTALL_DIR/bin/$BIN_NAME" teardown
fi

# Remove CLI from global path
if [ -L "$BIN_DIR/$BIN_NAME" ]; then
  rm "$BIN_DIR/$BIN_NAME"
  ok "removed $BIN_DIR/$BIN_NAME"
fi

# Remove cloned repo
if [ -d "$INSTALL_DIR" ]; then
  rm -rf "$INSTALL_DIR"
  ok "removed $INSTALL_DIR"
fi

echo ""
echo "  Done. aimin fully removed."
echo ""
