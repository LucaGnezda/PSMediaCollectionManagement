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
using module .\..\Types\Types.psm1
using module .\..\..\..\Shared\Using\Base\IsInterface.Class.psm1
using module .\IContentSubjectBO.Interface.psm1
using module .\IContentModel.Interface.psm1
using module .\IFilesystemProvider.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IModelManipulationHandler : IsInterface {
    
    [IContentModel] $ContentModel
    
    IModelManipulationHandler () {
        $this.AssertAsInterface([IModelManipulationHandler])
    }

    [Bool] RemodelFilenameFormat([Int] $swapElement, [Int] $withElement) { return $null }
    [Void] ApplyAllPendingFilenameChanges([IFilesystemProvider] $filesystemProvider) { }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack) { return $null }
    [Bool] AlterSubject([IContentSubjectBO] $contentSubjectBO, [System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [String] $fromName, [String] $toName) { return $null }
    [Content] AddContentToModel([String] $filename, [String] $basename, [String] $extension, [Object] $indexInfoIfAvailable) { return $null }
    [Void] Build([Bool] $loadProperties, [Bool] $generateHash, [IFilesystemProvider] $filesystemProvider ) { }
    [Void] Rebuild([Bool] $loadProperties, [Bool] $generateHash, [IFilesystemProvider] $filesystemProvider) { }
    [Void] Load([System.Array] $infoFromIndexFile, [Bool] $loadProperties, [Bool] $generateHash, [IFilesystemProvider] $filesystemProvider) { }
    [Void] FillPropertiesAndHashWhereMissing ([Bool] $loadProperties, [Bool] $generateHash, [IFilesystemProvider] $filesystemProvider) { }
    [Void] RemoveContentFromModel([String] $filename) { }
    [Void] IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename) { }
    [Void] IfRequiredProvideConsoleTipsForLoadWarnings() { }
}