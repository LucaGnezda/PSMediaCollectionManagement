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
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IModelManipulationHandler : IsInterface {
    IModelManipulationHandler () {
        $this.AssertAsInterface([IModelManipulationHandler])
    }

    [Bool] RemodelFilenameFormat([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { return $null }
    [Void] ApplyAllPendingFilenameChanges() { }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterSubject([IContentSubjectBO] $contentSubjectBO, [System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Content] AddContentToModel([String] $filename, [String] $basename, [String] $extension, [Object] $indexInfoIfAvailable) { return $null }
    [Void] Build([Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] Rebuild([Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] Load([System.Array] $infoFromIndexFile, [Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] FillPropertiesAndHashWhereMissing ([Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] RemoveContentFromModel([String] $filename) { }
}