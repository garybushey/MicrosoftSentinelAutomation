#requires -version 6.2
<#
    .SYNOPSIS
        Gets a specific or all Automation rules.
    .DESCRIPTION
        The Get-AzSentienlAutomationRe=ules cmdlet gets one or more Automation rules from the specified workspace.  If you specify the 
        AutomationRuleId parameter, a single Automation rule is returned.  If you do not specify the AutomationRuleId parameter, all the 
        automation reuls in the specified workspace will be returned
    .PARAMETER WorkSpaceName
        Enter the Log Analytics workspace name, this is a required parameter
    .PARAMETER ResourceGroupName
        Enter the Log Analytics workspace name, this is a required parameter
    .PARAMETER AutomationRuleId
        Enter the Microsoft Sentinel Automation rule Id, this is an optional parameter
    .NOTES
        AUTHOR: Gary Bushey
        LASTEDIT: 8 May 2022
    .EXAMPLE
        List-AzSentinelAutomationRules -WorkspaceName "workspacename" -ResourceGroupName "rgname" -AutomationRuleId
        In this example the specified automation rule will be listed as JSON
    .EXAMPLE
        Export-AzSentinelAutimationRuletoJSON -WorkspaceName "workspacename" -ResourceGroupName "rgname" 
        In this example all the automation rules will be listed as JSON
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$WorkSpaceName,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $false)]
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

    if ($rulename) {
        $url = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.OperationalInsights/workspaces/$($workspaceName)/providers/Microsoft.SecurityInsights/automationRules/$($rulename)?api-version=2021-10-01-preview"
        $results = (Invoke-RestMethod -Method "Get" -Uri $url -Headers $authHeader )

        ConvertTo-Json $results -depth 100
    }
    else {
        $url = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.OperationalInsights/workspaces/$($workspaceName)/providers/Microsoft.SecurityInsights/automationRules/?api-version=2021-10-01-preview"
        $results = (Invoke-RestMethod -Method "Get" -Uri $url -Headers $authHeader ).value

        foreach ($result in $results) {
            ConvertTo-Json $result -depth 100
        }
    }
    
}

Export-AzSentinelAutomationRuleToJSON $WorkSpaceName $ResourceGroupName $AutomationRuleId
