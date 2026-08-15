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

> build · qwen3.6

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

## Harnesses

- [OpenCode](https://opencode.ai/)
- [Pi](https://pi.dev/)
- Pull requests welcome!


## Installation

### Prerequisites

- [Docker](https://www.docker.com/)
- [bat](https://github.com/sharkdp/bat)
- [ollama](https://ollama.com/) and pull model `qwen3.6`

### Setup

1. Clone this repository
1. Build the docker images:

    ```console
    docker build -t opencode-sandbox -f Dockerfile.opencode .
    docker build -t pi-sandbox -f Dockerfile.pi .
    ```

1. Add the contents of [agent.sh](./agent.sh) to your shell profile and reload

