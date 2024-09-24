#!/bin/bash

# Exit immediately if a command exits with a non-zero status, treat unset variables as an error, and propagate errors in pipelines.
set -euo pipefail

echo "Deploying to Azure"

# Constants Parameters
branch="main"
location="WestUS3"

# Azure Resource Group Names Constants
devBoxResourceGroupName="petv2DevBox-rg"
imageGalleryResourceGroupName="petv2ImageGallery-rg"
identityResourceGroupName="petv2IdentityDevBox-rg"
networkResourceGroupName="petv2NetworkConnectivity-rg"
managementResourceGroupName="petv2DevBoxManagement-rg"

# Identity Parameters Constants
identityName="petv2DevBoxImgBldId"
customRoleName="petv2BuilderRole"
identityId=''

# Image and DevCenter Parameters Constants
imageGalleryName="petv2ImageGallery"
devCenterName="petv2DevCenter"

# Network Parameters Constants
vnetName="petv2Vnet"
subNetName="petv2SubNet"
networkConnectionName="devBoxNetworkConnection"

# Build Image local to inform if the image should be built
buildImage=${1:-false}
scriptDemo=${2:-false}

# Function to log in to Azure
azureLogin() {


    az login --use-device-code
    
}

# Function to create an Azure resource group
createResourceGroup() {
    local resourceGroupName="$1"

    if [[ -z "$resourceGroupName" || -z "$location" ]]; then
        echo "Error: Missing required parameters."
        echo "Usage: createResourceGroup <resourceGroupName> <location>"
        return 1
    fi

    echo "Creating Azure Resource Group: $resourceGroupName in $location"

    if az group create --name "$resourceGroupName" --location "$location" --tags "division=petv2-Platform" "Environment=Prod" "offer=petv2-DevWorkstation-Service" "Team=Engineering" "solution=ContosoFabricDevWorkstation"; then
        echo "Resource group '$resourceGroupName' created successfully."
    else
        echo "Error: Failed to create resource group '$resourceGroupName'."
        return 1
    fi
}

# Function to deploy resources for the organization
deployResourcesOrganization() {

    createResourceGroup "$devBoxResourceGroupName"
    createResourceGroup "$networkResourceGroupName"
    createResourceGroup "$managementResourceGroupName"

    demoScript
}

#!/bin/bash

# Function to deploy network resources
deployNetworkResources() {
    local networkResourceGroupName="$1"
    local vnetName="$2"
    local subNetName="$3"
    local networkConnectionName="$4"

    # Check if required parameters are provided
    if [[ -z "$networkResourceGroupName" || -z "$vnetName" || -z "$subNetName" || -z "$networkConnectionName" ]]; then
        echo "Error: Missing required parameters."
        echo "Usage: deployNetworkResources <networkResourceGroupName> <vnetName> <subNetName> <networkConnectionName>"
        return 1
    fi

    echo "Deploying network resources to resource group: $networkResourceGroupName"

    # Execute the Azure deployment command
    az deployment group create \
        --name "MicrosoftDevBox-NetworkDeployment" \
        --resource-group "$networkResourceGroupName" \
        --template-file ./network/deploy.bicep \
        --parameters \
            vnetName="$vnetName" \
            subnetName="$subNetName" \
            networkConnectionName="$networkConnectionName" \
        --verbose

    # Check if the deployment was successful
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to deploy network resources."
        return 1
    fi

    echo "Network resources deployed successfully."
}

#!/bin/bash

# Function to deploy Dev Center resources
deployDevCenter() {
    local devBoxResourceGroupName="$1"
    local devCenterName="$2"
    local networkConnectionName="$3"
    local identityName="$4"
    local customRoleName="$5"

    # Check if required parameters are provided
    if [[ -z "$devBoxResourceGroupName" || -z "$devCenterName" || -z "$networkConnectionName" || -z "$identityName" || -z "$customRoleName" ]]; then
        echo "Error: Missing required parameters."
        echo "Usage: deployDevCenter <devBoxResourceGroupName> <devCenterName> <networkConnectionName> <identityName> <customRoleName>"
        return 1
    fi

    echo "Deploying Dev Center resources to resource group: $devBoxResourceGroupName"

    # Execute the Azure deployment command
    az deployment group create \
        --name "MicrosoftDevBox-DevCenterDeployment" \
        --resource-group "$devBoxResourceGroupName" \
        --template-file ./devBox/deploy.bicep \
        --parameters \
            devCenterName="$devCenterName" \
            networkConnectionName="$networkConnectionName" \
            identityName="$identityName" \
            customRoleName="$customRoleName" \
            computeGalleryImageName="microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2" \
        --verbose

    # Check if the deployment was successful
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to deploy Dev Center resources."
        return 1
    fi

    echo "Dev Center resources deployed successfully."
}


deploy(){
    clear
    azureLogin
    deployResourcesOrganization
    deployNetworkResources "$networkResourceGroupName" "$vnetName" "$subNetName" "$networkConnectionName"
    deployDevCenter "$devBoxResourceGroupName" "$devCenterName" "$networkConnectionName" "$identityName" "$customRoleName"
}

demoScript() {
    if [[ "$scriptDemo" == "true" ]]; then
        read -p "Do you want to continue? (y/n) " answer
        if [[ "$answer" == "y" ]]; then
            clear
            echo "Continuing..."            
        else
            echo "Stopping the script."
            exit 1
        fi
    fi
}

deploy