# Configuring AWS 

![AWS topology](images/topology-aws.png)


## Step-by-step overview

1. Create a VPC with a large network (e.g.: 172.31.0.0/16). This will allow us room for trying other experiments in the future.
1. Carve 2 subnets (e.g.: Private and VPN). Our VM will have a NIC in each one of these subnets.
1. Create the OpenBSD VM with two NICs
    1. For each NIC **disable source/dest check**
1. Add the route to Azure (e.g.: 10.0.0.0/16)
1. Allow traffic on the Security Groups (ports 500, 4500 UDP)
    1. For troubleshooting, also allow ICMP and SSH between the two networks.
1. Attach an Elastic IP to the OpenBSD interface on the VPN subnet.
1. Configure OpenIKED.

## Route Table Overview

|Destination | Target | Notes   
|---|---|---
|172.31.0.0/16 | local | VPC CIDR
|0.0.0.0/0 |  Internet Gateway |    
|10.0.0.0/0 | xfn1 / OpenBSD | Route to Azure's VNET pointing to OpenBSD's internal NIC interface

### Add a route to Azure's VNet

#### Go to the VPC

1. Click on the **Services** dropdown menu.
1. and select **VPC** under the *Networking & Content Delivery* section

![AWS VPC](images/aws-select-vpc.png)

#### Next, create the route table entry.

![AWS select route table](images/aws-select-route-table.png)

1. Under the Virtual Private Cloud, select **Route Tables**
1. Select the subnet which you want to add the route. In our example, we will select the `private-us-west-2a` one.
1. Click ont he **Routes** tab 
1. and then click on **Edit**

![AWS Route table](images/aws-add-route.png)

Once inside of the route table

1. Click on **Add another route**
1. Under the _Destination_ field, write Azure's VNet CIDR. In our exercise _10.0.0.0/16_.
1. Select OpenBSDs internal interface. You can either search for the name of the interface (e.g.: eni-XXXX) or search for a tag (e.g.: internal_if)
1. Click on **Save** 

Next: [Setting up OpenBSD](04-setting-openbsd.md)