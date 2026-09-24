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

### `Harness`

A general purpose agent harness with fair research, from [juliangruber/harness](https://github.com/juliangruber/harness). Runs with `--unsafe` in the container, since Docker is the sandbox.

#### `ha` - Interactive session

```console
$ cd workspace
$ ha
```

#### `har` - Single prompt

```console
$ cd workspace
$ har "what is love"
```

## Installation

### Prerequisites

- [Docker](https://www.docker.com/)
- [ollama](https://ollama.com/) and at least one model

### Setup

Include [agent.sh](./agent.sh) in your shell profile and reload.

```console
. agent.sh
```

## Models

Configure models through env vars:

| Variable | Default | Description |
| --- | --- | --- |
| `AGENT_MODEL` | `qwen3.8` | Model id, as the endpoint knows it |
| `AGENT_BASE_URL` | `http://host.docker.internal:11434/v1` | OpenAI-compatible endpoint |
| `AGENT_GH_TOKEN` | | GitHub token for `gh`, see [GitHub CLI](#github-cli) |

Per invocation:

```console
$ AGENT_MODEL=qwen3-coder ocr "what is love"
```

Or set a default in your shell profile:

```console
$ export AGENT_MODEL=qwen3-coder
```

## GitHub CLI

Every image ships the [`gh`](https://cli.github.com/) CLI, so harnesses can work with issues, pull requests and the GitHub API. To authenticate it, set `AGENT_GH_TOKEN`, which the aliases pass into the container, where it becomes `GH_TOKEN`:

```console
$ export AGENT_GH_TOKEN=$(gh auth token)
```

For tighter scoping, use a [fine-grained personal access token](https://github.com/settings/personal-access-tokens) limited to the repositories and permissions the agent needs. Without `AGENT_GH_TOKEN`, `gh` still works for anything that needs no auth.

## Harnesses

- [OpenCode](https://opencode.ai/)
- [Pi](https://pi.dev/)
- [Harness](https://github.com/juliangruber/harness)
- Pull requests welcome!

## Development

```console
$ docker build -t ghcr.io/juliangruber/agent-opencode -f Dockerfile.opencode .
$ docker build -t ghcr.io/juliangruber/agent-pi -f Dockerfile.pi .
$ docker build -t ghcr.io/juliangruber/agent-juliangruber-harness -f Dockerfile.juliangruber-harness .
```

## Tests

```console
$ sh test/run.sh
```

Three layers:

1. **Entrypoints** - shellcheck, and each `entrypoint.*.sh` run in a sandbox to check it writes the right config, defaults `AGENT_BASE_URL`, and injects the model flag / `--unsafe`. No Docker, runs in seconds.
2. **Images** - builds each `Dockerfile.*` and checks the agent binary and `gh` are installed.
3. **Smoke** - runs each image against a fake OpenAI-compatible endpoint (`test/fake-llm.mjs`, needs node) and asserts a full prompt round trip returns the answer.

Layers 2 and 3 need Docker and are skipped when it's unavailable or `SKIP_DOCKER=1`. CI runs all three. Add a harness by adding a row to `harness_table` in `test/lib.sh`.

