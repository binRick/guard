#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cmd="${@:-./scripts/build.sh||true}"

cd ../.
nodemon -w . -e go,yaml,sh,json,j2,py -V --delay .5 -x sh -- -c "$cmd||true"
