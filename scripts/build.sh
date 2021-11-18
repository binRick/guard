go build && ( systemctl stop vpntech-guard ; cp guard /opt/vpntech-binaries/x86_64 && systemctl start vpntech-guard ) && systemctl status --no-pager vpntech-guard && journalctl -fu vpntech-guard
