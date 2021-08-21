using module .\..\Using\ModuleBehaviour\PS.MCM.ModuleSettings.Abstract.psm1
using module .\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1

function Reset-ConsoleIndent
{
    [ModuleState]::ToConsole_IndentLevel = [ModuleSettings]::TOCONSOLE_MIN_INDENT()
}