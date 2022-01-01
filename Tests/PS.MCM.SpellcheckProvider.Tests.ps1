using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\MSWordCOMSpellcheckProvider.Class.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1

BeforeAll { 
    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    $spellcheckProvider = [MSWordCOMSpellcheckProvider]::New()
}

Describe "Spellcheck Unit Test" -Tag UnitTest {

    It "Spellcheck" {
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
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
}