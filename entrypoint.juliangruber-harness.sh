#!/bin/sh
set -eu

# gh reads GH_TOKEN, so hand it the token from the agent namespaced variable
if [ -n "${AGENT_GH_TOKEN:-}" ]; then
  export GH_TOKEN="$AGENT_GH_TOKEN"
fi

export AGENT_BASE_URL="${AGENT_BASE_URL:-http://host.docker.internal:11434/v1}"

# Inside the container Docker is the sandbox, so skip the in-harness bash
# checks and working directory limit with --unsafe
if [ "${1:-}" = "harness" ]; then
  shift
  exec harness --unsafe "$@"
fi

exec "$@"
