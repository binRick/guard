#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cmd="${@:-./scripts/build.sh||true}"

cd ../.

kills="killall docker-compose docker-compose.sh||true"
set +e
while :; do 
  nodemon -I -w . -e go,yaml,sh,json,j2,py -V --delay .5 -x bash -- -c "while :; do $cmd||true; echo $?; date; sleep 1; $kills; done"
  date
  sleep .5
done
