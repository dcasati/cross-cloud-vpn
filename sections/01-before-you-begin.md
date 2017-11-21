# Before You Begin

For this solution, you will need:

* An account on [Microsoft Azure](https://azure.microsoft.com). You can
create your Azure account for [free](https://azure.microsoft.com/en-us/free/)
* An account on [Amazon Web Service](https://aws.amazon.com)

* OpenBSD 6.1 available as an image on AWS and Azure. If you don't have this,
you can follow the these instructions:
    - For Azure, the instructions are covered
    [here](https://github.com/dcasati/openbsd-on-azure).
    - For AWS check [this one](https://github.com/ajacoutot/aws-openbsd).

* Azure CLI 2.0 (more instructions below)

## Microsoft Azure CLI 2.0

### Install the Microsoft Azure CLI 2.0

Follow the Azure CLI 2.0 [documentation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to install the `az` command line utility. You can install utility in various platforms such as macOS, Window
s, Linux (various distros) and as a Docker container.

The examples here are based on the version 2.0.18 of the utility. You can verify the version of the tool by running:

```
az --version
```

> Note: If this is your first time using the Azure CLI tool, you can familiarize yourself with it's syntax and command options by running `az interactive`

### First Things First

Before we can use Azure, your first step, aside from having an account, is to login. Once Azure CLI is installed, open up a terminal and run the following:

```
az login
```

This will prompt you to sign in using a web browser to https://aka.ms/devicelogin and to enter the displayed code. This single step is needed in order to allow `az` to talk back to Azure.

## Planning the networks

One of the requirements for the exercises in this tutorial is that the networks on both clouds cannot be the same or overlap. For that reason,
here's a proposed a layout:

| Where | Name | CIDR | Nb of Hosts
|- | - | - | -
| AWS | VPN | 172.31.255.128/25 | 126
| | Private | 172.31.0.0/19 | 8190 
| Azure | VPN | 10.0.0.128/25 | 126
| | Private | 10.0.0.0/19 | 8190

You can expand the examples here by carving out more subnets or changing the CIDRs. Always keep in mind that the rules here need to be respect: no overlap and
not the same address space in the clouds!

Next: [Configuring Azure](02-configuring-azure.md)