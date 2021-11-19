compose=$(command -v podman-compose || command -v docker-compose)
docker=$(command -v podman || command -v docker)

INTERFACE_PREFIX=wgd
BASE_DIR="$(cd $(dirname "${BASH_SOURCE[0]}")/../../guard/. && pwd)"
SCRIPTS_DIR=$BASE_DIR/scripts
DOCKER_DIR=$BASE_DIR/docker
G="$SCRIPTS_DIR/docker_guard_exec.sh"
source $SCRIPTS_DIR/ansi

#>&2 ansi --red "BASE_DIR=$BASE_DIR |$DOCKER_DIR|$SCRIPTS_DIR"

get_modes() {
	local MA="xxxxx|yyyyyy|^'\--'$|^\*$"
	cmd="grep '^case' $SCRIPTS_DIR/compose-container-test.sh -A 99|grep '^esac' -B 999|grep '.*)$'|cut -d')' -f1|sort -u|egrep -v \"$MA\""
	eval "$cmd"
}

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
		id="$(($id + 1))"
		n=$INTERFACE_PREFIX$id
		sleep .01
	done
	echo "$n"
}

names() {
	$G list | jq '.[].id' -Mrc | while read -r l; do if [[ "$l" != "" ]]; then echo -e "$l"; fi; done | sort -u
}

#get_new_name
