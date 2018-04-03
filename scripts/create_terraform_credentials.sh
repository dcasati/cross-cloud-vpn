#!/usr/bin/env bash

# check if jq is installed
jq_flag=$(which jq)

if [ -z ${jq_flag} ]; then
        echo "jq not found. Please install it first"
fi

usage() {
        echo "usage  [[-s] SUBSCRIPTION]"
        exit 1
}

while getopts "s:" opt; do
        case $opt in
        s)      SUBSCRIPTION_ID=${OPTARG};;
        *)      usage;;
        esac
done
shift $((OPTIND-1))

if [ -z ${SUBSCRIPTION_ID} ]; then
        usage
fi

# setup the subscription
az account set --subscription="${SUBSCRIPTION_ID}"

CREDENTIALS=$(az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}")

echo "Setting environment variables for Terraform"

cat > terraform.rc << EOF
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
export ARM_CLIENT_ID=$(echo $CREDENTIALS | jq .appId)
export ARM_CLIENT_SECRET=$(echo $CREDENTIALS | jq .password)
export ARM_TENANT_ID=$(echo $CREDENTIALS | jq .tenant)
EOF

source terraform.rc
