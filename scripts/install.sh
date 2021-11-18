for d in guard /opt/vpntech-binaries/x86_64 ~/.local/bin ~/bin; do
	if [[ -d "$d" ]]; then
		rsync -v ./guard $d/.
	fi
done
