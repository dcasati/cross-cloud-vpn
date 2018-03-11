#!/bin/ksh

cat > /etc/iked.conf << \EOF
local_gw = ${AZURE_PUBLIC_IP}
remote_gw = ${AWS_PUBLIC_IP}
local_net = "172.31.0.0/16"
remote_net = "10.0.0.0/16"
state = "active"

ikev2 $state ipcomp esp \
        from $local_gw to $remote_gw \
        from $local_net to $remote_net peer $remote_gw  \
        psk "1BigSecret"
EOF

chmod 0600 /etc/iked.conf
rcctl enable iked
rcctl start iked

sysctl –w net.inet.ip.forwarding=1
echo net.inet.ip.forwarding=1 >> /etc/sysctl.conf

cat > /etc/pf.conf << EOF
ext_if="hvn0"
int_if="hvn1"

local_gw = ${AZURE_PUBLIC_IP}
remote_gw = ${AWS_PUBLIC_IP}
local_net = "10.0.0.0/16"
remote_net = "172.31.0.0/16"

block on $ext_if
block on enc0

set skip on { lo, enc0 }

pass in on enc0 proto ipencap from any to any keep state (if-bound)
EOF

chmod 0600 /etc/pf.conf
pfctl -ef /etc/pf.conf
