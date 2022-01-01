using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

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
        [ConsoleExtensionsState]::ResetMockConsole()
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
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}