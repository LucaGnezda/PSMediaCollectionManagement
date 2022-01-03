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
#endregion Using


#region Interface Definition
#-----------------------
class IModelManipulationService : IBase {
    IModelManipulationService () {
        $this.AssertAsInterface([IModelManipulationService])
    }

    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] Alter ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) { return $null }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack, [Bool] $updateCorrespondingFilename) { return $null }
}