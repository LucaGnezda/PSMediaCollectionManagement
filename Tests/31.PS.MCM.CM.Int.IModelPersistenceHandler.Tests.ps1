using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IModelPersistenceHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IContentModel.Interface.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockModelPersistenceHandler : IModelPersistenceHandler {
    [Bool] LoadConfigFromIndexFile ([String] $indexFilePath, [IContentModel] $contentModel) { return $null }
    [System.Array] RetrieveDataFromIndexFile ([String] $indexFilePath) { return $null }
    [Void] SaveToIndexFile ([String] $indexFilePath, [IContentModel] $contentModel) { }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "IModelPersistenceHandler Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [IModelPersistenceHandler]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockModelPersistenceHandler]::new()
        ([IModelPersistenceHandler]$interface).LoadConfigFromIndexFile($null, $null) | Should -Be $false
        ([IModelPersistenceHandler]$interface).RetrieveDataFromIndexFile($null) | Should -Be $null
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}