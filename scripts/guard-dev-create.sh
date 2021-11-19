#!/usr/bin/env bash
set -euo pipefail
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export PATH=~/guard:$PATH
source test_common.sh
cd ../.

IFACE=$(hostname -s)
[[ -d configs ]] || mkdir -p ./.configs
CFG=./.configs/$IFACE.conf

(
  set +e
  guard delete $IFACE||true;
  guard delete $IFACE-server||true;
  wg-quick down $IFACE||true;
  wg-quick down $IFACE-server||true;
) 

{ 
  guard create --address 10.20.30.1/24 --endpoint f180.vpnservice.company:34050 $IFACE-server| jq -cC; 
}  >&2

{ 
  guard peers --tunnel $IFACE-server new --ip 10.20.30.20/32 --ips 10.20.30.0/24 --ips 10.0.200.0/24 client1 | egrep -v '^$'; 
} > $CFG

cat $CFG

wg
echo $CFG

#wg-quick up $IFACE



