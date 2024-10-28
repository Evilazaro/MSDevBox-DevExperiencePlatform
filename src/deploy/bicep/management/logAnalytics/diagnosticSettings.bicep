@description('Diagnostic settings name for the log analytics workspace')
param name string

@description('The name of the log analytics workspace')
param logAnalyticsWorkspaceName string

@description('Log Analytics Resource Group Name')
param logAnalyticsResourceGroupName string

@description('Get an existent log analytics workspace')
resource logAnalyticsWorkSpace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspaceName
  scope: resourceGroup(logAnalyticsResourceGroupName)
}

@description('Deploy the diagnostic settings')
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  properties: {
    logs: [
      {
        category: 'AllLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    workspaceId: logAnalyticsWorkSpace.id
  }
}

@description('Diagnostic Settings ID')
output diagnosticSettingsId string = diagnosticSettings.id

@description('Diagnostic Settings Name')
output diagnosticSettingsName string = diagnosticSettings.name
