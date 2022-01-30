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
using module .\..\..\..\Shared\Using\Base\IsStatic.Class.psm1
#endregion Using



#region Abstract (sortof) Class Definition
#-----------------------------------------
class FilesystemExtensionsSettings : IsStatic {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    FilesystemExtensionsSettings () {
        $this.AssertAsAbstract([FilesystemExtensionsSettings])
    } 
    #endregion Constructors


    #region Static Methods
    [Int] static DEFAULT_MAX_METADATA_PROPERTIES() {
        return 320
    }
    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition