#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source test_common.sh

cd ../.
compose=$(command -v podman-compose || command -v docker-compose)
docker=$(command -v podman || command -v docker)

cleanup() ( 
	(
		set +e
		$docker rm docker_wg_1 -f &
		$docker pod rm -f docker &
		echo >&2 CLEANED UP
		wait
	) | pv >/dev/null
)

trap cleanup EXIT
cmd="$compose -f docker/container-compose.yaml up --remove-orphans"

eval "$cmd"
