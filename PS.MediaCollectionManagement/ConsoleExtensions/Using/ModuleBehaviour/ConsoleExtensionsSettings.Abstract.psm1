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
#endregion Using



#region Abstract (sortof) Class Definition
#-----------------------------------------
class ConsoleExtensionsSettings {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    ConsoleExtensionsSettings () {

        # Prevent instantiation of this class
        if ($this.GetType() -eq [ConsoleExtensionsSettings]) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        }
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