#!/bin/sh
set -eu

MODEL="${AGENT_MODEL:-qwen3.8}"
BASE_URL="${AGENT_BASE_URL:-http://host.docker.internal:11434/v1}"

CONFIG=/root/.pi/agent/models.json

mkdir -p "$(dirname "$CONFIG")"
cat > "$CONFIG" <<EOF
{
  "providers": {
    "ollama": {
      "baseUrl": "$BASE_URL",
      "api": "openai-completions",
      "apiKey": "ollama",
      "compat": {
        "supportsDeveloperRole": false,
        "supportsReasoningEffort": false
      },
      "models": [
        {
          "id": "$MODEL"
        }
      ]
    }
  }
}
EOF

# Pi takes the model on the command line, so inject it unless it is already set
if [ "${1:-}" = "pi" ]; then
  shift
  for arg in "$@"; do
    case "$arg" in
      --model|--model=*|-m) exec pi "$@" ;;
    esac
  done
  exec pi --model "ollama/$MODEL" "$@"
fi

exec "$@"
