

function New-SemanticVersion {
    return [PSCustomObject]@{
        Major          = [int64]::MinValue
        Minor          = [int64]::MinValue
        Patch          = [int54]::MinValue
        PreRelease     = [string]::Empty
        BuildMeatadata = [string]::Empty
        OriginalString = [string]::Empty
        LeadingV       = [string]::Empty
    } |
    Add-Member -MemberType ScriptMethod -Name ToString -Value {$this} -Force -PassThru
}