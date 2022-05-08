#requires -version 6.2
<#
    .SYNOPSIS
        This command will generate individual JSON file containing the information about the selected Microsoft Sentinel
        automation rule.  Requires you to already be logged into Azure and in the correct subscription.
    .DESCRIPTION
        This command will generate individual JSON file containing the information about the selected Microsoft Sentinel
        automation rule.  Requires you to already be logged into Azure and in the correct subscription.
    .PARAMETER WorkSpaceName
        Enter the Log Analytics workspace name, this is a required parameter
    .PARAMETER ResourceGroupName
        Enter the Log Analytics workspace name, this is a required parameter
    .PARAMETER AutomationRuleId
        Enter the Microsoft Sentinel Automation rule Id, this is a required parameter
    .NOTES
        AUTHOR: Gary Bushey
        LASTEDIT: 8 May 2022
    .EXAMPLE
        Export-AzSentinelAutomationRuletoJSON -WorkspaceName "workspacename" -ResourceGroupName "rgname" -AutomationRuleName "rulename"
        In this example a single JSON file will be created containing the JSON for the automation rule

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$WorkSpaceName,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$AutomationRuleId
)
Function Export-AzSentinelAutomationRuleToJSON ($workspaceName, $resourceGroupName, $rulename) {


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
    $url = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.OperationalInsights/workspaces/$($workspaceName)/providers/Microsoft.SecurityInsights/automationRules/$($rulename)?api-version=2021-10-01-preview"
    $results = (Invoke-RestMethod -Method "Get" -Uri $url -Headers $authHeader )

    $resultJson = ConvertTo-Json $results -depth 100
    $resultDisplayName = $results.properties.displayName
    $resultJson | Out-File ($resultDisplayName + ".json")
}



Export-AzSentinelAutomationRuleToJSON $WorkSpaceName $ResourceGroupName $AutomationRuleId 
