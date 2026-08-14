# agent

Run harnesses in Docker (for safety) and models on bare metal (for speed).

Supports harnesses
- [OpenCode](https://opencode.ai/)
- [Pi](https://pi.dev/)

## Usage

```console
# OpenCode

# Interactive session
$ cd workspace
$ oc

# Single prompt
$ cd workspace
$ ocr "what is love"

# Pi

# Interactive session
$ cd workspace
$ pi

# Single prompt
$ cd workspace
$ pir "what is love"
```

## Installation

- Install [Docker](https://www.docker.com/)
- Install [bat](https://github.com/sharkdp/bat)
- Install [ollama](https://ollama.com/) and pull model `qwen3.6`

1. Clone this repository
1. Build the docker images:

```console
docker build -t opencode-sandbox -f Dockerfile.opencode .
docker build -t pi-sandbox -f Dockerfile.pi .
```

1. Add the contents of [./agent.sh](./agent.sh) to your shell profile

