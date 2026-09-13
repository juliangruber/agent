#!/bin/sh
# Layer 3: run each built image against a fake OpenAI-compatible endpoint and
# assert a full prompt round trip prints the fake answer. Needs Docker and node
# (for the fake endpoint). Assumes images_test.sh built the agent-*:test images.
set -eu
. "$(dirname -- "$0")/lib.sh"

SENTINEL=SMOKE_OK_42

# Start the fake endpoint on the host; it prints its port on stdout
port_file=$(mktemp)
FAKE_ANSWER="$SENTINEL" node "$ROOT/test/fake-llm.mjs" > "$port_file" 2>/dev/null &
fake_pid=$!
trap 'kill "$fake_pid" 2>/dev/null; rm -f "$port_file"' EXIT INT TERM

# Wait for the port to be printed
port=
i=0
while [ -z "$port" ] && [ "$i" -lt 50 ]; do
  port=$(cat "$port_file" 2>/dev/null)
  [ -z "$port" ] && sleep 0.1
  i=$((i + 1))
done
if [ -z "$port" ]; then fail "fake endpoint started"; finish; exit; fi
pass "fake endpoint on port $port"

base="http://host.docker.internal:$port/v1"
table=$(mktemp)
harness_table > "$table"

while IFS='|' read -r suffix _ argv; do
  echo "== $suffix smoke =="
  # shellcheck disable=SC2086
  out=$(docker run --rm \
    --add-host=host.docker.internal:host-gateway \
    -e AGENT_BASE_URL="$base" -e AGENT_MODEL=fake \
    "agent-$suffix:test" $argv "say the magic word" 2>&1 || true)
  assert_contains "$suffix completes a prompt" "$out" "$SENTINEL"
done < "$table"

rm -f "$table"
finish
