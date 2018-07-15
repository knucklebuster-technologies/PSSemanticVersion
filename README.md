# PSSemanticVersion
The module contains one command 'New-SemanticVersion' and return exactly one object PSSemanticVersion.Version. The returned object proerties are set based on the default and supplied aurguments to the command. The object contains many useful methods and properties to work wtih semver in powershell developemnt.

## PSSemanticVersion.Version Object
### METHODS:
- ToString: Returns a semver 2.0 formatted string example: v1.0.13-ctp+123
- Parse: Takes a semver 2.0 formatted string (1.0.23-ctp+123) and sets
    the objects properties from the formatted string. Returns True if updated or False if not updated.
- FromVersionJson: Takes the folder path that contains
    the version.json file to use. The json is used to
    set the properties on the object. Returns True if
    the properties are updated and False if they are not.
- ToVersionJson: Takes the folder path to write the
    version.json file. The file is recreated each
    time the object is serialized to json. Returns
    True if file is created and False if it is not.
- FromSystemVersion: Takes a System.Version object and
    updates the current semver object. Returns True if
    updated and False if not updated. Allows a consistant
    way to convert from System.Version to PSSemanticVersion.Version.
- ToSystemVersion: Returns a System.Version object based
    on the values of current semver object. the current
    semver object is attached to the System.Version as a
    NoteProperty named SemVer. Allows a consistant way to
    convert from PSSemanticVersion.Version to System.Version.