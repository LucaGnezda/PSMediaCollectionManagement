using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IContentModel.Interface.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockContentModel : IContentModel {

    [System.Collections.Generic.List[ContentSubjectBase]] $Actors
    [System.Collections.Generic.List[ContentSubjectBase]] $Albums
    [System.Collections.Generic.List[ContentSubjectBase]] $Artists
    [System.Collections.Generic.List[ContentSubjectBase]] $Series
    [System.Collections.Generic.List[ContentSubjectBase]] $Studios
    [System.Collections.Generic.List[Content]] $Content
    [String] $BuiltFromAbsolutePath
    [ContentModelConfig] $Config

    [Void] Init() { }
    [Void] Reset() { }
    [Void] Build() { }
    [Void] Build([Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] Build([String] $contentPath) { }
    [Void] Build([String] $contentPath, [Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] Rebuild() { }
    [Void] Rebuild([Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] Rebuild([String] $contentPath) { }
    [Void] Rebuild([String] $contentPath, [Bool] $loadProperties, [Bool] $generateHash) { }
    [Void] LoadIndex () { }
    [Void] LoadIndex ([Bool] $collectInfoWhereMissing) { }
    [Void] LoadIndex ([String] $indexFilePath) { }
    [Void] LoadIndex ([String] $indexFilePath, [Bool] $collectInfoWhereMissing) { }
    [Void] LoadIndex ([String] $indexFilePath, [String] $contentPath, [Bool] $collectInfoWhereMissing) { }
    [Void] SaveIndex () { }
    [Void] SaveIndex ([Bool] $CollectInfoWhereMissing) { }
    [Void] SaveIndex ([String] $indexFilePath) { }
    [Void] SaveIndex ([String] $indexFilePath, [Bool] $CollectInfoWhereMissing) { }
    [Void] SaveIndex ([String] $indexFilePath, [String] $contentPath, [Bool] $CollectInfoWhereMissing) { }
    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement) { return $null }
    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterActor ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterActor ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterActor ([String] $fromName, [String] $toName, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterAlbum ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterAlbum ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterAlbum ([String] $fromName, [String] $toName, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterArtist ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterArtist ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterArtist ([String] $fromName, [String] $toName, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterSeries ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterSeries ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterSeries ([String] $fromName, [String] $toName, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterStudio ([String] $fromName, [String] $toName) { return $null }
    [Bool] AlterStudio ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterStudio ([String] $fromName, [String] $toName, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern) { return $null }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack, [Bool] $updateCorrespondingFilename) { return $null }
    [Bool] AlterTrackFormat([Int] $padTrack, [String] $contentPath, [Bool] $updateCorrespondingFilename) { return $null }
    [Void] ApplyAllPendingFilenameChanges() { }
    [Void] ApplyAllPendingFilenameChanges([String] $contentPath) { }
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
    [Void] RemoveContentFromModel([String] $filename) { }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "IContentModel Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [IContentModel]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations 
        $interface = [MockContentModel]::new()
        ([IContentModel]$interface).RemodelFilenameFormat($null, $null)
        ([IContentModel]$interface).RemodelFilenameFormat($null, $null, $null)
        ([IContentModel]$interface).RemodelFilenameFormat($null, $null, $null, $null)
        ([IContentModel]$interface).AlterActor($null, $null)
        ([IContentModel]$interface).AlterActor($null, $null, $null)
        ([IContentModel]$interface).AlterActor($null, $null, $null, $null)
        ([IContentModel]$interface).AlterAlbum($null, $null)
        ([IContentModel]$interface).AlterAlbum($null, $null, $null)
        ([IContentModel]$interface).AlterAlbum($null, $null, $null, $null)
        ([IContentModel]$interface).AlterArtist($null, $null)
        ([IContentModel]$interface).AlterArtist($null, $null, $null)
        ([IContentModel]$interface).AlterArtist($null, $null, $null, $null)
        ([IContentModel]$interface).AlterSeries($null, $null)
        ([IContentModel]$interface).AlterSeries($null, $null, $null)
        ([IContentModel]$interface).AlterSeries($null, $null, $null, $null)
        ([IContentModel]$interface).AlterStudio($null, $null)
        ([IContentModel]$interface).AlterStudio($null, $null, $null)
        ([IContentModel]$interface).AlterStudio($null, $null, $null, $null)
        ([IContentModel]$interface).AlterSeasonEpisodeFormat($null, $null, [SeasonEpisodePattern]::Uppercase_S0E0)
        ([IContentModel]$interface).AlterSeasonEpisodeFormat($null, $null, [SeasonEpisodePattern]::Uppercase_S0E0, $null)
        ([IContentModel]$interface).AlterSeasonEpisodeFormat($null, $null, [SeasonEpisodePattern]::Uppercase_S0E0, $null, $null)
        ([IContentModel]$interface).AlterTrackFormat($null)
        ([IContentModel]$interface).AlterTrackFormat($null, $null)
        ([IContentModel]$interface).AlterTrackFormat($null, $null, $null)
        ([IContentModel]$interface).AnalyseActorsForPossibleLabellingIssues()
        ([IContentModel]$interface).AnalyseActorsForPossibleLabellingIssues($null)
        ([IContentModel]$interface).AnalyseAlbumsForPossibleLabellingIssues()
        ([IContentModel]$interface).AnalyseAlbumsForPossibleLabellingIssues($null)
        ([IContentModel]$interface).AnalyseArtistsForPossibleLabellingIssues()
        ([IContentModel]$interface).AnalyseArtistsForPossibleLabellingIssues($null)
        ([IContentModel]$interface).AnalyseSeriesForPossibleLabellingIssues()
        ([IContentModel]$interface).AnalyseSeriesForPossibleLabellingIssues($null)
        ([IContentModel]$interface).AnalyseStudiosForPossibleLabellingIssues()
        ([IContentModel]$interface).AnalyseStudiosForPossibleLabellingIssues($null)
        ([IContentModel]$interface).SpellcheckContentTitles($null)
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}