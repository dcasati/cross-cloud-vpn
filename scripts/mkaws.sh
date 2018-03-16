#!/bin/ksh

echo 'http://ftp.openbsd.org/pub/OpenBSD' > /etc/installurl
pkg_add curl-7.53.1.tgz

REMOTE_PUBLIC_IP=$1
REMOTE_NET=$2

LOCAL_PUBLIC_IP=$(curl "http://169.254.169.254/latest/meta-data/public-ipv4/")

REMOTE_PUBLIC_IP=$1

INTERFACE=$(curl "http://169.254.169.254/latest/meta-data/network/interfaces/macs/")
LOCAL_NET=$(curl "http://169.254.169.254/latest/meta-data/interfaces/macs/${INTERFACE}/subnet-ipv4-cidr-block")

cat > /etc/iked.conf << EOF
local_gw = "${LOCAL_PUBLIC_IP}"
remote_gw = "${REMOTE_PUBLIC_IP}"
local_net = "${LOCAL_NET}"
remote_net = "${REMOTE_NET}"
state = "active"

ikev2 \$state ipcomp esp \\
        from \$local_gw to \$remote_gw \\
        from \$local_net to \$remote_net peer \$remote_gw  \\
        psk "1BigSecret"
EOF

chmod 0600 /etc/iked.conf
rcctl enable iked
rcctl start iked

sysctl -w net.inet.ip.forwarding=1
echo net.inet.ip.forwarding=1 >> /etc/sysctl.conf

cat > /etc/pf.conf << EOF
ext_if="xnf0"
#int_if="xnf1"

local_gw = ${LOCAL_PUBLIC_IP}
remote_gw = ${REMOTE_PUBLIC_IP}
local_net = "${LOCAL_NET}/${LOCAL_PREFIX}"
remote_net = "${REMOTE_NET}"

block in on \$ext_if
block on enc0

set skip on { lo, enc0 }

pass in on enc0 proto ipencap from any to any keep state (if-bound)
pass in on \$ext_if proto tcp from any to any port 22 keep state
pass out on \$ext_if from \$local_net to any
EOF

chmod 0600 /etc/pf.conf
pfctl -ef /etc/pf.conf
