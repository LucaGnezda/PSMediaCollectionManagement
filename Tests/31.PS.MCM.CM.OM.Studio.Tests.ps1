using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Album.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Series.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
    
    $validStudio = [Studio]::new("Foo", $true, $true)

    $validStudio.Produced.Add([Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validStudio.Produced.Add([Content]::new("Fooish.test", "Fooish", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validStudio.Produced.Add([Content]::new("Bar.test", "Bar", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))

    $validStudio.Produced[0].Title = "Foo"
    $validStudio.Produced[1].Title = "Fooish"
    $validStudio.Produced[2].Title = "Bar"

    $validStudio.ProducedAlbums.Add([Album]::new("AlbumFoo"))
    $validStudio.ProducedAlbums.Add([Album]::new("AlbumFooish"))
    $validStudio.ProducedAlbums.Add([Album]::new("AlbumBar"))

    $validStudio.ProducedSeries.Add([Series]::new("SeriesFoo"))
    $validStudio.ProducedSeries.Add([Series]::new("SeriesFooish"))
    $validStudio.ProducedSeries.Add([Series]::new("SeriesBar"))
}

Describe "Studio Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        # Do
        $nullStudio = [Studio]::new()

        # Test
        $nullStudio.Name | Should -Be ""
    }

    It "Constructing with single parameters" {
        # Do
        $minStudio = [Studio]::new("Foo")

        # Test
        $minStudio.Name | Should -Be "Foo"
        $minStudio.ProducedAlbums | Should -Be $null
        $minStudio.ProducedSeries | Should -Be $null
    }

    It "Constructing with all parameters" {
        $validStudio.Name | Should -Be "Foo"
    }

    It "Matching within Produced" {        
        $validStudio.Produced.Matching("Foo").Count | Should -Be 2
        $validStudio.Produced.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $validStudio.Produced.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Produced" {        
        $validStudio.Produced.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByName Produced" {
        # Test
        $validStudio.Produced.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $validStudio.Produced.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }

    It "Matching within ProducedAlbums" {        
        $validStudio.ProducedAlbums.Matching("Foo").Count | Should -Be 2
        $validStudio.ProducedAlbums.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $validStudio.ProducedAlbums.Matching("Foo")[0].Name | Should -Be "AlbumFoo"
    }

    It "Sorting ProducedAlbums" {        
        $validStudio.ProducedAlbums.SortedBy("Name")[0].Name | Should -Be "AlbumBar"
    }

    It "FindByName ProducedAlbums" {
        # Test
        $validStudio.ProducedAlbums.GetByName("AlbumFooish").Name | Should -Be "AlbumFooish"
        $validStudio.ProducedAlbums.GetByName("albumfooish") | Should -BeNullOrEmpty
    }

    It "Matching within ProducedSeries" {        
        $validStudio.ProducedSeries.Matching("Foo").Count | Should -Be 2
        $validStudio.ProducedSeries.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $validStudio.ProducedSeries.Matching("Foo")[0].Name | Should -Be "SeriesFoo"
    }

    It "Sorting ProducedSeries" {        
        $validStudio.ProducedSeries.SortedBy("Name")[0].Name | Should -Be "SeriesBar"
    }

    It "FindByFileName ProducedSeries" {
        # Test
        $validStudio.ProducedSeries.GetByName("SeriesFooish").Name | Should -Be "SeriesFooish"
        $validStudio.ProducedSeries.GetByName("seriesfooish") | Should -BeNullOrEmpty
    }

    It "ProductionCount" {
        # Test
        $validStudio.ProductionCount | Should -Be 6
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}