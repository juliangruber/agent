#!/bin/sh
# Layer 1: static checks and entrypoint logic. No Docker, runs in seconds.
# Each entrypoint is run with a fake HOME and stub binaries on PATH, so its
# `exec "$@"` lands on a recorder instead of the real agent.
set -eu
. "$(dirname -- "$0")/lib.sh"

echo "== shellcheck =="
if command -v shellcheck >/dev/null 2>&1; then
  # ocr.sh is bash, the rest are POSIX sh
  if shellcheck -s sh "$ROOT"/entrypoint.*.sh "$ROOT"/agent.sh && shellcheck -s bash "$ROOT"/ocr.sh; then
    pass "shellcheck clean"
  else
    fail "shellcheck reported issues"
  fi
else
  echo "  (shellcheck not installed, skipping)"
fi

# Runs an entrypoint in a clean sandbox and captures what its exec'd command
# recorded. Model and base url are passed explicitly (empty means unset) via a
# fresh env, so nothing leaks between cases.
# Usage: run_entrypoint SCRIPT MODEL BASEURL CMD [ARGS...]
run_entrypoint () {
  script=$1 model=$2 base=$3; shift 3
  work=$(mktemp -d)
  rec="$work/rec"
  mkdir -p "$work/bin"
  # Stub every agent binary: record args and the base URL, then succeed
  for bin in opencode pi harness; do
    cat > "$work/bin/$bin" <<STUB
#!/bin/sh
{ printf 'ARGS:%s\n' "\$*"; printf 'BASE_URL:%s\n' "\${AGENT_BASE_URL:-}"; } > "$rec"
STUB
    chmod +x "$work/bin/$bin"
  done
  # shellcheck disable=SC2086
  env -i HOME="$work" PATH="$work/bin:$PATH" \
    ${model:+AGENT_MODEL=$model} ${base:+AGENT_BASE_URL=$base} \
    sh "$ROOT/$script" "$@" >/dev/null 2>&1 || true
  RECORD=$(cat "$rec" 2>/dev/null || echo)
  CONFIG_OC="$work/.config/opencode/config.json"
  CONFIG_PI="$work/.pi/agent/models.json"
}

echo "== opencode entrypoint =="
run_entrypoint entrypoint.opencode.sh qwen3-coder "" opencode
assert_eq "opencode execs opencode" "ARGS:" "$(printf '%s' "$RECORD" | head -1)"
assert_contains "opencode config has model" "$(cat "$CONFIG_OC")" '"ollama/qwen3-coder"'
assert_contains "opencode config default base url" "$(cat "$CONFIG_OC")" 'host.docker.internal:11434/v1'

echo "== pi entrypoint =="
run_entrypoint entrypoint.pi.sh "" "" pi
assert_contains "pi injects the model flag" "$RECORD" 'ARGS:--model ollama/qwen3.8'
assert_contains "pi writes models.json" "$(cat "$CONFIG_PI")" '"qwen3.8"'
# A model already on the command line is left alone
run_entrypoint entrypoint.pi.sh "" "" pi --model ollama/custom -p hi
assert_contains "pi keeps an explicit model" "$RECORD" 'ARGS:--model ollama/custom -p hi'

echo "== harness entrypoint =="
run_entrypoint entrypoint.juliangruber-harness.sh "" "" harness "what is love"
assert_contains "harness runs with --unsafe" "$RECORD" 'ARGS:--unsafe what is love'
assert_contains "harness default base url" "$RECORD" 'BASE_URL:http://host.docker.internal:11434/v1'
# A non-agent command passes straight through
run_entrypoint entrypoint.juliangruber-harness.sh "" "" echo hi
assert_eq "harness passes other commands through" "" "$RECORD"

finish
