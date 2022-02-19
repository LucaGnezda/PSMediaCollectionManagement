using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IModelManipulationHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IContentModel.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IFilesystemProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IContentSubjectBO.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockModelManipulationHandler : IModelManipulationHandler {
    
    [IContentModel] $ContentModel

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


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "IModelManipulationHandler Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [IModelManipulationHandler]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockModelManipulationHandler]::new()
        ([IModelManipulationHandler]$interface).RemodelFilenameFormat($null, $null) | Should -Be $false
        ([IModelManipulationHandler]$interface).AlterSeasonEpisodeFormat($null, $null, [SeasonEpisodePattern]::Uppercase_S0E0) | Should -Be $false
        ([IModelManipulationHandler]$interface).AlterTrackFormat($null) | Should -Be $false
        ([IModelManipulationHandler]$interface).AlterSubject($null, $null, $null, $null) | Should -Be $false
        ([IModelManipulationHandler]$interface).AddContentToModel($null, $null, $null, $null) | Should -Be $null
    }

}