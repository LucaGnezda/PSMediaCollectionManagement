using module .\..\Module\Using\ObjectModels\PS.MCM.ContentModelConfig.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Actor.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Content.Class.psm1
using module .\..\Module\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\Module\Using\Types\PS.MCM.Types.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\Module\PS.MediaContentManagement.psm1 -Force

    [ModuleState]::SetTestingState([TestAttribute]::SuppressConsoleOutput)
    [ModuleState]::SetTestingState([TestAttribute]::MockDestructiveActions)

    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()

    $nullActor = [Actor]::new()
    $fooActor = [Actor]::new("Foo")
    $fooActor.PerformedIn.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooActor.PerformedIn.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooActor.PerformedIn.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Actor Unit Test" -Tag UnitTest {
    BeforeEach {
        [ModuleState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullActor.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooActor.Name | Should -Be "Foo"
    }

    It "Matching within PerformedIn" {        
        $fooActor.PerformedIn.Matching("Foo").Count | Should -Be 2
        $fooActor.PerformedIn.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooActor.PerformedIn.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Produced" {        
        $fooActor.PerformedIn.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ModuleState]::ClearTestingStates()
}