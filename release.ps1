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
Update-ModuleManifest -Path "$PSScriptRoot\PSSemanticVersion.psd1" -FileList $FileList

# Update Version in Manifest
$Version = Get-Content -Path "$PSScriptRoot\version.json" | ConvertFrom-Json
$Version.Patch++
$Version | ConvertTo-Json | Out-File -FilePath "$PSScriptRoot\version.json"
$mv = [Version]::new($Version.Major, $Version.Minor, $Version.Patch, $Version.Build)
Update-ModuleManifest -Path "$PSScriptRoot\PSSemanticVersion.psd1" -ModuleVersion "$mv"

Publish-Module -Path $PSScriptRoot -NuGetApiKey $APIKey