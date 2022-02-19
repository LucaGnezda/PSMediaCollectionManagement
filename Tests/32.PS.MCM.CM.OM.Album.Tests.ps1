using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Album.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $validAlbum = [Album]::new("Foo", $true)

    $validAlbum.Tracks.Add([Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validAlbum.Tracks.Add([Content]::new("Fooish.test", "Fooish", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validAlbum.Tracks.Add([Content]::new("Bar.test", "Bar", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))

    $validAlbum.Tracks[0].Title = "Foo"
    $validAlbum.Tracks[1].Title = "Fooish"
    $validAlbum.Tracks[2].Title = "Bar"

    $validAlbum.ProducedBy.Add([Studio]::new("Foomaker", $false, $false))
    $validAlbum.ProducedBy.Add([Studio]::new("Barmaker", $false, $false))
}

Describe "Album Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        # Do
        $nullAlbum = [Album]::new()

        # Test
        $nullAlbum.Name | Should -Be ""
    }

    It "Constructing with single parameters" {
        # Do
        $minAlbum = [Album]::new("Foo")

        # Test
        $minAlbum.Name | Should -Be "Foo"
        $minAlbum.ProducedBy | Should -Be $null
    }

    It "Constructing with all parameters" {
        # Test
        $validAlbum.Name | Should -Be "Foo"
    }

    It "Matching within Tracks" {    
        # Test    
        $validAlbum.Tracks.Matching("Foo").Count | Should -Be 2
        $validAlbum.Tracks.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $validAlbum.Tracks.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Tracks" {  
        # Test      
        $validAlbum.Tracks.SortedBy("Title")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByFileName Tracks" {
        # Test
        $validAlbum.Tracks.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $validAlbum.Tracks.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }

    It "Matching within ProducedBy" {    
        # Test    
        $validAlbum.ProducedBy.Matching("Foo").Count | Should -Be 1
        $validAlbum.ProducedBy.Matching("Foo").GetType() | Should -Be "Studio"
        $validAlbum.ProducedBy.Matching("Foo")[0].Name | Should -Be "Foomaker"
    }

    It "Sorting ProducedBy" {  
        # Test      
        $validAlbum.ProducedBy.SortedBy("Name")[0].Name | Should -Be "Barmaker"
    }

    It "FindByName ProducedBy" {
        # Test
        $validAlbum.ProducedBy.GetByName("Barmaker").Name | Should -Be "Barmaker"
        $validAlbum.ProducedBy.GetByName("barmaker") | Should -BeNullOrEmpty
    }

    It "TrackCount" {
        # Test
        $validAlbum.TrackCount | Should -Be 3
    }

    It "ProducedBy" {
        # Test
        $validAlbum.ProducedBy.Name | Should -Be @("Foomaker", "Barmaker")
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}