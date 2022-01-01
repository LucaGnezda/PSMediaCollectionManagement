using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\LevenshteinStringSimilarityProvider.Class.psm1

BeforeAll { 
    $stringSimilarityProvider = [LevenshteinStringSimilarityProvider]::new()
}

Describe "StringSimilarityProvider Unit Test" -Tag UnitTest {

    It "Test Similarity" {
        # Do + Test
        $stringSimilarityProvider.GetRawDistanceBetween("Foo","Bar") | Should -Be 3
        $stringSimilarityProvider.GetNormalisedDistanceBetween("Foo","Bar") | Should -Be 1
        $stringSimilarityProvider.GetRawDistanceBetween("For","Bar", $true) | Should -Be 2
        $stringSimilarityProvider.GetRawDistanceBetween("FoR","Bar", $true) | Should -Be 3
        [Math]::Round($stringSimilarityProvider.GetNormalisedDistanceBetween("For","Bar", $true),3) | Should -Be 0.667
        $stringSimilarityProvider.GetNormalisedDistanceBetween("FoR","Bar", $true) | Should -Be 1
    }
}

AfterAll {
    Set-Location $PSScriptRoot
}