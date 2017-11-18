# What's Next?

## Adding a jumphost

The option of having a secure bastion/jumphost running OpenBSD is very tempting. Here's an example of how it would look like: 

```
+--------+
|  PIP   +----------------+
+--------+                |
                          v   +---------+
+----------------+     +------+         +
|MANAGEMENT NET  +-----+ hvn0 | OpenBSD |
+----------------+     +------+         |
                              +---------+
```

Run the following command:

```bash
az vm create -g openbsd20171106212621 \
    -n openbsd20171106212621vm \
    --image https://openbsd20171106212621s.blob.core.windows.net/openbsd20171106212621c/openbsd20171106212621.vhd\
    --ssh-key-value ~/.ssh/id_rsa.pub \ 
    --authentication-type ssh --admin-username azure-user \
    --public-ip-address-dns-name openbsd20171106212621vm \
    --os-type linux \
    --nsg-rule SSH \
    --storage-account openbsd20171106212621s \
    --storage-container-name openbsd20171106212621c \
    --storage-sku Standard_LRS \
    --use-unmanaged-disk \
    --size Standard_B2s
```

That's it! 
