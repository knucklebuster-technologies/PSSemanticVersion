$version = '1.10.234-RC.15+r154'

$version -match "^(?<major>\d+)(\.(?<minor>\d+))?(\.(?<patch>\d+))?(\-(?<pre>[0-9A-Za-z\-\.]+))?(\+(?<build>[0-9A-Za-z\-\.]+))?$" | Out-Null
$major = [int]$matches['major']
$minor = [int]$matches['minor']
$patch = [int]$matches['patch']
$pre   = [string]$matches['pre']
$build = [string]$matches['build']

New-Object PSObject -Property @{ 
    Major         = $major
    Minor         = $minor
    Patch         = $patch
    Pre           = $pre
    Build         = $build
    VersionString = $version
}