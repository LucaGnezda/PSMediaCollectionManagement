using module .\..\PS.MediaContentManagement\Using\Helpers\PS.MCM.SpellcheckProvider.Abstract.psm1
using module .\..\PS.MediaContentManagement\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1

BeforeAll { 
    [ModuleState]::SetTestingState([TestAttribute]::SuppressConsoleOutput)
    [ModuleState]::SetTestingState([TestAttribute]::MockDestructiveActions)
}

Describe "Spellcheck Unit Test" -Tag UnitTest {

    It "Spellcheck" {
        # Test
        [SpellcheckProvider]::_WordInterop | Should -Be $null
        # Do
        [SpellcheckProvider]::Initialise()

        # Test
        [SpellcheckProvider]::_WordInterop | Should -BeOfType [System.MarshalByRefObject]
        [SpellcheckProvider]::CheckSpelling("Apple") | Should -Be $true
        [SpellcheckProvider]::CheckSpelling("Applee") | Should -Be $false
        [SpellcheckProvider]::GetSuggestions("Applee") | Should -Contain "Apple"

        # Do
        [SpellcheckProvider]::Dispose()

        # Test
        [SpellcheckProvider]::_WordInterop | Should -Be $null
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ModuleState]::ClearTestingStates()
}