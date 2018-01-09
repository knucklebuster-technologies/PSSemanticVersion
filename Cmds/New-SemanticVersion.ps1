


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
        [uint64]$Major          = [uint64]::MinValue,
        [uint64]$Minor          = [uint64]::MinValue,
        [uint64]$Patch          = [uint64]::MinValue,
        [String]$PrereleaseTag  = [string]::Empty,
        [String]$BuildMetadata  = [string]::Empty,
        [String]$LeadingV       = 'v'
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
    } -Force -PassThru |
    Add-Member -MemberType ScriptMethod -Name Parse -Value {
        Param (
            [string]$semver
        )

        # Store the original passed in
        $this.OriginalString = $semver
        # Extract the build metadata
        $this.BuildMeatadata = $semver.Split('+')[-1]
        # Extract the pre-release tag
        $this.PreReleaseTag = $semver.Split('+')[0].Split('-')[-1]

        # Get the version parts
        $ver = $semver.Split('+')[0].Split('-')[0].Split('.')
        # Store the patch
        $this.Patch = $ver[2]
        # Store the minor
        $this.Minor = $ver[1]
        # Store the major and leading v if one
        $m = $ver[0]
        if ($m[0] -eq 'v') {
            $this.LeadingV = $m[0]
            $this.Major = $m.Remove(0,1)
        }
        else {
            $this.LeadingV = ''
            $this.Major = $m
        }


    } -Force -PassThru
}