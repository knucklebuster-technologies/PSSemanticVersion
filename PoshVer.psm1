# Implement your module commands in this script.
$PoshVer = [PSCustomObject]@{
    Major          = [int64]::MinValue
    Minor          = [int64]::MinValue
    Patch          = [int54]::MinValue
    PreRelease     = [string]::Empty
    BuildMeatadata = [string]::Empty
    OriginalString = [string]::Empty
    LeadingV       = $false
} |
Add-Member -MemberType ScriptMethod -Name ToString -Value {$this} -Force -PassThru

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-* -Variable PoshVer
