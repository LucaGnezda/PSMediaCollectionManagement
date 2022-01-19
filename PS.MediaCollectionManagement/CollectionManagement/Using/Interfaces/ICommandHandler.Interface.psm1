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
using module .\IFilesystemProvider.Interface.psm1
#endregion Using


#region Interface Definition
#-----------------------
class ICommandHandler : IsInterface {
    ICommandHandler () {
        $this.AssertAsInterface([ICommandHandler])
    }

    [IContentModel] CopyModel ([IContentModel] $source) { return $null }
    [IContentModel] MergeModels ([IContentModel] $contentModelA, [IContentModel] $contentModelB) { return $null }
    [System.Array] Compare ([Object] $baseline, [Object] $comparison, [IFilesystemProvider] $filesystemProvider, [Bool] $returnSummary) { return $null }
    [System.Array] TestFilesystemHashes ([IContentModel] $contentModel, [IFilesystemProvider] $filesystemProvider, [Bool] $ReturnSummary) { return $null }
}