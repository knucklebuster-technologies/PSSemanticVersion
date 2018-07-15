<#
.SYNOPSIS
    Returns a semver 2.0 compliant object
.DESCRIPTION
    Creates and returns a semantic version 2.0 compliant .net
    object. The returned objects properties are set using the
    default or supplied parameters. the returned object has a
    set of ScriptMethods to help with using the object.
    METHODS:
    ToString - Returns a semver 2.0 formatted string example:
        v1.0.13-ctp+123
    Parse - Takes a semver 2.0 formatted string
        (1.0.23-ctp+123) and sets the objects properties
        from the formatted string. Returns True if updated
        or False if not updated.
    FromVersionJson - Takes the folder path that contains
        the version.json file to use. The json is used to
        set the properties on the object. Returns True if
        the properties are updated and False if they are not.
    ToVersionJson - Takes the folder path to write the
        version.json file. The file is recreated each
        time the object is serialized to json. Returns
        True if file is created and False if it is not.
    FromSystemVersion - Takes a System.Version object and
        updates the current semver object. Returns True if
        updated and False if not updated. Allows a consistant
        way to convert from System.Version to PSSemanticVersion.Version.
    ToSystemVersion - Returns a System.Version object based
        on the values of current semver object. the current
        semver object is attached to the System.Version as a
        NoteProperty named SemVer. Allows a consistant way to
        convert from PSSemanticVersion.Version to System.Version.
.PARAMETER Major
    Sets the Major property on the returned object.
    This is the first section in SemVer 2.0 and appears
    before the first '.'.
.PARAMETER Minor
    Sets the Minor property on the returned object.
    This is the second section in SemVer 2.0 and appears
    before the second '.'.
.PARAMETER Patch
    Sets the Patch property on the returned object.
    This is the third section in SemVer 2.0 and appears
    after the second '.'.
.PARAMETER Build
    Sets the Build property on the returned object.
    This is the final section in Semver 2.0 and appears
    after a '+' at the very end of the semver. This is
    an optional section and wont be included in string
    output if value is 0.
.PARAMETER Tag
    Sets the Tag property on the returned object.
    This is an optional section of semver it is
    used to denote pre-release version such as alpha,
    beta, ctp, etc. This is included if the value is
    not null or empty. If included it will appear after
    the Patch and a '-' and before the '+' and Build if
    it was incuded.
.EXAMPLE
    PS C:\> $semver = New-SemanticVersion -Major 1 -Minor 0 -Patch 1 -Build 123 -Tag Alpha
    PS C:\> $Semver.ToString()
    v1.0.1-Alpha+123
.EXAMPLE
    PS C:\> $semver = New-SemanticVersion
    PS C:\> if ($semver.Parse("v1.0.1-Alpha+123")) { $semver }
    Major          : 1
    Minor          : 0
    Patch          : 1
    Tag            : Alpha
    Build          : 123
    LeadingV       : v
    ParsedString   : v1.0.1-Alpha+123
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

    try {
        $ErrorActionPreference = 'Stop'
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

        return $true
    } catch {
        return $false
    }
} -Force
    # FromVersionJson takes a folder path and loads a file named version.json
    $obj | Add-Member -MemberType ScriptMethod -Name FromVersionJson -Value {
        Param (
            [string]$path
        )
        if ((Test-Path "$path" -PathType Container) -and (Test-Path "$path\version.json")) {
            $version = Get-Content -Path "$path\version.json" | ConvertFrom-Json
            $this.Major = $version.Major
            $this.Minor = $version.Minor
            $this.Patch = $version.Patch
            $this.Build = $version.Build
            $this.Tag = $version.Tag
            $this.LeadingV = $version.LeadingV
            $this.ParsedString = $version.ParsedString
            return $true
        }
        return $false
    } -Force
    # ToVersionJson takes a folder path and writes a file named version.json
    $obj | Add-Member -MemberType ScriptMethod -Name ToVersionJson -Value {
        Param (
            [string]$path
        )
        if (Test-Path $path -PathType Container) {
            $this | ConvertTo-Json | Out-File -FilePath "$path\version.json"
            return $true
        }
        return $false
    }
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