using module .\..\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1

<#
    .SYNOPSIS
    Wrapper for Rename-Item.

    .DESCRIPTION
    Wrapper for Rename-Item. Performs a WhatIf if module is in a mock state.

    .INPUTS
    [String] Path
    [String] NewName

    .OUTPUTS
    [Boolean] $true if update successful 
    

    .EXAMPLE
    PS> Rename-File ".\Foo.tex" "Bar.txt"
#>
function Rename-File (
    [Parameter(Mandatory=$true)]
    [String] $Path,

    [Parameter(Mandatory=$true)]
    [String] $NewName
)
{
    $fullDestPath = Split-Path $path
    $srcFileName  = Split-Path $path -Leaf
    if ($fullDestPath.Length -eq 0) { $fullDestPath = "." }
    $fullDestPath = $fullDestPath + "\" + $newName

    # If the file exists and the rename isn't just a change of case, prevent the rename, otherwise continue. 
    if ($srcFileName -ceq $NewName) {
        # If there is no change, do nothing.
        return $false
    }
    elseif ((Test-Path $fullDestPath) -and ($srcFileName -ne $NewName)) {
        # If a file already exists and the rename isn't just a change of case of the current file then prevent the rename. 
        Write-WarnToConsole "Unable to rename file, a file with the destination name already exists. Abandoning rename."
        return $false
    }
    elseif ([FilesystemExtensionsState]::MockDestructiveActions) {
        # Mock if set
        Rename-Item $path $newName -WhatIf
        return $true
    } 
    else {
        # Otherwise Rename
        Rename-Item $path $newName
        return $true
    }
}