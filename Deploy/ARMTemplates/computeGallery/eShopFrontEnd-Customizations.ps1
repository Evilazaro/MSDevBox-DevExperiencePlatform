<#
.SYNOPSIS
This script clones repositories, installs Docker Desktop, and VS Code Extensions.

.DESCRIPTION
The script performs the following actions:
- Sets the execution policy to Bypass for the process scope.
- Clones the specified repositories to the specified destinations.
- Installs Docker Desktop using Chocolatey.
- Installs specified VS Code Extensions.
#>

# Set the execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Define repositories to clone
$repositories = @(
    @{
        Url = 'https://github.com/Evilazaro/eShopOnContainers.git'
        Destination = 'c:\eShop'
        Description = 'eShopOnContainers Repository'
    },
    @{
        Url = 'https://github.com/Evilazaro/eShopAPIM.git'
        Destination = 'c:\eShopAPIM'
        Description = 'eShopOnContainers APIs Repository'
    }
)

function Clone-Repositories {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$Repositories
    )

    foreach ($repo in $Repositories) {
        Write-Output "Cloning $($repo.Description)"
        try {
            git clone $repo.Url $repo.Destination
        } catch {
            throw "Failed to clone $($repo.Description) from $($repo.Url) to $($repo.Destination)"
        }
    }
}

function Install-VSCodeExtensions {
    Write-Output "Installing VS Code Extensions"
    try {
        mkdir c:\VSExtensions
        code --extensions-dir c:\VSExtensions
        code --install-extension ms-vscode-remote.remote-wsl --force 
        code --install-extension ms-vscode.vscode-node-azure-pack --force
        code --install-extension ms-azuretools.vscode-docker --force
        code --install-extension ms-kubernetes-tools.vscode-aks-tools --force
        code --install-extension ms-azuretools.vscode-apimanagement --force
        code --install-extension VisualStudioOnlineApplicationInsights.application-insights --force
        code --install-extension ms-dotnettools.csdevkit --force
    } catch {
        throw "Failed to install VS Code Extensions"
    }
}

# Execute Functions
try {
    Clone-Repositories -Repositories $repositories
    Install-VSCodeExtensions
    Write-Output "Script completed successfully"
} catch {
    Write-Error $_.Exception.Message
    throw $_.Exception
}