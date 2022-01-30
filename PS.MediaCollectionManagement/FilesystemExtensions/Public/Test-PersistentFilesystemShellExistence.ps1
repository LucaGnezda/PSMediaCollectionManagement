using module .\..\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1

<#
    .SYNOPSIS
    Tests for existence of the persistent Shell Application.

    .DESCRIPTION
     Tests for existence of the persistent Shell Application.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    [Bool] 
    Returns true if the persistent Shell Application exists. 

    .EXAMPLE
    PS> Test-PersistentFilesystemShell
#>
function Test-PersistentFilesystemShellExistence () {
    return ($null -ne [FilesystemExtensionsState]::Shell)
}