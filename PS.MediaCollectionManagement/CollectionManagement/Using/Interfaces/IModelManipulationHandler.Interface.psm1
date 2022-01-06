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
using module .\IBase.Interface.psm1
using module .\IContentSubjectBO.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IModelManipulationHandler : IBase {
    IModelManipulationHandler () {
        $this.AssertAsInterface([IModelManipulationHandler])
    }

    [Void] SetContentSubjectBO([IContentSubjectBO] $contentSubjectBO) { }
    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] Alter ([System.Collections.Generic.List[Object]] $subjectList, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) { return $null }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack, [Bool] $updateCorrespondingFilename) { return $null }
}