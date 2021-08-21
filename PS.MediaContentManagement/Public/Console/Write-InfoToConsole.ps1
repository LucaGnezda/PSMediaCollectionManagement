function Write-InfoToConsole (
    [Parameter(Mandatory=$false, ParameterSetName="WithColor")]
    [Parameter(Mandatory=$false, ParameterSetName="WithoutColor")]
    [Switch] $NoNewLine,    

    [Parameter(Mandatory=$true, ParameterSetName="WithColor")]
    [System.ConsoleColor] $ForegroundColor,

    [Parameter(Mandatory=$false, ValueFromRemainingArguments, ParameterSetName="WithColor")]
    [Parameter(Mandatory=$false, ValueFromRemainingArguments, ParameterSetName="WithoutColor")]
    [System.Collections.Generic.List[Object]]
    $Object=""
)
{
    # Remove Foreground color if supplied
    if ($PSBoundParameters.ContainsKey("ForegroundColor")) {
        $PSBoundParameters.Remove("ForegroundColor") | Out-Null
    }
    #Set-ConsoleState @PSBoundParameters
    Write-ToConsole -ForegroundColor Gray @Object -NoNewLine:$NoNewLine
}