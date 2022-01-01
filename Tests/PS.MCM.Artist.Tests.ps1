using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
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

    $nullArtist = [Artist]::new()
    $fooArtist = [Artist]::new("Foo")
    $fooArtist.Performed.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooArtist.Performed.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooArtist.Performed.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Artist Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullArtist.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooArtist.Name | Should -Be "Foo"
    }

    It "Matching within Performed" {        
        $fooArtist.Performed.Matching("Foo").Count | Should -Be 2
        $fooArtist.Performed.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooArtist.Performed.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Performed" {        
        $fooArtist.Performed.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}