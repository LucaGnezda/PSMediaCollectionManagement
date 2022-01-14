#region Header
#
# About: Pseudo Interface 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\..\..\Shared\Using\Base\IsInterface.Class.psm1
using module .\IContentModel.Interface.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IModelPersistenceHandler : IsInterface {
    IModelPersistenceHandler () {
        $this.AssertAsInterface([IModelPersistenceHandler])
    }

    [Bool] LoadConfigFromIndexFile ([String] $indexFilePath, [IContentModel] $contentModel) { return $null }
    [System.Array] RetrieveDataFromIndexFile ([String] $indexFilePath) { return $null }
    [Void] SaveToIndexFile ([String] $indexFilePath, [IContentModel] $contentModel) { }
}