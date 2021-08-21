using module .\..\..\Using\ModuleBehaviour\PS.MCM.ModuleSettings.Abstract.psm1
using module .\..\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1

function Remove-ConsoleIndent
{
    [ModuleState]::ToConsole_IndentLevel = [Math]::Max([ModuleState]::ToConsole_IndentLevel - 1, [ModuleSettings]::TOCONSOLE_MIN_INDENT())
}