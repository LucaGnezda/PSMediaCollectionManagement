using module .\..\Module\Using\ObjectModels\PS.MCM.ContentModelConfig.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Series.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Content.Class.psm1
using module .\..\Module\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\Module\Using\Types\PS.MCM.Types.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\Module\PS.MediaContentManagement.psm1 -Force

    [ModuleState]::SetTestingState([TestAttribute]::SuppressConsoleOutput)
    [ModuleState]::SetTestingState([TestAttribute]::MockDestructiveActions)
    
    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()

    $nullSeries = [Series]::new()
    $fooSeries = [Series]::new("Foo", $true)
    $fooSeries.Episodes.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooSeries.Episodes.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooSeries.Episodes.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Series Unit Test" -Tag UnitTest {
    BeforeEach {
        [ModuleState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullSeries.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooSeries.Name | Should -Be "Foo"
    }

    It "Matching within Tracks" {        
        $fooSeries.Episodes.Matching("Foo").Count | Should -Be 2
        $fooSeries.Episodes.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooSeries.Episodes.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Tracks" {        
        $fooSeries.Episodes.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ModuleState]::ClearTestingStates()
}