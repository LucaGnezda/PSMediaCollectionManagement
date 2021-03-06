using module .\..\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

<#
    .SYNOPSIS
    Writes to console (Write-Host) or to a mock console if set. 

    .DESCRIPTION
   Writes to console (Write-Host) or to a mock console if set. Also honours any indent settings from Add, Remove 
    and Reset-Console Indent. Allows user to set colour.

    .INPUTS
    [Switch] NoNewLine
    [System.ConsoleColor] ForegroundColor
    [System.Collections.Generic.List[Object]] Object

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Write-SuccessToConsole "Hello"
#>
function Write-ToConsole (
    [Parameter(Mandatory=$false, ParameterSetName="WithColor")]
    [Parameter(Mandatory=$false, ParameterSetName="WithoutColor")]
    [Switch] $NoNewLine,   
    
    [Parameter(Mandatory=$false, ParameterSetName="WithColor")]
    [Parameter(Mandatory=$false, ParameterSetName="WithoutColor")]
    [Switch] $NoIndent, 

    [Parameter(Mandatory=$true, ParameterSetName="WithColor")]
    [System.ConsoleColor] $ForegroundColor,

    [Parameter(Mandatory=$false, ValueFromRemainingArguments, ParameterSetName="WithColor")]
    [Parameter(Mandatory=$false, ValueFromRemainingArguments, ParameterSetName="WithoutColor")]
    [System.Collections.Generic.List[Object]]
    $Object=""
) {
    Set-ConsoleState @PSBoundParameters
    # if suppressing console output return
    if ([ConsoleExtensionsState]::RedirectToMockConsole) {
        [ConsoleExtensionsState]::MockConsoleReceiver(($Object -join " "), [ConsoleExtensionsState]::ContinuingLine)
    }
    else { # Otherwise write as normal
        if ($PSBoundParameters.ContainsKey("NoIndent")) {
            $PSBoundParameters.Remove("NoIndent") | Out-Null
        }
        Write-Host @PSBoundParameters
    }
}