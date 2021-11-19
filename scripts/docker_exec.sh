#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ./../.

A="${@:-bash}"

cmd="$(command -v docker) exec -it docker_wg_1 $A"
eval "$cmd"
