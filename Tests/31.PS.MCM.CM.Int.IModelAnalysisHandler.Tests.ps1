using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IModelAnalysisHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IStringSimilarityProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\ISpellcheckProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockModelAnalysisHandler : IModelAnalysisHandler {
    
    [IStringSimilarityProvider] $StringSimilarityProvider
    [ISpellcheckProvider] $SpellcheckProvider

    [Void] SetStringSimilarityProvider([IStringSimilarityProvider] $provider) { }
    [Void] SetSpellcheckProvider([ISpellcheckProvider] $provider) { }
    [Void] Static ModelSummary() { }
    [Int[]] AnalysePossibleLabellingIssues ([System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [Bool] $returnSummary) { return $null }
    [Hashtable] SpellcheckContentTitles([System.Collections.Generic.List[Object]] $contentList, [Bool] $returnResults) { return $null }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "IModelAnalysisHandler Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [IModelAnalysisHandler]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockModelAnalysisHandler]::new()
        ([IModelAnalysisHandler]$interface).AnalysePossibleLabellingIssues($null, $null) | Should -Be $null
        ([IModelAnalysisHandler]$interface).SpellcheckContentTitles($null, $null) | Should -Be $null
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}