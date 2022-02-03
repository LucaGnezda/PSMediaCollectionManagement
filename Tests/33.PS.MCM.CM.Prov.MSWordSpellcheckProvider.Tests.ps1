using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\MSWordCOMSpellcheckProvider.Class.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force
    
    [ConsoleExtensionsState]::RedirectToMockConsole = $true
}

Describe "Spellcheck Unit Test" -Tag UnitTest {

    It "Spellcheck" -Tag "AppveyorIgnore" {
        $spellcheckProvider = [MSWordCOMSpellcheckProvider]::New()

        $spellcheckProvider.CheckSpelling("Apple") | Should -Be $null
        
        # Test
        $spellcheckProvider._WordInterop | Should -Be $null
        # Do
        $spellcheckProvider.Initialise()

        # Test
        $spellcheckProvider._WordInterop | Should -BeOfType [System.MarshalByRefObject]
        $spellcheckProvider.CheckSpelling("Apple") | Should -Be $true
        $spellcheckProvider.CheckSpelling("Applee") | Should -Be $false
        $spellcheckProvider.GetSuggestions("Applee") | Should -Contain "Apple"

        # Do
        $spellcheckProvider.Dispose()

        # Test
        $spellcheckProvider._WordInterop | Should -Be $null
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
}