#region Header
#
# About: ModuleState class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\PS.MCM.ModuleSettings.Abstract.psm1
using module .\..\Types\PS.MCM.Types.psm1
#endregion Using


#region Types
#------------
#enum TestAttribute {
#    MockDestructiveActions = 1
#    SuppressConsoleOutput = 2
#} 
#endregion Types



#region Abstract (sortof) Class Definition
#-----------------------------------------
class ModuleState {
    
    #region Static Properties

    # This is used by the FileMetadata functions it holds a single COM Shell object to improve performance.
    [System.MarshalByRefObject] static $Shell = $null

    # These states are used by the console wrapper functions to help format console output.
    [Int] static $ToConsole_IndentLevel = [ModuleSettings]::TOCONSOLE_MIN_INDENT()
    [Int] static $ToConsole_LastCommandIdThatWroteToConsole = (Get-History -count 1).Id
    [Bool] static $ToConsole_ContinuingLine = $false

    # These states are used to improve testability. They are needed for Powershell 5 and prior, but probably redundant for future versions. 
    # The way Powershell 5 and prior loads classes and their children prevents mocking of class methods and their underlying functions. 
    [System.Collections.Generic.List[String]] static $MockConsole = [System.Collections.Generic.List[String]]::new()
    [System.Collections.Generic.List[TestAttribute]] static $Testing_States = [System.Collections.Generic.List[TestAttribute]]::new()  
    
    #endregion Static Properties


    #region Constructors
    # This class is intented to be used as an abstract class. However PowerShell cannot declare abstract classes, 
    # nor can it force disposal of a class. So there is no way to prevent this class being instantiated. 
    # That said, it will still work well enough if instantiated.
    #endregion Constructors


    #region Static Methods
    [Void] static MockConsoleReceiver($string, $continueLine=$false) {
        if ([ModuleState]::MockConsole.Count -eq 0) {
            [ModuleState]::ResetMockConsole()
        }
        [ModuleState]::MockConsole[[ModuleState]::ToConsole_RedirectedOutput.Count - 1] = [ModuleState]::MockConsole[[ModuleState]::ToConsole_RedirectedOutput.Count - 1] + $string
        if (-not $continueLine){
            [ModuleState]::MockConsole.Add("")
        }
    }

    [Void] static ResetMockConsole() {
        [ModuleState]::MockConsole.Clear()
        [ModuleState]::MockConsole.Add("")
    }

    [Void] static SetTestingState([TestAttribute] $state) {
        if ($state -notin [ModuleState]::Testing_States){
            [ModuleState]::Testing_States.Add($state)
        }
    }

    [Void] static ClearTestingStates() {
        [ModuleState]::Testing_States.Clear()
    }

    [Void] static InstantiateShell() {
        Write-InfoToConsole "Instantiating a COM Shell"
        [ModuleState]::Shell = New-Object -ComObject Shell.Application
    }

    [Void] static DisposeCurrentShellIfPresent() {
        if ($null -ne [ModuleState]::Shell) {
            Write-InfoToConsole "Disposing COM Shell"
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject] [ModuleState]::Shell) | out-null
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
        }
    }
    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition
