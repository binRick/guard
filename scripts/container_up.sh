#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source test_common.sh

cd ../.
compose=$(command -v podman-compose || command -v docker-compose)
docker=$(command -v docker || command -v podman)

cleanup() ( 
	(
		set +e
		docker rm docker_wg_1 -f 2>&1 &
		docker pod rm -f docker 2>&1 &
		echo >&2 CLEANED UP
		wait
	)  |pv >/dev/null
)

trap cleanup EXIT INT TERM
build="$docker build --no-cache --target compiler -t compiler  -f $BASE_DIR/compiler.Dockerfile $BASE_DIR/. && "
build=">&2 echo -e $build"
cmd="$build $compose -f docker/container-compose.yaml up --no-build --force-recreate"

eval "$cmd"
