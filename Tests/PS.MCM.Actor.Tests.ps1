using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ContentBO.Class.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()
    $config.LockFilenameFormat()

    $contentBO = [ContentBO]::new($config)

    $nullActor = [Actor]::new()
    $fooActor = [Actor]::new("Foo")

    $fooActor.PerformedIn.Add($contentBO.CreateContentObject("Foo.test", "Foo", ".test"))
    $fooActor.PerformedIn.Add($contentBO.CreateContentObject("Fooish.test", "Fooish", ".test"))
    $fooActor.PerformedIn.Add($contentBO.CreateContentObject("Bar.test", "Bar", ".test"))
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

    It "Sorting PerformedIn" {        
        $fooActor.PerformedIn.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByFileName PerformedIn" {
        # Test
        $fooActor.PerformedIn.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $fooActor.PerformedIn.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}