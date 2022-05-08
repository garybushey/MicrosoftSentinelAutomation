# MicrosoftSentinelAutomation
Some PowerShell scripts to extract MS Sentinel automation rules

## Export-AzSentinelAllAutomationRulestoJSON
This script will extract every automation rule in your MS Sentinel environment and save each as a separate JSON file, using the rule's displayName as the file's name

## Export-AzSentinelAutomationRuletoJSON
This script will extract a single automation rule in your MS Sentinel environment and save to a JSON file, using the rule's displayName as the file's name

## Get-AzSentinelAutomationRule
Displays one or more automation rules.  If you pass in the AutomationRuleId value, only that automation rule will be displayed.  Otherwise all the rules will be displayed.

## Get-AzSentinelAutomationRuleIDs
Displays just the automation rule's displayname and ids.   Easy way to get a single ID.
