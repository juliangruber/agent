#!/bin/sh
# Runs the test suite. Layer 1 (entrypoint logic) always runs. Layers 2 and 3
# (image build, smoke) run when Docker is available, unless SKIP_DOCKER=1.
set -eu
cd "$(dirname -- "$0")/.."

failed=

echo "### Layer 1: entrypoints"
sh test/entrypoints_test.sh || failed=1

if [ "${SKIP_DOCKER:-}" = "1" ]; then
  printf '\n(SKIP_DOCKER=1, skipping image and smoke tests)\n'
elif command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  printf '\n### Layer 2: images\n'
  sh test/images_test.sh || failed=1
  printf '\n### Layer 3: smoke\n'
  sh test/smoke_test.sh || failed=1
else
  printf '\n(Docker not available, skipping image and smoke tests)\n'
fi

[ -z "$failed" ] || { printf '\nSOME TESTS FAILED\n'; exit 1; }
printf '\nALL TESTS PASSED\n'
