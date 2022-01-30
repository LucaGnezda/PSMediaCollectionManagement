using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Album.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Series.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModel.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    # Do
    $contentModel = [ContentModel]::new()
    $contentModel.Config = [ContentModelConfig]::new()
    $contentModel.Config.ConfigureForStructuredFiles(@([FilenameElement]::Actors, [FilenameElement]::Album, [FilenameElement]::Artists, [FilenameElement]::Series, [FilenameElement]::Studio))
    $contentModel.Init()

    $contentModel.Actors.Add([Actor]::new("ActorB"))
    $contentModel.Actors.Add([Actor]::new("ActorA"))

    $contentModel.Albums.Add([Album]::new("AlbumB"))
    $contentModel.Albums.Add([Album]::new("AlbumA"))

    $contentModel.Artists.Add([Artist]::new("ArtistB"))
    $contentModel.Artists.Add([Artist]::new("ArtistA"))

    $contentModel.Series.Add([Series]::new("SeriesB"))
    $contentModel.Series.Add([Series]::new("SeriesA"))

    $contentModel.Studios.Add([Studio]::new("StudioB"))
    $contentModel.Studios.Add([Studio]::new("StudioA"))

    $contentModel.Content.Add([Content]::new("ContentB.test", "ContentB", ".test", $true, $false, $false, $false, $false, $false, $false, $false, $false))
    $contentModel.Content.Add([Content]::new("ContentA.test", "ContentA", ".test", $true, $false, $false, $false, $false, $false, $false, $false, $false))

    $contentModel.Content[0].Title = "ContentB"
    $contentModel.Content[1].Title = "ContentA"

    $minContentModel = [ContentModel]::new()
    $minContentModel.Config = [ContentModelConfig]::new()
    $minContentModel.Config.ConfigureForStructuredFiles(@([FilenameElement]::Title))
    $minContentModel.Init()
}

Describe "ContentModel Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        # Test
        $contentModel | Should -Not -Be $null
    }

    It "Init" {
        # Test
        $null -eq $contentModel.Actors | Should -Be $false
        $null -eq $contentModel.Albums | Should -Be $false
        $null -eq $contentModel.Artists | Should -Be $false
        $null -eq $contentModel.Series | Should -Be $false
        $null -eq $contentModel.Studios | Should -Be $false
        $null -eq $contentModel.Content | Should -Be $false

        $null -eq $minContentModel.Actors | Should -Be $true
        $null -eq $minContentModel.Albums | Should -Be $true
        $null -eq $minContentModel.Artists | Should -Be $true
        $null -eq $minContentModel.Series | Should -Be $true
        $null -eq $minContentModel.Studios | Should -Be $true
        $null -eq $minContentModel.Content | Should -Be $false
    }

    It "Matching within Actors" { 
        # Test       
        $contentModel.Actors.Matching("Actor").Count | Should -Be 2
        $contentModel.Actors.Matching("Actor").GetType() | Should -Be "System.Object[]"
        $contentModel.Actors.Matching("Actor")[0].Name | Should -Be "ActorB"
    }

    It "Sorting Actors" {
        # Test        
        $contentModel.Actors.SortedBy("Name")[0].Name | Should -Be "ActorA"
    }

    It "FindByName Actors" {
        # Test
        $contentModel.Actors.GetByName("ActorA").Name | Should -Be "ActorA"
        $contentModel.Actors.GetByName("actora") | Should -BeNullOrEmpty
    }

    It "Matching within Albums" { 
        # Test       
        $contentModel.Albums.Matching("Album").Count | Should -Be 2
        $contentModel.Albums.Matching("Album").GetType() | Should -Be "System.Object[]"
        $contentModel.Albums.Matching("Album")[0].Name | Should -Be "AlbumB"
    }

    It "Sorting Albums" {
        # Test        
        $contentModel.Albums.SortedBy("Name")[0].Name | Should -Be "AlbumA"
    }

    It "FindByName Albums" {
        # Test
        $contentModel.Albums.GetByName("AlbumA").Name | Should -Be "AlbumA"
        $contentModel.Albums.GetByName("albuma") | Should -BeNullOrEmpty
    }

    It "Matching within Artists" { 
        # Test       
        $contentModel.Artists.Matching("Artist").Count | Should -Be 2
        $contentModel.Artists.Matching("Artist").GetType() | Should -Be "System.Object[]"
        $contentModel.Artists.Matching("Artist")[0].Name | Should -Be "ArtistB"
    }

    It "Sorting Artists" {
        # Test        
        $contentModel.Artists.SortedBy("Name")[0].Name | Should -Be "ArtistA"
    }

    It "FindByName Artists" {
        # Test
        $contentModel.Artists.GetByName("ArtistA").Name | Should -Be "ArtistA"
        $contentModel.Artists.GetByName("artista") | Should -BeNullOrEmpty
    }

    It "Matching within Series" { 
        # Test       
        $contentModel.Series.Matching("Series").Count | Should -Be 2
        $contentModel.Series.Matching("Series").GetType() | Should -Be "System.Object[]"
        $contentModel.Series.Matching("Series")[0].Name | Should -Be "SeriesB"
    }

    It "Sorting Series" {
        # Test        
        $contentModel.Series.SortedBy("Name")[0].Name | Should -Be "SeriesA"
    }

    It "FindByName Series" {
        # Test
        $contentModel.Series.GetByName("SeriesA").Name | Should -Be "SeriesA"
        $contentModel.Series.GetByName("seriesa") | Should -BeNullOrEmpty
    }

    It "Matching within Studios" { 
        # Test       
        $contentModel.Studios.Matching("Studio").Count | Should -Be 2
        $contentModel.Studios.Matching("Studio").GetType() | Should -Be "System.Object[]"
        $contentModel.Studios.Matching("Studio")[0].Name | Should -Be "StudioB"
    }

    It "Sorting Studios" {
        # Test        
        $contentModel.Studios.SortedBy("Name")[0].Name | Should -Be "StudioA"
    }

    It "FindByName Studios" {
        # Test
        $contentModel.Studios.GetByName("StudioA").Name | Should -Be "StudioA"
        $contentModel.Studios.GetByName("studioa") | Should -BeNullOrEmpty
    }

    It "Matching within Content" { 
        # Test       
        $contentModel.Content.Matching("Content").Count | Should -Be 2
        $contentModel.Content.Matching("Content").GetType() | Should -Be "System.Object[]"
        $contentModel.Content.Matching("Content")[0].BaseName | Should -Be "ContentB"
    }

    It "Sorting Content" {
        # Test        
        $contentModel.Content.SortedBy("Name")[0].BaseName | Should -Be "ContentA"
    }

    It "FindByFileName Content" {
        # Test
        $contentModel.Content.GetByFileName("ContentA.test").BaseName | Should -Be "ContentA"
        $contentModel.Content.GetByFileName("contenta.test") | Should -BeNullOrEmpty
    }

    It "Reset" {
        # Do
        $contentModel.Reset()

        # Test
        $null -eq $contentModel.Actors | Should -Be $true
        $null -eq $contentModel.Albums | Should -Be $true
        $null -eq $contentModel.Artists | Should -Be $true
        $null -eq $contentModel.Series | Should -Be $true
        $null -eq $contentModel.Studios | Should -Be $true
        $null -eq $contentModel.Content | Should -Be $true
        $contentModel.Config.IsFilenameFormatLocked | Should -Be $false
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}