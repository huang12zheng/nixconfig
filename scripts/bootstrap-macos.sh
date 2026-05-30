#!/usr/bin/env bash
# Bootstrap macOS: install Nix (if missing), lock flake, run checks.
# Does NOT run darwin-rebuild switch — review and apply yourself.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

arch="$(uname -m)"
if [[ "$arch" != "arm64" && "$arch" != "aarch64" ]]; then
  echo "warning: expected Apple Silicon (arm64), got $arch" >&2
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "Nix not found. Installing via Determinate installer..."
  echo "See https://github.com/DeterminateSystems/nix-installer for non-interactive flags."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  # Open a new shell so nix is on PATH, then re-run this script.
  echo "Nix installed. Open a new terminal and run: $0"
  exit 0
fi

echo "Nix: $(nix --version)"
echo "Flake root: $ROOT"

nix flake lock
nix flake check

cat <<EOF

Bootstrap finished (no system changes applied).

Next step, after reviewing the configuration:

  darwin-rebuild switch --flake .#darwin-ikey

EOF
