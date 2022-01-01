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
using module .\ConsoleExtensionsSettings.Abstract.psm1
#endregion Using


#region Types
#------------

#endregion Types



#region Abstract (sortof) Class Definition
#-----------------------------------------
class ConsoleExtensionsState {
    
    #region Static Properties
    # These are used by the function commands to help manage state when format console output.
    [Int] static $IndentLevel = [ConsoleExtensionsSettings]::MIN_INDENT()
    [Int] static $LastCommandIdThatWroteToConsole = (Get-History -count 1).Id
    [Bool] static $ContinuingLine = $false
    [Bool] static $RedirectToMockConsole = $false
    [System.Collections.Generic.List[String]] static $MockConsole = [System.Collections.Generic.List[String]]::new()    
    #endregion Static Properties


    #region Constructors
    ConsoleExtensionsState () {

        # Prevent instantiation of this class
        if ($this.GetType() -eq [ConsoleExtensionsState]) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        }
    } 
    #endregion Constructors


    #region Static Methods
    [Void] static MockConsoleReceiver($string, $continueLine=$false) {
        if ([ConsoleExtensionsState]::MockConsole.Count -eq 0) {
            [ConsoleExtensionsState]::ResetMockConsole()
        }
        [ConsoleExtensionsState]::MockConsole[[ConsoleExtensionsState]::MockConsole.Count - 1] = [ConsoleExtensionsState]::MockConsole[[ConsoleExtensionsState]::MockConsole.Count - 1] + $string
        if (-not $continueLine){
            [ConsoleExtensionsState]::MockConsole.Add("")
        }
    }

    [Void] static ResetMockConsole() {
        [ConsoleExtensionsState]::MockConsole.Clear()
        [ConsoleExtensionsState]::MockConsole.Add("")
    }
    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition
