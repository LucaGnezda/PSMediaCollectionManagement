using module .\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1

function Add-ConsoleIndent
{
    [ModuleState]::ToConsole_LastCommandIdThatWroteToConsole = (Get-History -count 1).Id
    [ModuleState]::ToConsole_IndentLevel++
}