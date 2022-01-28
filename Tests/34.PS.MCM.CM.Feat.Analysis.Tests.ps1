using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
    
}

Describe "ContentModel.Analyse(Subject) Integration Test" -Tag IntegrationTest {
    BeforeAll {
        $contentModel1 = New-ContentModel
        $contentModel1.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        $contentModel2 = New-ContentModel
        $contentModel2.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputC.json", $true)

        $contentModel3 = New-ContentModel
        $contentModel3.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)
    }

    It "Analyse Actors" {
        # Test
        $contentModel1.AnalyseActorsForPossibleLabellingIssues()
        $contentModel1.AnalyseActorsForPossibleLabellingIssues($true) | Should -Be @(6, 0, 0, 0, 0, 6)
    }

    It "Analyse Albums" {
        # Test
        $contentModel3.AnalyseAlbumsForPossibleLabellingIssues()
        $contentModel3.AnalyseAlbumsForPossibleLabellingIssues($true) | Should -Be @(2, 0, 0, 0, 0, 2)
    }

    It "Analyse Artists" {
        # Test
        $contentModel3.AnalyseArtistsForPossibleLabellingIssues()
        $contentModel3.AnalyseArtistsForPossibleLabellingIssues($true) | Should -Be @(6, 0, 0, 0, 0, 6)
    }

    It "Analyse Series" {
        # Test
        $contentModel2.AnalyseSeriesForPossibleLabellingIssues() 
        $contentModel2.AnalyseSeriesForPossibleLabellingIssues($true) | Should -Be @(2, 0, 0, 0, 0, 2)
    }

    It "Analyse Studios" {
        # Test
        $contentModel1.AnalyseStudiosForPossibleLabellingIssues()
        $contentModel1.AnalyseStudiosForPossibleLabellingIssues($true) | Should -Be @(2, 0, 0, 0, 0, 2)
    }

    It "Summary" {
        $contentModel1.Summary() # Nothing to test, other than it doesn't error
    }
}

Describe "ContentModel.SpellcheckContentTitles Integration Test" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestG\index.test.inputA.json", $true)
    }

    It "Spellcheck" {
        $results = $contentModel.SpellcheckContentTitles($true)
        $results.Count | Should -Be 9
        $results.Contains("cat") | Should -Be $true
        $results["cat"].IsCorrect | Should -Be $true
        $results.Contains("Ths") | Should -Be $true
        $results["Ths"].IsCorrect | Should -Be $false
        $results["Ths"].Suggestions | Should -Contain "This"
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}