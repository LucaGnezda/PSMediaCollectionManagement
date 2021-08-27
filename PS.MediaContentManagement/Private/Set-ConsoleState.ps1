using module .\..\Using\ModuleBehaviour\PS.MCM.ModuleSettings.Abstract.psm1
using module .\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\Using\Types\PS.MCM.Types.psm1

function Set-ConsoleState (

    [Parameter(Mandatory=$false)]
    [Switch] $NoNewLine,

    [Parameter(Mandatory=$false)]
    [Switch] $NoIndent,

    [Parameter(Mandatory=$false)]
    [System.ConsoleColor] $ForegroundColor,

    [Parameter(Mandatory=$false, ValueFromRemainingArguments)]
    [System.Collections.Generic.List[Object]]
    $Object=""
) {    
    # If the command is not null (Pester and similar behaviour), we are processing a new command line, and it's not a known background debugger command
    if ((-not [String]::IsNullOrEmpty((Get-History -count 1).CommandLine)) -and 
        ((Get-History -count 1).Id -ne [ModuleState]::ToConsole_LastCommandIdThatWroteToConsole) -and
        ((Get-History -count 1).CommandLine -ne "@{ 'computerName' = if ([Environment]::MachineName) {[Environment]::MachineName}  else {'localhost'}; 'processId' = $PID; 'instanceId' = $host.InstanceId }") -and 
        ((Get-History -count 1).CommandLine -ne "__Invoke-ReadLineForEditorServices")){

        # Update the state and reset indents
        [ModuleState]::ToConsole_LastCommandIdThatWroteToConsole = (Get-History -count 1).Id
        Reset-ConsoleIndent
    }

    # If we're not continuing a current line, then write an indent to console
    if ((-not $NoIndent.IsPresent) -and (-not [ModuleState]::ToConsole_ContinuingLine) -and ($Object -ne "")) {
        
        # if suppressing console output return
        if ([TestAttribute]::SuppressConsoleOutput -in [ModuleState]::Testing_States) {
            [ModuleState]::MockConsoleReceiver([ModuleSettings]::TOCONSOLE_TAB() * [ModuleState]::ToConsole_IndentLevel, $true)
        }
        else { # Otherwise write as normal
            Write-Host ([ModuleSettings]::TOCONSOLE_TAB() * [ModuleState]::ToConsole_IndentLevel) -NoNewline
        }
    }

    # track the new line state
    if ($NoNewLine.IsPresent) {
        [ModuleState]::ToConsole_ContinuingLine = $true
    }
    else {
        [ModuleState]::ToConsole_ContinuingLine = $false
    }
}