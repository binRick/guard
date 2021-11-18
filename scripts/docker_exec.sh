#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ./../.

A="${@:-wg}"

cmd="$(command -v docker) exec -it docker_wg_1 $A"
if ! eval "$cmd"; then
	docker-compose -f ./docker/container-compose.yaml up -d
	eval "$cmd"
fi
