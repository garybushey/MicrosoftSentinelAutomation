# MicrosoftSentinelAutomation
Some PowerShell scripts to extract MS Sentinel automation rules

## Export-AzSentinelAutomationRule
Exports one or more Automation rules from the specified workspace.  If you specify the AutomationRuleId parameter, a single Automation rule is exported.  If you do not specify the AutomationRuleId parameter, all the automation reuls in the specified workspace will be exported.  The filename will be the automation rule's <displayName>.json

## Get-AzSentinelAutomationRule
Displays one or more automation rules.  If you pass in the AutomationRuleId value, only that automation rule will be displayed.  Otherwise all the rules will be displayed.

## Get-AzSentinelAutomationRuleIDs
Displays just the automation rule's displayname and ids.   Easy way to get a single ID.
