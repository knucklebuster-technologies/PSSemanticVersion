@{
RootModule = 'PSSemanticVersion.psm1'
ModuleVersion = '0.0.1'
GUID = 'ee4c58ca-b5bb-4263-98b4-6dd295495596'
Author = 'Paul H Cassidy (qawarrior)'
CompanyName = 'Warrior IT Services'
Copyright = '(c) 2018 Warrior IT Services. All rights reserved.'
Description = @'
    Provide a semantic version 2.0 compliant object.
    Should be able to produce a system.version object
    from the semver object
    major.minor.patch-PR+BM -> major.minor.revision.build
'@
FileList = @(
    '.\backup.cmd'
    '.\LICENSE'
    '.\README.md'
    '.\PSSemanticVersion.psd1'
    '.\PSSemanticVersion.psm1'
    '.\Cmds\New-SemanticVersion.ps1'
)
PrivateData = @{
    PSData = @{
        Tags = @('semver', 'version')
        LicenseUri = ''
        ProjectUri = ''
        IconUri = ''
        ReleaseNotes = ''
    }
}
HelpInfoURI = ''
}


