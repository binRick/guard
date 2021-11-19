#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source test_common.sh
cd ../.
CONTAINER_NAME=wg
SUBCOMMAND=list
DEFAULT_INTERFACE_NAME=wg666

re_exec_modes() (
	set +e
	for m in "$@"; do
		cmd="./${BASH_SOURCE[0]} $m"
		ansi --yellow --italic "$cmd"
		eval "$cmd"
		ec=$?
		ansi --cyan "Exited $ec"
	done
)

if [[ "${@:-}" != "" ]]; then
	SUBCOMMAND="$1"
	shift
fi
GUARD_ARGS=
GUARD_ARGS="--debug"
case $SUBCOMMAND in
exec)
	ACTION="$1"
	shift
	ACTION_ARGS="${@:-}"
	;;
peer)
	ACTION=peers
	ACTION_ARGS="--tunnel wg0 delete mypeer"
	;;
help)
	ACTION='--help'
	ACTION_ARGS=
	;;
rm | del | delete | remove)
	INTERFACE_NAME="$(get_new_name)"
	ACTION=delete
	ACTION_ARGS="$INTERFACE_NAME"
	;;
setup-peers)
	INTERFACE_NAME="${@:-wg669}"
	ACTION=exec
	subnet=10.29.23
  octet_start=10
  octet_qty=3
  for octet in $(seq $octet_start $(($octet_start+$octet_qty))); do
		ip="${subnet}.$octet"
		allowed_ips="${subnet}.0/24"
		ACTION_ARGS="peers --tunnel $INTERFACE_NAME new -ip $ip/24 --ips $allowed_ips"
		re_exec_modes "$ACTION $ACTION_ARGS"
	done
	exit
	;;
setup)
	INTERFACE_NAME="${@:-wg669}"
	ACTION=exec
	ACTION_ARGS="create -a 1.2.3.4/32 -e 127.0.0.1:23225 $INTERFACE_NAME"
	names | grep -q "^$INTERFACE_NAME$" && re_exec_modes "exec delete $INTERFACE_NAME"
	re_exec_modes "$ACTION $ACTION_ARGS" setup-peers
	exit
	;;
name-exists)
	names | grep "^${@:-$DEFAULT_INTERFACE_NAME}$"
	exit $?
	;;

names)
	names
	exit
	;;
list)
	ACTION=list
	ACTION_ARGS=
	ansi --green list
	;;
create)
	ACTION=create
	ACTION_ARGS="-a 1.2.3.4/32 -e 127.0.0.1:23225 ${@:-$DEFAULT_INTERFACE_NAME}"
	ansi --green create
	;;
modes)
	get_modes
	exit
	;;
test)
	re_exec_modes \
		"modes" \
		"list" \
		"exec --help" \
		"help"
	exit
	;;
*)
	ansi --red INVALID TEST NAME $SUBCOMMAND
	exit 2
	;;
esac

CONTAINER_COMMAND="guard $GUARD_ARGS $ACTION $ACTION_ARGS"

cmd="$compose -f $DOCKER_DIR/container-compose.yaml exec $CONTAINER_NAME $CONTAINER_COMMAND"
ansi >&2 --yellow --italic "$cmd"
eval "$cmd"
