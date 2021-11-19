#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source test_common.sh

cd ../.

cleanup() {
	(
		set +e
		podman rm docker_wg_1 -f
		podman pod rm -f docker
		echo CLEANED UP
		wait
	) &
}

wait

trap cleanup EXIT
podman-compose -f docker/container-compose.yaml up
