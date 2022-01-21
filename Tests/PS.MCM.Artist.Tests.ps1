using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ContentBO.Class.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()
    $config.LockFilenameFormat()

    $contentBO = [ContentBO]::new($config)

    $nullArtist = [Artist]::new()
    $fooArtist = [Artist]::new("Foo")

    $fooArtist.Performed.Add($contentBO.CreateContentObject("Foo.test", "Foo", ".test"))
    $fooArtist.Performed.Add($contentBO.CreateContentObject("Fooish.test", "Fooish", ".test"))
    $fooArtist.Performed.Add($contentBO.CreateContentObject("Bar.test", "Bar", ".test"))
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

    It "FindByFileName Performed" {
        # Test
        $fooArtist.Performed.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $fooArtist.Performed.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}