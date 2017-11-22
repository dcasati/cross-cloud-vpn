# What's Next?

With our solution in place, there's now the question: what's next? For one, there are various improvements that I will be working on over time to 
improve this tutorial. Here's a quick list of things that will come up next:

- Automate the build of the image with packer
- Automate the deployment with Terraform
- Implement a CI/CD pipeline that build OpenBSD and deploys to Azure.
- Document the use of certificates vs PSK for OpenIKED. 
- Document a hub-spoke solution with different Azure/AWS regions and expand that to Azure Stack.

To add a bit of flavor, here's how you'd deploy an OpenBSD jumphost.

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
