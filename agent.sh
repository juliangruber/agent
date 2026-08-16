alias oc='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL \
  opencode-sandbox'

ocr() {
  docker run -it --rm \
    -v "$(pwd):/workspace" \
    --add-host=host.docker.internal:host-gateway \
    -e AGENT_MODEL -e AGENT_BASE_URL \
    opencode-sandbox opencode run "$@" \
      | bat -l md --style=plain
}

alias pi='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL \
  pi-sandbox'

alias pir='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  -e AGENT_MODEL -e AGENT_BASE_URL \
  pi-sandbox pi -p'
