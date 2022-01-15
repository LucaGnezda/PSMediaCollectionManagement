#region Header
#
# About: ModuleSettings class for PS.MediaCollectionManagement Module 
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



#region Abstract (sortof) Class Definition
#-----------------------------------------
class ConsoleExtensionsSettings : IsAbstract {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    ConsoleExtensionsSettings () {
        $this.AssertAsAbstract([ConsoleExtensionsSettings])
    } 
    #endregion Constructors


    #region Static Methods
    [Int] static MIN_INDENT() {
        return 1
    }

    [String] static TAB() {
        return "  "
    }
    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition