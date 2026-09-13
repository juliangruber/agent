# Tiny POSIX-sh test helpers. No dependencies, so tests run anywhere sh does.
# shellcheck shell=sh

PASS=0
FAIL=0

# Directory of the repo under test (parent of this test/ dir)
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export ROOT

pass () { PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"; }
fail () { FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; [ -n "${2:-}" ] && printf '       %s\n' "$2"; }

# assert_eq NAME EXPECTED ACTUAL
assert_eq () {
  if [ "$2" = "$3" ]; then pass "$1"; else fail "$1" "expected [$2], got [$3]"; fi
}

# assert_contains NAME HAYSTACK NEEDLE
assert_contains () {
  case "$2" in
    *"$3"*) pass "$1" ;;
    *) fail "$1" "[$3] not found in output" ;;
  esac
}

# assert_not_contains NAME HAYSTACK NEEDLE
assert_not_contains () {
  case "$2" in
    *"$3"*) fail "$1" "[$3] unexpectedly found" ;;
    *) pass "$1" ;;
  esac
}

# The harnesses, as "suffix | binary | single-prompt argv prefix". The suffix
# is the Dockerfile suffix and image name; the argv prefix is what precedes the
# prompt for a one-shot run. Add a row here when adding a harness.
harness_table () {
  cat <<'TBL'
opencode|opencode|ocr
pi|pi|pi -p
juliangruber-harness|harness|harness
TBL
}

# Print the tally and exit non-zero if anything failed
finish () {
  printf '\n%s passed, %s failed\n' "$PASS" "$FAIL"
  [ "$FAIL" -eq 0 ]
}
