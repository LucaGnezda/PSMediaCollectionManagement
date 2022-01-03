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
using module .\..\ObjectModels\Content.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IContentModel : IBase {
    IContentModel () {
        $this.AssertAsInterface([IContentModel])
    }

    [Void] Init() { }
    [Void] Reset() { }
    [Void] Build() { }
    [Void] Build([Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] Rebuild() { }
    [Void] Rebuild([Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] LoadIndex () { }
    [Void] LoadIndex ([String] $indexFilePath) { }
    [Void] LoadIndex ([Bool] $collectInfoWhereMissing) { }
    [Void] LoadIndex ([String] $indexFilePath, [Bool] $collectInfoWhereMissing) { }
    [Void] SaveIndex () { }
    [Void] SaveIndex ([String] $indexFilePath) { }
    [Void] SaveIndex ([Bool] $CollectInfoWhereMissing) { }
    [Void] SaveIndex ([String] $indexFilePath, [Bool] $CollectInfoWhereMissing) { }
    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement) { return $null }
    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterActor ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterActor ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterAlbum ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterAlbum ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterArtist ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterArtist ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterSeries ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterSeries ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterStudio ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterStudio ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern) { return $null }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack, [Bool] $updateCorrespondingFilename) { return $null }
    [Void] ApplyAllPendingFilenameChanges() { }
    [Void] Summary() { }
    [Int[]] AnalyseActorsForPossibleLabellingIssues () { return $null }
    [Int[]] AnalyseActorsForPossibleLabellingIssues ([Bool] $returnSummary) { return $null }
    [Int[]] AnalyseAlbumsForPossibleLabellingIssues () { return $null }
    [Int[]] AnalyseAlbumsForPossibleLabellingIssues ([Bool] $returnSummary) { return $null }
    [Int[]] AnalyseArtistsForPossibleLabellingIssues () { return $null }
    [Int[]] AnalyseArtistsForPossibleLabellingIssues ([Bool] $returnSummary) { return $null }
    [Int[]] AnalyseSeriesForPossibleLabellingIssues () { return $null }
    [Int[]] AnalyseSeriesForPossibleLabellingIssues ([Bool] $returnSummary) { return $null }
    [Int[]] AnalyseStudiosForPossibleLabellingIssues () { return $null }
    [Int[]] AnalyseStudiosForPossibleLabellingIssues ([Bool] $returnSummary) { return $null }
    [Void] SpellcheckContentTitles() { }
    [Hashtable] SpellcheckContentTitles([Bool] $returnResults) { return $null }
    [Content] AddContentToModel([System.IO.FileInfo] $file) { return $null }
    [Content] AddContentToModel([String] $filename, [String] $basename, [String] $extension) { return $null } 
    [Void] RemoveContentFromModel([String] $filename) { }
}
