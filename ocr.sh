#!/bin/bash
set -euo pipefail

opencode run "$@" | batcat -l md --style=plain
