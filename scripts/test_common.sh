G=./guard
INTERFACE_PREFIX=wgd

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
