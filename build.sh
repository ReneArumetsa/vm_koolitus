#!/usr/bin/env bash
# Ehitab mõlemad PDF-id projekti fontidega.
# Kasutus:  ./build.sh          — ehitab ühe korra
#           ./build.sh watch    — jälgib slaide ja ehitab muudatusel
set -euo pipefail
cd "$(dirname "$0")"

# typst kas süsteemist või nixi kaudu
if command -v typst >/dev/null 2>&1; then
  TYPST="typst"
else
  TYPST="nix run nixpkgs#typst --"
fi

if [ "${1:-}" = "watch" ]; then
  exec $TYPST watch --font-path fonts main.typ VM_koolitus.pdf
fi

$TYPST compile --font-path fonts main.typ VM_koolitus.pdf
$TYPST compile --font-path fonts virtualbox_juhend.typ
echo "✓ VM_koolitus.pdf ja virtualbox_juhend.pdf valmis"
