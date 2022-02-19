using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\ISpellcheckProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockSpellcheckProvider : ISpellcheckProvider {
    [Bool] Initialise () { return $null }
    [System.Nullable[Bool]] CheckSpelling ([String] $word) { return $null }
    [System.Collections.Generic.List[String]] GetSuggestions ([String] $word) { return $null }
    [Void] Dispose () { }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "ISpellcheckProvider Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [ISpellcheckProvider]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockSpellcheckProvider]::new()
        ([ISpellcheckProvider]$interface).Initialise() | Should -Be $false
        ([ISpellcheckProvider]$interface).CheckSpelling($null) | Should -Be $null
        ([ISpellcheckProvider]$interface).GetSuggestions($null) | Should -Be $null
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}