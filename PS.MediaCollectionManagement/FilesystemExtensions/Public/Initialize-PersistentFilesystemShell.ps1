using module .\..\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1

<#
    .SYNOPSIS
    Initializes a persistent Shell Application reusable by Filesystem Extension commands.

    .DESCRIPTION
    Initializes a persistent Shell Application if one does not already exist. This is reusable by Filesystem Extension commands, to reduce instantiation and dsiposal cycles.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    [Bool] 
    Returns true if this call was responsible for instantiating the shell application. Useful for managing dispsal scopes.

    .EXAMPLE
    PS> Initialize-PersistentFilesystemShell
#>
function Initialize-PersistentFilesystemShell () {
    return [FilesystemExtensionsState]::InstantiateShell()
}