<#
    .SYNOPSIS
    Writes to console (Write-Host) or to a mock console if set. 

    .DESCRIPTION
    Writes to console (Write-Host) or to a mock console if set. Also honours any indent settings from Add, Remove 
    and Reset-Console Indent. Always displays green, ignores colour if provided.

    .INPUTS
    [Switch] NoNewLine
    [System.Collections.Generic.List[Object]] Object

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Write-SuccessToConsole "Hello"
#>
function Write-SuccessToConsole (
    [Parameter(Mandatory=$false, ParameterSetName="WithColor")]
    [Parameter(Mandatory=$false, ParameterSetName="WithoutColor")]
    [Switch] $NoNewLine,    

    [Parameter(Mandatory=$true, ParameterSetName="WithColor")]
    [System.ConsoleColor] $ForegroundColor,

    [Parameter(Mandatory=$false, ValueFromRemainingArguments, ParameterSetName="WithColor")]
    [Parameter(Mandatory=$false, ValueFromRemainingArguments, ParameterSetName="WithoutColor")]
    [System.Collections.Generic.List[Object]]
    $Object=""
) {
    # Remove Foreground color if supplied
    if ($PSBoundParameters.ContainsKey("ForegroundColor")) {
        $PSBoundParameters.Remove("ForegroundColor") | Out-Null
    }
    #Set-ConsoleState @PSBoundParameters
    Write-ToConsole -ForegroundColor Green @Object -NoNewLine:$NoNewLine
}