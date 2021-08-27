using module .\..\PS.MediaContentManagement\Using\ObjectModels\PS.MCM.ContentModelConfig.Class.psm1
using module .\..\PS.MediaContentManagement\Using\ObjectModels\PS.MCM.Studio.Class.psm1
using module .\..\PS.MediaContentManagement\Using\ObjectModels\PS.MCM.Content.Class.psm1
using module .\..\PS.MediaContentManagement\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\PS.MediaContentManagement\Using\Types\PS.MCM.Types.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaContentManagement\PS.MediaContentManagement.psm1 -Force

    [ModuleState]::SetTestingState([TestAttribute]::SuppressConsoleOutput)
    [ModuleState]::SetTestingState([TestAttribute]::MockDestructiveActions)
    
    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()

    $nullStudio = [Studio]::new()
    $fooStudio = [Studio]::new("Foo", $true, $true)
    $fooStudio.Produced.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooStudio.Produced.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooStudio.Produced.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Studio Unit Test" -Tag UnitTest {
    BeforeEach {
        [ModuleState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullStudio.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooStudio.Name | Should -Be "Foo"
    }

    It "Matching within Produced" {        
        $fooStudio.Produced.Matching("Foo").Count | Should -Be 2
        $fooStudio.Produced.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooStudio.Produced.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Produced" {        
        $fooStudio.Produced.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ModuleState]::ClearTestingStates()
}