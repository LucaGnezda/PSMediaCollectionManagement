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
class FilesystemExtensionsSettings {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    FilesystemExtensionsSettings () {

        # Prevent instantiation of this class
        if ($this.GetType() -eq [FilesystemExtensionsSettings]) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        }
    } 
    #endregion Constructors


    #region Static Methods
    [Int] static DEFAULT_MAX_METADATA_PROPERTIES() {
        return 320
    }
    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition