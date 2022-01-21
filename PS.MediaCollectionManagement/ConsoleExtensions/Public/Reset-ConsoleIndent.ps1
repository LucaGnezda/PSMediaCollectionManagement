using module .\..\Using\ModuleBehaviour\ConsoleExtensionsSettings.Static.psm1
using module .\..\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

<#
    .SYNOPSIS
    Resets the character whitespace for all "Write-ToConsole*" functions.

    .DESCRIPTION
    This functions works with all "Write-ToConsole*" functions and is paired with "Add-ConsoleIndent" and 
    "Remove-ConsoleIndent". It adds a 2 character whitespace to all "Write-ToConsole*" functions, until reset 
    or removed.   

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Reset-ConsoleIndent
#>
function Reset-ConsoleIndent
{
    [ConsoleExtensionsState]::IndentLevel = [ConsoleExtensionsSettings]::MIN_INDENT()
}