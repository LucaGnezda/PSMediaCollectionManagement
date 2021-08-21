using module .\..\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\..\using\Types\PS.MCM.Types.psm1

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