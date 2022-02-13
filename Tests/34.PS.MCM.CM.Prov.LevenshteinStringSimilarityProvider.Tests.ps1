using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\LevenshteinStringSimilarityProvider.Class.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force
    
    [ConsoleExtensionsState]::RedirectToMockConsole = $true
}

Describe "StringSimilarityProvider Unit Test" -Tag UnitTest {

    It "Test Similarity" {
        # Do
        $stringSimilarityProvider = [LevenshteinStringSimilarityProvider]::new()

        # Test
        $stringSimilarityProvider.GetRawDistanceBetween("Foo","Bar") | Should -Be 3
        $stringSimilarityProvider.GetNormalisedDistanceBetween("Foo","Bar") | Should -Be 1
        $stringSimilarityProvider.GetRawDistanceBetween("For","Bar", $true) | Should -Be 2
        $stringSimilarityProvider.GetRawDistanceBetween("FoR","Bar", $true) | Should -Be 3
        [Math]::Round($stringSimilarityProvider.GetNormalisedDistanceBetween("For","Bar", $true),3) | Should -Be 0.667
        $stringSimilarityProvider.GetNormalisedDistanceBetween("FoR","Bar", $true) | Should -Be 1
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
}