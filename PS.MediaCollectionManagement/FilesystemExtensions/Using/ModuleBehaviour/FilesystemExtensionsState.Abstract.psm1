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
using module .\..\..\..\Shared\Using\Base\IsAbstract.Class.psm1
#endregion Using


#region Types
#------------
#endregion Types



#region Abstract (sortof) Class Definition
#-----------------------------------------
class FilesystemExtensionsState : IsAbstract {
      
    #region Static Properties

    # This is used by the FileMetadata functions it holds a single COM Shell object to improve performance.
    [System.MarshalByRefObject] static $Shell = $null
    [Bool] static $MockDestructiveActions = $false
    #endregion Static Properties


    #region Constructors
    FilesystemExtensionsState () {
        $this.AssertAsAbstract([FilesystemExtensionsState])
    } 
    #endregion Constructors


    #region Static Methods
    [Bool] static InstantiateShell() {
        if ($null -eq [FilesystemExtensionsState]::Shell) {
            Write-InfoToConsole "Instantiating a COM Shell"
            [FilesystemExtensionsState]::Shell = New-Object -ComObject Shell.Application
            return $true
        }
        else {
            return $false
        }
    }

    [Void] static DisposeCurrentShellIfPresent() {
        if ($null -ne [FilesystemExtensionsState]::Shell) {
            Write-InfoToConsole "Disposing COM Shell"
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject] [FilesystemExtensionsState]::Shell) | out-null
            [System.GC]::Collect()
            [System.GC]::WaitForPendingFinalizers()
            [FilesystemExtensionsState]::Shell = $null
        }
    }
    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition
