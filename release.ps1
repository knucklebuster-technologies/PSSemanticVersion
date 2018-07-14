$manifest = "$PSScriptRoot\PSSemanticVersion.psd1"
$versionJson = "$PSScriptRoot\version.json"

# Update FileList in manifest
$FileList = @(
    'README.md'
    'PSSemanticVersion.psm1'
    'PSSemanticVersion.psd1'
    'LICENSE'
)
$FileList += Get-ChildItem "$PSScriptRoot\objs" | Resolve-Path -Relative
$FileList += Get-ChildItem "$PSScriptRoot\en-US" | Resolve-Path -Relative
$FileList += Get-ChildItem "$PSScriptRoot\cmds" | Resolve-Path -Relative
#Update-ModuleManifest -Path "$PSScriptRoot\PSSemanticVersion.psd1" -FileList $FileList

# Import Module for use
Import-Module $manifest -Force

# Update Version in Manifest
$Version = New-SemanticVersion
$Version.FromVersionJson($versionJson)
$Version.Patch++
$Version.ToVersionJson($versionJson)
Update-ModuleManifest -Path $manifest -ModuleVersion $Version.ToSystemVersion()

Publish-Module -Path $PSScriptRoot -NuGetApiKey $APIKey