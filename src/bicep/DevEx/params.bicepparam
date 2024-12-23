using 'devExWorkload.bicep'

@description('Workload Name')
param workloadName  = 'Contoso'

@description('Connectivity Info')
param networkConnectionsCreated = [
  {
    name: 'eShop'
    networkConnection: {
      domainJoinType: 'AzureADJoin'
    }
  }
  {
    name: 'Contoso-Traders'
    networkConnection: {
      domainJoinType: 'AzureADJoin'
    }
  }
]

@description('Contoso Dev Center Catalog')
param contosoDevCenterCatalogInfo = {
  name: 'Contoso-Custom-Tasks'
  syncType: 'Scheduled'
  type: 'GitHub'
  uri: 'https://github.com/Evilazaro/DevExp-DevBox.git'
  branch: 'main'
  path: '/.configuration/devcenter/customizations/tasks'
}

@description('Environment Types Info')
param environmentTypesInfo = [
  {
    name: 'DEV'
    tags: {
      workload: '${workloadName}-DevExp'
      landingZone: 'DevExp'
      resourceType: 'DevCenter'
      ProductTeam: 'Platform Engineering'
      Environment: 'Dev'
      Department: 'IT'
      offering: 'DevBox-as-a-Service'
    }
  }
  {
    name: 'PROD'
    tags: {
      workload: '${workloadName}-DevExp'
      landingZone: 'DevExp'
      resourceType: 'DevCenter'
      ProductTeam: 'Platform Engineering'
      Environment: 'Production'
      Department: 'IT'
      offering: 'DevBox-as-a-Service'
    }
  }
  {
    name: 'STAGING'
    tags: {
      workload: '${workloadName}-DevExp'
      landingZone: 'DevExp'
      resourceType: 'DevCenter'
      ProductTeam: 'Platform Engineering'
      Environment: 'Staging'
      Department: 'IT'
      offering: 'DevBox-as-a-Service'
    }
  }
]

@description('Contoso Dev Center Dev Box Definitions')
param contosoDevCenterDevBoxDefinitionsInfo = [
  {
    name: 'Contoso-BackEnd-Engineer'
    imageName: 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    sku: 'general_i_32c128gb512ssd_v2'
    hibernateSupport: 'Disabled'
    tags: {
      workload: '${workloadName}-DevExp'
      landingZone: 'DevExp'
      resourceType: 'DevCenter'
      ProductTeam: 'Platform Engineering'
      Environment: 'Production'
      Department: 'IT'
      offering: 'DevBox-as-a-Service'
      roleName: 'BackEnd-Engineer'
    }
  }
  {
    name: 'Contoso-FrontEnd-Engineer'
    imageName: 'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-m365'
    sku: 'general_i_16c64gb256ssd_v2'
    hibernateSupport: 'Enabled'
    tags: {
      workload: '${workloadName}-DevExp'
      landingZone: 'DevExp'
      resourceType: 'DevCenter'
      ProductTeam: 'Platform Engineering'
      Environment: 'Production'
      Department: 'IT'
      offering: 'DevBox-as-a-Service'
      roleName: 'FrontEnd-Engineer'
    }
  }
]

@description('Workload Role Definitions')
param workloadroleDefinitions = [
  '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  '331c37c6-af14-46d9-b9f4-e1909e1b95a0'
  '45d50f46-0b78-4001-a660-4198cbe8cd05'
  '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  '18e40d4e-8d2e-438d-97e1-9528336e149c'
  'eb960402-bf75-4cc3-8d68-35b34f960f72'
]

@description('Contoso Projects Info')
param contosoProjectsInfo = [
  {
    name: 'eShop'
    networkConnectionName: networkConnectionsCreated[0].name
    catalogs: [
      {
        catalogName: 'imageDefinitions'
        uri: 'https://github.com/Evilazaro/eShop.git'
        branch: 'main'
        path: '/.configurations/environments'
      }
      {
        catalogName: 'environments'
        uri: 'https://github.com/Evilazaro/eShop.git'
        branch: 'main'
        path: '/.configurations/environments'
      }
    ]
    tags: {
      workload: '${workloadName}-DevExp'
      landingZone: 'DevExp'
      resourceType: 'DevCenter'
      ProductTeam: 'Platform Engineering'
      Environment: 'Production'
      Department: 'IT'
      offering: 'DevBox-as-a-Service'
      project: 'eShop'
    }
  }
  {
    name: 'Contoso-Traders'
    networkConnectionName: networkConnectionsCreated[1].name
    catalogs: [
      {
        catalogName: 'imageDefinitions'
        uri: 'https://github.com/Evilazaro/contosotraders.git'
        branch: 'main'
        path: '/.configurations/environments'
      }
      {
        catalogName: 'environments'
        uri: 'https://github.com/Evilazaro/contosotraders.git'
        branch: 'main'
        path: '/.configurations/environments'
      }
    ]
    tags: {
      workload: '${workloadName}-DevExp'
      landingZone: 'DevExp'
      resourceType: 'DevCenter'
      ProductTeam: 'Platform Engineering'
      Environment: 'Production'
      Department: 'IT'
      offering: 'DevBox-as-a-Service'
      project: 'Contoso-Traders'
    }
  }
]

