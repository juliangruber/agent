#!/bin/sh
set -eu

# gh reads GH_TOKEN, so hand it the token from the agent namespaced variable
if [ -n "${AGENT_GH_TOKEN:-}" ]; then
  export GH_TOKEN="$AGENT_GH_TOKEN"
fi

MODEL="${AGENT_MODEL:-qwen3.8}"
BASE_URL="${AGENT_BASE_URL:-http://host.docker.internal:11434/v1}"

CONFIG="${HOME:-/root}/.config/opencode/config.json"

mkdir -p "$(dirname "$CONFIG")"
cat > "$CONFIG" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "model": "ollama/$MODEL",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama",
      "options": {
        "baseURL": "$BASE_URL"
      },
      "models": {
        "$MODEL": {
          "name": "$MODEL"
        }
      }
    }
  }
}
EOF

exec "$@"
