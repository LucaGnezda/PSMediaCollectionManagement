using module .\..\Using\ModuleBehaviour\ConsoleExtensionsSettings.Abstract.psm1
using module .\..\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1

<#
    .SYNOPSIS
    Removed a 2 character whitespace to all "Write-ToConsole*" functions, until added or reset.

    .DESCRIPTION
    This functions works with all "Write-ToConsole*" functions and is paired with "Reset-ConsoleIndent" and 
    "Add-ConsoleIndent". It removes a 2 character whitespace to all "Write-ToConsole*" functions, until reset 
    or removed.   

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Remove-ConsoleIndent
#>
function Remove-ConsoleIndent
{
    [ConsoleExtensionsState]::IndentLevel = [Math]::Max([ConsoleExtensionsState]::IndentLevel - 1, [ConsoleExtensionsSettings]::MIN_INDENT())
}