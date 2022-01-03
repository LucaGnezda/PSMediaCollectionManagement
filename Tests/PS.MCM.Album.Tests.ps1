using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Album.Class.psm1
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

    $nullAlbum = [Album]::new()
    $fooAlbum = [Album]::new("Foo", $true)
    $fooAlbum.Tracks.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooAlbum.Tracks.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooAlbum.Tracks.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Album Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullAlbum.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooAlbum.Name | Should -Be "Foo"
    }

    It "Matching within Tracks" {        
        $fooAlbum.Tracks.Matching("Foo").Count | Should -Be 2
        $fooAlbum.Tracks.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooAlbum.Tracks.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Tracks" {        
        $fooAlbum.Tracks.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByFileName Tracks" {
        # Test
        $fooAlbum.Tracks.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $fooAlbum.Tracks.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}