#region Header
#
# About: FileMetadataProperty class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
#endregion Using


#region Class Definition
#-----------------------
class FileMetadataProperty {
    
    #region Properties
    [Int]    $Index
    [String] $Property
    [String] $Value

    #endregion Properties


    #region Constructors
    FileMetadataProperty([Int] $index, [String] $property, [String] $value) {
        $this.Index = $index
        $this.Property = $property
        $this.Value = $value
    }

    #endregion Constructors


    #region Methods
    #endregion Methods
}

#endregion Class Definition