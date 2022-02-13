using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\ICommandHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IContentModel.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IFilesystemProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockCommandHandler : ICommandHandler {
    [IContentModel] CopyModel ([IContentModel] $source) { return $null }
    [IContentModel] MergeModels ([IContentModel] $contentModelA, [IContentModel] $contentModelB) { return $null }
    [System.Array] Compare ([Object] $baseline, [Object] $comparison, [IFilesystemProvider] $filesystemProvider, [Bool] $returnSummary) { return $null }
    [System.Array] TestFilesystemHashes ([IContentModel] $contentModel, [IFilesystemProvider] $filesystemProvider, [Bool] $ReturnSummary) { return $null }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "ICommandHandler Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [ICommandHandler]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockCommandHandler]::new()
        ([ICommandHandler]$interface).CopyModel($null) | Should -Be $null
        ([ICommandHandler]$interface).MergeModels($null, $null) | Should -Be $null
        ([ICommandHandler]$interface).Compare($null, $null, $null, $null) | Should -Be $null
        ([ICommandHandler]$interface).TestFilesystemHashes($null, $null, $null) | Should -Be $null
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}