#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source test_common.sh
cd ../.
CONTAINER_NAME=wg
CONTAINER_COMMAND=bash

if [[ "${1:-}" != "" ]]; then
	CONTAINER_NAME="$1"
	shift
	if [[ "${@:-}" != "" ]]; then
		CONTAINER_COMMAND="$@"
	fi
fi

cmd="$compose -f $DOCKER_DIR/container-compose.yaml exec $CONTAINER_NAME $CONTAINER_COMMAND"
ansi >&2 --yellow --italic "$cmd"
eval "$cmd"
