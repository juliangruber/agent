# agent

Run harnesses in Docker (for safety) and local models on bare metal (for speed).

The current working directory is shared with the harness running in the docker container.

## Usage

### `OpenCode`

#### `oc` - Interactive session

```console
$ cd workspace
$ oc
```

#### `ocr` - Single prompt

```console
$ cd workspace
$ ocr "what is love"

> build · qwen3.8

Haven't heard the good news?

```

### `Pi`

#### `pi` - Interactive session

```console
$ cd workspace
$ pi
```

#### `pir` - Single prompt

```console
$ cd workspace
$ pir "what is love"
Well, that's the age-old question! ❤️
[...]
```

## Models

Configure models through env vars:

| Variable | Default | Description |
| --- | --- | --- |
| `AGENT_MODEL` | `qwen3.8` | Model id, as the endpoint knows it |
| `AGENT_BASE_URL` | `http://host.docker.internal:11434/v1` | OpenAI-compatible endpoint |

Per invocation:

```console
$ AGENT_MODEL=qwen3-coder ocr "what is love"
```

Or set a default in your shell profile:

```console
$ export AGENT_MODEL=qwen3-coder
```

## Harnesses

- [OpenCode](https://opencode.ai/)
- [Pi](https://pi.dev/)
- Pull requests welcome!


## Installation

### Prerequisites

- [Docker](https://www.docker.com/)
- [bat](https://github.com/sharkdp/bat)
- [ollama](https://ollama.com/) and at least one model, see [Models](#models)

### Setup

1. Add the contents of [agent.sh](./agent.sh) to your shell profile and reload

## Development

Build the images yourself, tagged like the published ones so the shell
functions pick them up:

```console
$ docker build -t ghcr.io/juliangruber/agent-opencode -f Dockerfile.opencode .
$ docker build -t ghcr.io/juliangruber/agent-pi -f Dockerfile.pi .
```

[.github/workflows/docker.yml](./.github/workflows/docker.yml) builds both
images on every pull request and publishes them on every push to `main`.

