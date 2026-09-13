#!/bin/sh
# Layer 2: build each image and assert its agent binary is installed. Needs
# Docker. Minutes per image, no model required.
set -eu
. "$(dirname -- "$0")/lib.sh"

table=$(mktemp)
harness_table > "$table"

# Loop from a file (not a pipe), so the pass/fail counters stay in this shell
while IFS='|' read -r suffix bin _; do
  echo "== $suffix image =="
  if docker build -q -f "$ROOT/Dockerfile.$suffix" -t "agent-$suffix:test" "$ROOT" >/dev/null; then
    pass "$suffix image builds"
  else
    fail "$suffix image builds"
    continue
  fi
  path=$(docker run --rm --entrypoint sh "agent-$suffix:test" -c "command -v $bin" 2>/dev/null || echo)
  if [ -n "$path" ]; then pass "$suffix has $bin ($path)"; else fail "$suffix has $bin"; fi
done < "$table"

rm -f "$table"
finish
