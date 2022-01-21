using module .\..\Using\ModuleBehaviour\ConsoleExtensionsSettings.Static.psm1
using module .\..\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

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
        ((Get-History -count 1).Id -ne [ConsoleExtensionsState]::LastCommandIdThatWroteToConsole) -and
        ((Get-History -count 1).CommandLine -ne "@{ 'computerName' = if ([Environment]::MachineName) {[Environment]::MachineName}  else {'localhost'}; 'processId' = $PID; 'instanceId' = $host.InstanceId }") -and 
        ((Get-History -count 1).CommandLine -ne "__Invoke-ReadLineForEditorServices")){

        # Update the state and reset indents
        [ConsoleExtensionsState]::LastCommandIdThatWroteToConsole = (Get-History -count 1).Id
        Reset-ConsoleIndent
    }

    # If we're not continuing a current line, then output the appropriate indent level to console
    if ((-not $NoIndent.IsPresent) -and (-not [ConsoleExtensionsState]::ContinuingLine) -and ($Object -ne "")) {
        
        # if suppressing console output return
        if ([ConsoleExtensionsState]::RedirectToMockConsole) {
            [ConsoleExtensionsState]::MockConsoleReceiver([ConsoleExtensionsSettings]::TAB() * [ConsoleExtensionsState]::IndentLevel, $true)
        }
        else { # Otherwise write as normal
            Write-Host ([ConsoleExtensionsSettings]::TAB() * [ConsoleExtensionsState]::IndentLevel) -NoNewline
        }
    }

    # track the new line state
    if ($NoNewLine.IsPresent) {
        [ConsoleExtensionsState]::ContinuingLine = $true
    }
    else {
        [ConsoleExtensionsState]::ContinuingLine = $false
    }
}