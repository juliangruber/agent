alias oc='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  opencode-sandbox'

ocr() {
  docker run -it --rm \
    -v "$(pwd):/workspace" \
    --add-host=host.docker.internal:host-gateway \
    opencode-sandbox opencode run $@ \
      | bat -l md --style=plain
}

alias pi='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  pi-sandbox'

alias pir='docker run -it --rm \
  -v "$(pwd):/workspace" \
  --add-host=host.docker.internal:host-gateway \
  pi-sandbox pi -p'

