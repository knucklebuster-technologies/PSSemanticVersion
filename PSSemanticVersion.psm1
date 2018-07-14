# Adding a .net type
Add-Type -Path "$PSScriptRoot\objs\PSSemanticVersion.Version.cs"

# Implement your module commands in this script.

. "$PSScriptRoot\Cmds\New-SemanticVersion.ps1"

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function 'New-SemanticVersion'