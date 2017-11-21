# Setting up OpenBSD

Here's the setup for OpenBSD on Azure and AWS.

## Configure iked

### Create the ike.conf file

> NOTE: For this example we are using a passphrase. This _should_ not be deployed in production. For that please refer to how to deploy this solution with certificates.

| `/etc/iked.conf` on Azure
|-
```bash
cat > /etc/iked.conf << EOF
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
```

| `/etc/iked.conf` on AWS
|-
```bash
cat > /etc/iked.conf << EOF
local_gw = ${AWS_PUBLIC_IP}
remote_gw = ${AZURE_PUBLIC_IP}
local_net = "10.0.0.0/16"
remote_net = "172.31.0.0/16"
state = "active"

ikev2 $state ipcomp esp \
        from $local_gw to $remote_gw \
        from $local_net to $remote_net peer $remote_gw  \
        psk "1BigSecret"
EOF
```

Next, enable `iked` to make sure it starts when the system reboots.

```bash
# rcctl enable iked
```

and finally, start the `iked` daemon

```bash
# rcctl start iked
```

You can check if IPsec is working by running the `ipsecctl` util:

```bash
# ipsecctl –sa
```

## Firewalling

### Enable packet forwarding

Enable packet forwarding between the network interfaces:

```bash
#
# sysctl –w net.inet.ip.forwarding=1
#
# save to persist a reboot
# echo net.inet.ip.forwarding=1 >> /etc/sysctl.conf
```

### Configure pf

As root, create the following file:

| `/etc/pf.conf` on Azure
|-
```bash
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
```

| `/etc/pf.conf` on AWS
|-
```bash
cat > /etc/pf.conf << EOF
ext_if="xfn0"
int_if="xfn1"

local_gw = ${AWS_PUBLIC_IP}
remote_gw = ${AZURE_PUBLIC_IP}
local_net = "172.31.0.0/16"
remote_net = "10.0.0.0/16"

block on $ext_if
block on enc0

set skip on { lo, enc0 }

pass in on enc0 proto ipencap from any to any keep state (if-bound)
EOF
```

Next: [Troubleshooting](05-troubleshooting.md)