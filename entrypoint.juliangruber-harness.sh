#!/bin/sh
set -eu

export AGENT_BASE_URL="${AGENT_BASE_URL:-http://host.docker.internal:11434/v1}"

# Inside the container Docker is the sandbox, so skip the in-harness bash
# checks and working directory limit with --unsafe
if [ "${1:-}" = "harness" ]; then
  shift
  exec harness --unsafe "$@"
fi

exec "$@"
