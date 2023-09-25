#!/bin/bash

# Define variables
branch="Dev"

# Ensure all required parameters are provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <location> <networkResourceGroupName> <vnetName> <subNetName> <networkConnectionName>"
    exit 1
fi

# Assign positional parameters to meaningful variable names
location="$1"
networkResourceGroupName="$2"
vnetName="$3"
subNetName="$4"
networkConnectionName="$5"

# Define the template file path
templateFilePath="https://raw.githubusercontent.com/Evilazaro/MicrosoftDevBox/$branch/Deploy/ARMTemplates/network/networkConnectionTemplate.json"

# Echo starting the operation
echo "Initiating the deployment in the resource group: $networkResourceGroupName, location: $location."

# Retrieve the subnet ID
echo "Retrieving Subnet ID for $subNetName..."
subnetId=$(az network vnet subnet show \
    --resource-group "$networkResourceGroupName" \
    --vnet-name "$vnetName" \
    --name "$subNetName" \
    --query id \
    --output tsv)

# Check the successful retrieval of subnetId
if [ -z "$subnetId" ]; then
    echo "Error: Unable to retrieve the Subnet ID for $subNetName in $vnetName."
    exit 1
fi
echo "Subnet ID for $subNetName retrieved successfully."

# Deploy the ARM template
echo "Deploying ARM Template from $templateFilePath..."
az deployment group create \
    --resource-group "$networkResourceGroupName" \
    --template-uri "$templateFilePath" \
    --parameters \
        name="$networkConnectionName" \
        vnetId="$subnetId" \
        location="$location" \
        subnetName="$subNetName" \
    --no-wait

# Check the status of the last command
if [ $? -eq 0 ]; then
    echo "ARM Template deployment initiated successfully."
else
    echo "Error: ARM Template deployment failed."
    exit 1
fi

# Exit normally
exit 0