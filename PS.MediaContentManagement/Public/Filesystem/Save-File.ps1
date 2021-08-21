using module .\..\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\..\using\Types\PS.MCM.Types.psm1

<#
    .SYNOPSIS
    Wrapper for Save-File.

    .DESCRIPTION
    Wrapper for Out-File. Performs a WhatIf if module is in a mock state.

    .INPUTS
    [String] Path
    [String] InputObject (content to write to file)

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Save-File ".\Foo.txt" "Bar.txt"
#>
function Save-File (
    [Parameter(Mandatory=$true)]
    [String] $Path,

    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [String] $InputObject
)
{
    if ((Test-Path $Path -PathType Leaf) -and ([TestAttribute]::MockDestructiveActions -in [ModuleState]::Testing_States)) {
        # Mock the write
        $InputObject | Out-File $Path -WhatIf
    }
    else {
        # Write the file
        $InputObject | Out-File $Path
    }
}