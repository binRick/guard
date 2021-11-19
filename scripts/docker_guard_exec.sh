#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ./../.

./scripts/docker_exec.sh guard $@
