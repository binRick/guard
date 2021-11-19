#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd ../.
go build

for d in .bin .musl-bin; do [[ -d "$d" ]] || mkdir -p "$d"; done

CGO_ENABLED=1 CC=musl-gcc go build -o .musl-bin/guard

rsync .musl-bin/guard .bin/guard-musl
