using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Album.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Series.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true)
    $content.Title = "Foo"
    $content.FrameWidth = 100
    $content.FrameHeight = 200
    $content.BitRate = "AString"
    $content.Hash = "ABC123"
    $content.Season = 1
    $content.Episode = 1
    $content.SeasonEpisode = "01x01"
    $content.Track = 1
    $content.TrackLabel = "01"
    $content.TimeSpan = New-TimeSpan -Hours 1 -Minutes 12

    $content.Actors.Add([Actor]::new("ActorFoo"))
    $content.Actors.Add([Actor]::new("ActorFooishAct"))
    $content.Actors.Add([Actor]::new("ActorBar"))

    $content.Artists.Add([Artist]::new("ArtistFoo"))
    $content.Artists.Add([Artist]::new("ArtistFooish"))
    $content.Artists.Add([Artist]::new("ArtistBar"))

    $content.OnAlbum = [Album]::new("AlbumFoo")

    $content.FromSeries = [Series]::new("SeriesFoo")

    $content.ProducedBy = [Studio]::new("StudioFoo")
}

Describe "Content Unit Test" -Tag UnitTest {    
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()        
    }

    It "Constructing" {
        # Test
        $content.Filename | Should -Be "Foo.test"
        $content.Basename | Should -Be "Foo"
        $content.Extension | Should -Be ".test"
    }

    It "Propoerties" {
        # Test
        $content.Title | Should -Be "Foo"
        $content.FrameWidth | Should -Be 100
        $content.FrameHeight | Should -Be 200
        $content.BitRate | Should -Be  "AString"
        $content.Hash | Should -Be "ABC123"
        $content.Season | Should -Be 1
        $content.Episode | Should -Be 1
        $content.SeasonEpisode | Should -Be "01x01" 
        $content.Track | Should -Be 1
        $content.TrackLabel | Should -Be "01"
        $content.TimeSpan.TotalMilliseconds | Should -Be 4320000
        $content.Duration | Should -Be "01:12:00"
    }

    It "Duration accessor" {
        # Test
        $content.Duration | Should -Be "01:12:00"
    }

    It "Matching Actors" {
        # Test
        $content.Actors.Matching("Foo").Count | Should -Be 2
        $content.Actors.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $content.Actors.Matching("Foo")[0].Name | Should -Be "ActorFoo"
    }

    It "Sorting Actors" {        
        $content.Actors.SortedBy("Name")[0].Name | Should -Be "ActorBar"
    }

    It "FindByName Actors" {
        # Test
        $content.Actors.GetByName("ActorFoo").Name | Should -Be "ActorFoo"
        $content.Actors.GetByName("actorfoo") | Should -BeNullOrEmpty
    }

    It "Matching Artists" {
        # Test
        $content.Artists.Matching("Foo").Count | Should -Be 2
        $content.Artists.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $content.Artists.Matching("Foo")[0].Name | Should -Be "ArtistFoo"
    }

    It "Sorting Artists" {        
        $content.Artists.SortedBy("Name")[0].Name | Should -Be "ArtistBar"
    }

    It "FindByName Artists" {
        # Test
        $content.Artists.GetByName("ArtistFoo").Name | Should -Be "ArtistFoo"
        $content.Artists.GetByName("artistfoo") | Should -BeNullOrEmpty
    }

    It "Album" {
        # Test
        $content.OnAlbum.Name | Should -Be "AlbumFoo"
    }

    It "Series" {
        # Test
        $content.FromSeries.Name | Should -Be "SeriesFoo"
    }

    It "Studio" {
        # Test
        $content.ProducedBy.Name | Should -Be "StudioFoo"
    }

    It "Add Warnings" {
        # Do
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::NonCompliantFilename)

        # Test
        $content.Warnings | Should -Be @([ContentWarning]::PropertyInfoLoadingError, [ContentWarning]::NonCompliantFilename)
    }

    It "Remove Warning" {
        # Do
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::NonCompliantFilename)
        $content.ClearWarning([ContentWarning]::PropertyInfoLoadingError)

        # Test
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename)
    }

    It "Clear Warnings" {
        # Do
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::NonCompliantFilename)
        $content.ClearWarnings()

        # Test
        $content.Warnings | Should -Be @()
    }

    
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}