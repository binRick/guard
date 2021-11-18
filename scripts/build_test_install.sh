#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

./build.sh && ./test.sh && ./install.sh
