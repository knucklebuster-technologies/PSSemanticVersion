$FileList = @(
    'README.md'
    'PSSemanticVersion.psm1'
    'PSSemanticVersion.psd1'
    'LICENSE'
)

$FileList += Get-ChildItem .\objs | Resolve-Path -Relative | Out-String
$FileList += Get-ChildItem .\en-US | Resolve-Path -Relative | Out-String
$FileList += Get-ChildItem .\cmds | Resolve-Path -Relative | Out-String

Publish-Module -Path . -