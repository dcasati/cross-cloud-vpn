# Cross Cloud VPN: Site-to-Site IKEv2 based on OpenBSD

This is a guide on how to securely connect two public clouds,AWS and Azure. The solution entails the use of an IPsec IKEv2 VPN running on OpenBSD.

References:

* The [OpenBSD](https://www.openbsd.org/) project
* Amazon Web Services ([AWS](https://aws.amazon.com/))
* Microsoft Azure ([Azure](https://azure.microsoft.com/))

# Design Overview
![End to End topology](sections/images/topology.png)

## Audience

The target audience for this tutorial is anyone looking for a solution on how to plumb together two cloud environments, such as Azure and AWS. This is a 
step-by-step approach with many details on how things get connected together.

## Solution Details

This guide will walk you through the process of connecting VMs running on AWS and Azure. For this exercise, the following considerations were taken:

* OpenBSD 6.1 amd64
* Azure CLI 2.0
* Different VNets and VPC CIDR networks. They must be different and non overlapping.

> NOTE: Since OpenBSD is not readily available as an image on both clouds, we will need to craft an image from scratch. Although this can initially be an issue, the process is streamlined and this has an added benefit of giving you the full control
of the image. Until a this image is available in the Marketplace (Azure and AWS) this is likely your safest bet right now. 

* To generate your OpenBSD image, you can follow the these instructions:
    - For Azure, the instructions are covered
    [here](https://github.com/dcasati/openbsd-on-azure).
    - For AWS check [this one](https://github.com/ajacoutot/aws-openbsd).  

See the [Before You Begin](sections/01-before-you-begin.md) for details on network planning.
   
## Sections

- [Before You Begin](sections/01-before-you-begin.md)
- [Design Overview](sections/design.md)
- [Configuring Azure](sections/02-configuring-azure.md)
- [Configuring AWS](sections/03-configuring-aws.md)
- [Testing](sections/04-plumbing.md)
- [Troubleshooting](sections/05-troubleshooting.md)
- [What's next ?](sections/06-next.md)