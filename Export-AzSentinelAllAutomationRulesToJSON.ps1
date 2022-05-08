#requires -version 6.2
<#
    .SYNOPSIS
        This command will generate individual JSON files containing the information for each  Microsoft Sentinel
        automation rule.  Requires you to already be logged into Azure and in the correct subscription.
    .DESCRIPTION
         This command will generate individual JSON files containing the information for each  Microsoft Sentinel
        automation rule.  Requires you to already be logged into Azure and in the correct subscription.
    .PARAMETER WorkSpaceName
        Enter the Log Analytics workspace name, this is a required parameter
    .PARAMETER ResourceGroupName
        Enter the Log Analytics workspace name, this is a required parameter
    .NOTES
        AUTHOR: Gary Bushey
        LASTEDIT: 8 May 2022
    .EXAMPLE
        Export-AzSentinelAutomationRuletoJSON -WorkspaceName "workspacename" -ResourceGroupName "rgname" 
        In this example each automation rule will be exported to a separate JSON file 
    .EXAMPLE
        Export-AzSentinelAutimationRuletoJSON -WorkspaceName "workspacename" -ResourceGroupName "rgname" 
         In this example each automation rule will be exported to a separate JSON file
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$WorkSpaceName,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName
)
Function Export-AzSentinelAutomationRuletoJSON ($workspaceName, $resourceGroupName) {


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

    $url="https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.OperationalInsights/workspaces/$($workspaceName)/providers/Microsoft.SecurityInsights/automationRules/?api-version=2021-10-01-preview"
    $results = (Invoke-RestMethod -Method "Get" -Uri $url -Headers $authHeader ).value

    foreach ($result in $results) {
        $resultJson = ConvertTo-Json $result -depth 100
        $resultDisplayName = $result.properties.displayName
        $resultJson | Out-File ($resultDisplayName +".json")
    }
}

Export-AzSentinelAutomationRuletoJSON $WorkSpaceName $ResourceGroupName 
