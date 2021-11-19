INTERFACE_PREFIX=wgd
BASE_DIR="$(cd $(dirname "${BASH_SOURCE[0]}")/../../guard/. && pwd)"
SCRIPTS_DIR=$BASE_DIR/scripts
DOCKER_DIR=$BASE_DIR/docker
G="$SCRIPTS_DIR/docker_guard_exec.sh"

#>&2 ansi --red "BASE_DIR=$BASE_DIR |$DOCKER_DIR|$SCRIPTS_DIR"

exec_script() {
	cmd="exec ./scripts/$@"
	eval "$cmd"
}

name_exists() {
	local n="$1"
	names | grep "^$n$"
}

get_new_name() {
	local id=10
	local n=$INTERFACE_PREFIX$id
	while name_exists $n; do
		echo >&2 "$n exists...."
		id="$(($id + 1))"
		n=$INTERFACE_PREFIX$id
		sleep .01
	done
	echo >&2 "new interface $n"
	echo "$n"
}

names() {
	$G list | jq '.[].id' -Mrc
}

#get_new_name
