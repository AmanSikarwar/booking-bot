#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for dest in app/assets/shared supabase/functions/chat/_shared; do
  mkdir -p "$dest"
  cp catalog/packages.json safety/red_flags.json safety/thresholds.json "$dest/"
done
