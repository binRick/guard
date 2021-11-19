#!/usr/bin/env bash
set -exuo pipefail
export SERVER_ON=1
SERVER_LOG=/var/log/guard-server.log

server() {
	while [[ "$SERVER_ON" == 1 ]]; do
		cmd="command guard --debug server"
		echo >&2 -e "$cmd"
		eval "$cmd" | tee -a $SERVER_LOG
		sleep 1
	done
}

finish() {
	export SERVER_ON=0
	killall guard
	#    wg-quick down wg0
	exit 0
}
trap finish SIGTERM SIGINT SIGQUIT

#wg-quick up /etc/wireguard/wg0.conf

server &
# Inifinite sleep
while true; do
	sleep 86400
	wait $!
done
