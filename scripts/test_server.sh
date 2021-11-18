#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source test_common.sh

export SERVER_ON=1
GUARD_ARGS=
SERVER_ARGS=

cd ../.

server() {
	while [[ "$SERVER_ON" == 1 ]]; do
		cmd="$G $GUARD_ARGS server $SERVER_ARGS"
		ansi >&2 --yellow --italic "$cmd"
		eval "$cmd"
		sleep 1
	done
}

create() {
	I=$(get_new_name)
	P=12321
	H=0.0.0.0
	A=1.2.3.4
	cmd="./guard create -a $A -e $H:$P $I"
	ansi --yellow --italic "$cmd"
}

list() {
	ansi --magenta --bg-black "Listing Wireguard Interfaces"
	msg="$(ansi --cyan --bold "$(names | xargs -I % echo -e '   - %')")"
	echo -e "$msg"
}

server

list
create
