using module .\..\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1

<#
    .SYNOPSIS
    Disposes of the persistent Shell Application if it exists.

    .DESCRIPTION
    Disposes of the persistent Shell Application if it exists.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    [Bool] 
    Returns true if this call was responsible for instantiating the shell application. Useful for managing dispsal scopes.

    .EXAMPLE
    PS> Remove-PersistentFilesystemShell
#>
function Remove-PersistentFilesystemShell () {
    [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
}