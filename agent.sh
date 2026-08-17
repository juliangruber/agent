alias oc='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL \
  ghcr.io/juliangruber/agent-opencode'

alias ocr='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL \
  ghcr.io/juliangruber/agent-opencode ocr'

alias pi='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL \
  ghcr.io/juliangruber/agent-pi'

alias pir='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL \
  ghcr.io/juliangruber/agent-pi pi -p'
