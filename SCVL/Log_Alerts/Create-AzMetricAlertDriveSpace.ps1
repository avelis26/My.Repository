<#
New-AzResourceGroupDeployment -ResourceGroupName "contosoRG" -TemplateFile "D:\Azure\Templates\sampleScheduledQueryRule.json"
https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-log#managing-log-alerts-using-azure-resource-template
#>
$file = './DriveSpace.json'
$jsonObj = Get-Content -Raw -Path $file | ConvertFrom-Json
$jsonObj.variables.alertLocation = 'test'
Write-Output $jsonObj.variables.alertLocation
