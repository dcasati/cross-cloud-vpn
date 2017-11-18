# Setting up OpenBSD

Here's the setup for OpenBSD on Azure. 

### Create the ike.conf file

```bash
cat > /etc/iked.conf << EOF
local_gw = "51.143.95.27"
remote_gw = "34.233.91.14"
local_net = "10.0.0.0/16"
remote_net = "192.168.0.0/16"
state = "active"

ikev2 $state ipcomp esp \
        from $local_gw to $remote_gw \
        from $local_net to $remote_net peer $remote_gw  \
        psk "1BigSecret"
EOF
```

Enable packet forwarding between the network interfaces:

```bash
# sysctl –w net.inet.ip.forwarding=1
```
Next, enable `iked` to make sure it starts when the system reboots.

```bash
# rcctl enable iked
```

and finally, start the `iked` daemon

```bash 
# rcctl start iked
```

You can check if IPSec is working by running the `ipsecctl` util:

```bash
# ipsecctl –sa
```

Next: [Troubleshooting](05-troubleshooting.md)