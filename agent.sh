alias oc='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL -e AGENT_GH_TOKEN \
  ghcr.io/juliangruber/agent-opencode'

alias ocr='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL -e AGENT_GH_TOKEN \
  ghcr.io/juliangruber/agent-opencode ocr'

alias pi='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL -e AGENT_GH_TOKEN \
  ghcr.io/juliangruber/agent-pi'

alias pir='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL -e AGENT_GH_TOKEN \
  ghcr.io/juliangruber/agent-pi pi -p'

alias ha='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL -e AGENT_GH_TOKEN -e AGENT_API_KEY -e AGENT_RESEARCH_MODEL -e AGENT_CONTACT \
  ghcr.io/juliangruber/agent-juliangruber-harness'

alias har='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL -e AGENT_GH_TOKEN -e AGENT_API_KEY -e AGENT_RESEARCH_MODEL -e AGENT_CONTACT \
  ghcr.io/juliangruber/agent-juliangruber-harness harness'
