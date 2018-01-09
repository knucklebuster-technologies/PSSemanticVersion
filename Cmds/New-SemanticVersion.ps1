


<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function New-SemanticVersion {
    Param (
        [Int64]$Major          = 0,
        [Int64]$Minor          = 0,
        [Int64]$Patch          = 0,
        [String]$PrereleaseTag = '',
        [String]$BuildMetadata = '',
        [String]$LeadingV      = 'v'
    )
    return [PSCustomObject]@{
        Major             = $Major
        Minor             = $Minor
        Patch             = $Patch
        PreReleaseTag     = $PrereleaseTag
        BuildMeatadata    = $BuildMetadata
        LeadingV          = $LeadingV
        OriginalString    = [string]::Empty
    } |
    Add-Member -MemberType ScriptMethod -Name ToString -Value {
        $sb = $this.LeadingV + $this.Major + '.'
        $sb = $sb + $this.Minor + '.'
        $sb = $sb + $this.Patch
        if ($this.PreRelease -ne [string]::Empty) {
            $sb = $sb + '-' + $this.PreReleaseTag
        }
        if ($this.BuildMeatadata -ne [string]::Empty) {
            $sb = $sb + '+' + $this.BuildMeatadata
        }
        return $sb
    } -Force -PassThru
}