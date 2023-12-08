#requires -version 6.2
<#
    .SYNOPSIS
        This command will show all the Microsoft Sentinel Analytic displayNames and IDs 
    .DESCRIPTION
        This command will show all the Microsoft Sentinel Analytic displayNames and IDs
    .PARAMETER WorkSpaceName
        Enter the Log Analytics workspace name, this is a required parameter
    .PARAMETER ResourceGroupName
        Enter the Log Analytics workspace name, this is a required parameter
    .NOTES
        AUTHOR: Gary Bushey
        LASTEDIT: 8 May 2022
    .EXAMPLE
        Get-AzSentinelAutomationRuleIDs -WorkspaceName "workspacename" -ResourceGroupName "rgname"
        In this example you will see all the automation rule's display names and IDs
   
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$WorkSpaceName,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName

)
Function Get-AzSentinelAutomationRuleIDs ($workspaceName, $resourceGroupName) {

    #Setup the Authentication header needed for the REST calls
    $context = Get-AzContext
    $profile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($profile)
    $token = $profileClient.AcquireAccessToken($context.Subscription.TenantId)
    $authHeader = @{
        'Content-Type'  = 'application/json' 
        'Authorization' = 'Bearer ' + $token.AccessToken 
    }
    
    $SubscriptionId = (Get-AzContext).Subscription.Id

    #Load the templates so that we can copy the information as needed
    $url="https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.OperationalInsights/workspaces/$($workspaceName)/providers/Microsoft.SecurityInsights/automationRules?api-version=2022-12-01-preview"
    $results = (Invoke-RestMethod -Method "Get" -Uri $url -Headers $authHeader ).value

    foreach ($result in $results) {
        Write-Host ($result.properties.displayName, $result.name) -Separator " -> " -ForegroundColor DarkGreen -BackgroundColor White
    }
}


#Execute the code
Get-AzSentinelAutomationRuleIDs $WorkSpaceName $ResourceGroupName
