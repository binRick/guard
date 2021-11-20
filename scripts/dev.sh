#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cmd="${@:-./scripts/build.sh||true}"

cd ../.

kills="echo killall docker-compose docker-compose.sh||true"
set +e
while :; do 
  nodemon -i guard -I -w main.go -w server.go -e go,yaml,sh,json,j2,py -V --delay 2 -x sh -- -c "$cmd||true"
#while :; do $cmd||true; echo $?; date; sleep 1; $kills; done"
  date
  sleep .5
done
