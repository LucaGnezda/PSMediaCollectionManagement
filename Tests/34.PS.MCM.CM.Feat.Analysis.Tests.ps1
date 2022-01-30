using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
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

        $contentModel4 = New-ContentModel
        $contentModel4.Config.ConfigureForStructuredFiles(@([FilenameElement]::Actors))
        $contentModel4.Init()

        $contentModel4.Actors.Add([Actor]::new("Foobat"))
        $contentModel4.Actors.Add([Actor]::new("Fooba"))
        $contentModel4.Actors.Add([Actor]::new("fooba"))
        $contentModel4.Actors.Add([Actor]::new("Foobar"))
        $contentModel4.Actors.Add([Actor]::new("oobar"))
        $contentModel4.Actors.Add([Actor]::new("Oobar"))
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

    It "Analyse duplicates, superstrings and near matches" {
        # Test
        $contentModel4.AnalyseActorsForPossibleLabellingIssues()
        $contentModel4.AnalyseActorsForPossibleLabellingIssues($true) | Should -Be @(0, 1, 5, 2, 4, 6)
    }

    It "Summary" {
        $contentModel1.Summary() # Nothing to test, other than it doesn't error
    }
}

Describe "ContentModel.SpellcheckContentTitles Integration Test" -Tag IntegrationTest {
    BeforeAll {
        $contentModel1 = New-ContentModel
        $contentModel1.LoadIndex("$PSScriptRoot\TestData\ContentTestG\index.test.inputA.json", $true)

        $contentModel2 = New-ContentModel
        $contentModel2.Config.ConfigureForStructuredFiles(@([FilenameElement]::Title))
        $contentModel2.Init()

        [Content] $content = [Content]::new("The cat cat.test", "The cat cat", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true)
        $content.Title = "The cat cat"
        $contentModel2.Content.Add($content)
    }

    It "Spellcheck" {
        $results = $contentModel1.SpellcheckContentTitles($true)
        $results.Count | Should -Be 9
        $results.Contains("cat") | Should -Be $true
        $results["cat"].IsCorrect | Should -Be $true
        $results.Contains("Ths") | Should -Be $true
        $results["Ths"].IsCorrect | Should -Be $false
        $results["Ths"].Suggestions | Should -Contain "This"
    }

    It "Spellcheck - repeated words, with and without return" {
        $results = $contentModel2.SpellcheckContentTitles()
        $results = $contentModel2.SpellcheckContentTitles($true)
        $results.Count | Should -Be 2
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}