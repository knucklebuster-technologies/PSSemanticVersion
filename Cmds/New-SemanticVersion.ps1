
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
        [uint64]$Major = [uint64]::MinValue,
        [uint64]$Minor = [uint64]::MinValue,
        [uint64]$Patch = [uint64]::MinValue,
        [uint64]$Build = [uint64]::MinValue,
        [String]$Tag = [string]::Empty
    )

    # Create instance of above .net type
    $obj = [PSSemanticVersion.Version]::new($Major,$Minor,$Patch,$Build,$Tag)
    # ToString overide that returns a correctly formatted semver string
    $obj | Add-Member -MemberType ScriptMethod -Name ToString -Value {
    $sb = "$($this.Major).$($this.Minor).$($this.Patch)"
    if ($this.LeadingV = $true) {
        $sb = "v$sb"
    }
    if ($this.Tag -ne [string]::Empty) {
        $sb = "$sb-$($this.Tag)"
    }
    if ($this.Build -gt 0) {
        $sb = "$sb+$($this.Build)"
    }
    return $sb
} -Force
    # Parse method takes semver string and extracts obj properties
    $obj | Add-Member -MemberType ScriptMethod -Name Parse -Value {
    Param (
        [string]$semver
    )

    # Store the original passed in
    $this.ParsedString = $semver
    # Store the Leading v if exists
    if ($semver -like "v*") {
        $this.LeadingV = $true
        $semver = $semver.Remove(0,1)
    }
    else {
        $this.LeadingV = $false
    }

    # Process thru regex
    $semver -match "^(?<major>\d+)(\.(?<minor>\d+))?(\.(?<patch>\d+))?(\-(?<pre>[0-9A-Za-z\-\.]+))?(\+(?<build>\d+))?$" | Out-Null
    # Extract the build metadata
    $this.Build = [uint64]$matches['build']
    # Extract the pre-release tag
    $this.Tag = [string]$matches['pre']
    # Extract the patch
    $this.Patch = [uint64]$matches['patch']
    # Extract the minor
    $this.Minor = [uint64]$matches['minor']
    # Extract the major
    $this.Major = [uint64]$matches['major']

    return $this

} -Force
    # FromSystemVersion takes a System.Version and extracts obj properties
    $obj | Add-Member -MemberType ScriptMethod -Name FromSystemVerion -Value {
    Param (
        [version]$sysVersion
    )

    $this.ParsedString = "$sysVersion"
    $this.Major = $sysVersion.Major
    $this.Minor = $sysVersion.Minor
    $this.Patch = $sysVersion.Build
    $this.Build = $sysVersion.Revision
    $this.Tag = ''
    $this.LeadingV = $false
    return $this

} -Force
    # ToSystemVersion
    $obj | Add-Member -MemberType ScriptMethod -Name ToSystemVersion -Value {
        $semver = $this
        return [Version]::new(
            $this.Major,
            $this.Minor,
            $this.Patch,
            $this.Build
        ) |
        Add-Member -MemberType NoteProperty -Name 'SemVer' -Value $semver -Force -PassThru
    } -Force -PassThru
}