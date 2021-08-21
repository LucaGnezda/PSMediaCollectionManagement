using module .\..\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1

<#
    .SYNOPSIS
    Adds a 2 character whitespace to all "Write-ToConsole*" functions, until reset or removed.

    .DESCRIPTION
    This functions works with all "Write-ToConsole*" functions and is paired with "Reset-ConsoleIndent" and 
    "Remove-ConsoleIndent". It adds a 2 character whitespace to all "Write-ToConsole*" functions, until reset 
    or removed.   

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Add-ConsoleIndent
#>
function Add-ConsoleIndent
{
    [ModuleState]::ToConsole_LastCommandIdThatWroteToConsole = (Get-History -count 1).Id
    [ModuleState]::ToConsole_IndentLevel++
}