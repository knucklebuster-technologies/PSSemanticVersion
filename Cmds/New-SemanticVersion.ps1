
<#
.SYNOPSIS
    Returns a semver 2.0 compliant object
.DESCRIPTION
    Creates and returns a semantic version 2.0 compliant object.
    Object provides methods to create a consistant System.Version
    object based upon the SemVer values.
.EXAMPLE
    PS C:\> $semver = New-SemanticVersion -Major 1 -Minor 0 -Patch 1 -BuildRevision 123 -PrereleaseTag Alpha
    PS C:\> $Semver.ToString()
    v1.0.1-Alpha+123

    PS C:\> $Semver.ToMSVersion()

    Major  Minor  Build  Revision
    -----  -----  -----  --------
    1      0      1      123
.EXAMPLE
    PS C:\> $semver = New-SemanticVersion
    PS C:\> $semver.Parse("v1.0.1-Alpha+123")
    Major          : 1
    Minor          : 0
    Patch          : 1
    PreReleaseTag  : Alpha
    BuildRevision  : 123
    LeadingV       : v
    OriginalString : v1.0.1-Alpha+123
#>
function New-SemanticVersion {
    Param (
        [uint64]$Major          = [uint64]::MinValue,
        [uint64]$Minor          = [uint64]::MinValue,
        [uint64]$Patch          = [uint64]::MinValue,
        [uint64]$BuildRevision  = [uint64]::MinValue,
        [String]$PrereleaseTag  = [string]::Empty,
        [String]$LeadingV       = [string]::Empty
    )

    return [PSCustomObject]@{
        Major             = $Major
        Minor             = $Minor
        Patch             = $Patch
        PreReleaseTag     = $PrereleaseTag
        BuildRevision     = $BuildRevision
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
        if ($this.BuildRevision -ne 0) {
            $sb = $sb + '+' + $this.BuildRevision
        }
        return $sb
    } -Force -PassThru |
    Add-Member -MemberType ScriptMethod -Name Parse -Value {
        Param (
            [string]$semver
        )

        # Store the original passed in
        $this.OriginalString = $semver
        # Store the Leading v if exists
        if ($semver -like "v*") {
            $this.LeadingV = 'v'
            $semver = $semver.Remove(0,1)
        }
        else {
            $this.LeadingV = ''
        }

        # Process thru regex
        $semver -match "^(?<major>\d+)(\.(?<minor>\d+))?(\.(?<patch>\d+))?(\-(?<pre>[0-9A-Za-z\-\.]+))?(\+(?<build>\d+))?$" | Out-Null
        # Extract the build metadata
        $this.BuildRevision = [uint64]$matches['build']
        # Extract the pre-release tag
        $this.PreReleaseTag  = [string]$matches['pre']
        # Extract the patch
        $this.Patch          = [uint64]$matches['patch']
        # Extract the minor
        $this.Minor          = [uint64]$matches['minor']
        # Extract the major
        $this.Major          = [uint64]$matches['major']

        return $this

    } -Force -PassThru |
    Add-Member -MemberType ScriptMethod -Name FromMSVerion -Value {
        Param (
            [version]$msversion
        )

        $this.OriginalString  = "$msversion"
        $this.Major           = $msversion.Major
        $this.Minor           = $msversion.Minor
        $this.Patch           = $msversion.Build
        $this.BuildRevision   = $msversion.Revision
        $this.PreReleaseTag   = ''
        $this.LeadingV        = ''
        return $this

    } -Force -PassThru |
    Add-Member -MemberType ScriptMethod -Name ToMSVersion -Value {
        $semver = $this
        return [Version]::new(
            $this.Major,
            $this.Minor,
            $this.Patch,
            $this.BuildRevision
        ) |
        Add-Member -MemberType NoteProperty -Name 'SemVer' -Value $semver -Force -PassThru
    } -Force -PassThru
}