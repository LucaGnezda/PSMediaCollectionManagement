using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\AlbumBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Album.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Series.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $config = [ContentModelConfig]::new()
    $config.ConfigureForStructuredFiles(@([FilenameElement]::Album, [FilenameElement]::Studio))
    $config.LockFilenameFormat()
}

Describe "AlbumBO Unit Test" -Tag UnitTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Constructing" {
        # Test
        {$albumBO = [AlbumBO]::new($config); $albumBO} | Should -Not -Throw

        # Do
        $invalidConfig = [ContentModelConfig]::new()
        $invalidConfig.ConfigureForStructuredFiles(@([FilenameElement]::Album, [FilenameElement]::Studio))

        # Test
        {$albumBO = [AlbumBO]::new($invalidConfig); $albumBO} | Should -Throw
    }

    It "ActsOnType" {
        # Do
        $albumBO = [AlbumBO]::new($config)

        # Test
        $albumBO.ActsOnType().Name | Should -Be "Album"
    }

    It "ActsOnFilenameElement" {
        # Do
        $albumBO = [AlbumBO]::new($config)

        # Test
        $albumBO.ActsOnFilenameElement() -eq [FilenameElement]::Album | Should -Be $true
    }

    It "ReplaceSubjectLinkedToContent" {
        # Do
        $albumBO = [AlbumBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)
        $content.OnAlbum = [Album]::new("Apple", $true)
        $content.ProducedBy = [Studio]::new("Banana", $true, $true)
        $content.OnAlbum.ProducedBy.Add($content.ProducedBy)
        $content.OnAlbum.Tracks.Add($content)
        $content.ProducedBy.ProducedAlbums.Add($content.OnAlbum)
        $content.ProducedBy.Produced.Add($content)

        $replacementAlbum = [Album]::new("Date", $true)

        $incorrectType = [Series]::new("Kiwi")

        # Do
        $albumBO.ReplaceSubjectLinkedToContent($content, $content.OnAlbum, $incorrectType)

        # Test
        $content.OnAlbum.Name | Should -Be "Apple"

        # Do
        $albumBO.ReplaceSubjectLinkedToContent($content, $content.OnAlbum, $replacementAlbum)

        # Test
        $content.OnAlbum.Name | Should -Be "Date"
    }

    It "ReplaceAlbumLinkedWithContent" {
        # Do
        $albumBO = [AlbumBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)
        $content.OnAlbum = [Album]::new("Apple", $true)
        $content.ProducedBy = [Studio]::new("Banana", $true, $true)
        $content.OnAlbum.ProducedBy.Add($content.ProducedBy)
        $content.OnAlbum.Tracks.Add($content)
        $content.ProducedBy.ProducedAlbums.Add($content.OnAlbum)
        $content.ProducedBy.Produced.Add($content)

        $replacementAlbum = [Album]::new("Date", $true)

        # Do
        $albumBO.ReplaceAlbumLinkedWithContent($content, $replacementAlbum)

        # Test
        $content.OnAlbum.Name | Should -Be "Date"
    }

    It "ModifyCrossLinksBetweenAlbumAndStudio" {
        # Do
        $albumBO = [AlbumBO]::new($config)

        $replaceAlbum = [Album]::new("Apple", $true)
        $withAlbum = [Album]::new("Cherry", $true)
        $studio = [Studio]::new("Banana", $true, $true)
        $replaceAlbum.ProducedBy.Add($studio)
        $withAlbum.ProducedBy.Add($studio)
        $studio.ProducedAlbums.Add($replaceAlbum)
        $studio.ProducedAlbums.Add($withAlbum)

        # Test
        $albumBO.ModifyCrossLinksBetweenAlbumAndStudio($replaceAlbum, $withAlbum)

        # Do
        $replaceAlbum = [Album]::new("Apple", $true)
        $withAlbum = [Album]::new("Cherry", $true)
        $studio1 = [Studio]::new("Banana", $true, $true)
        $studio2 = [Studio]::new("Date", $true, $true)
        $replaceAlbum.ProducedBy.Add($studio1)
        $withAlbum.ProducedBy.Add($studio2)
        $studio1.ProducedAlbums.Add($replaceAlbum)
        $studio2.ProducedAlbums.Add($withAlbum)

        # Test
        $albumBO.ModifyCrossLinksBetweenAlbumAndStudio($replaceAlbum, $withAlbum)

    }

    It "AddAlbumRelationshipsWithContent" {
        # Do
        $albumBO = [AlbumBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $albumList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)
        [Content] $content3 = [Content]::new("Content3.test", "Content3", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)
        [Content] $content4 = [Content]::new("Content4.test", "Content4", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)
    
        # Do
        $albumBO.AddAlbumRelationshipsWithContent($content1, $albumList, "Apple")

        # Test
        $albumList.Count | Should -Be 1
        $albumList[0].Name | Should -Be "Apple"
        $albumList[0].Tracks.Count | Should -Be 1
        $albumList[0].Tracks[0].BaseName | Should -Be "Content1"
        $content1.OnAlbum.Name | Should -Be "Apple"

        # Do
        $albumBO.AddAlbumRelationshipsWithContent($content2, $albumList, "Apple")

        # Test
        $albumList.Count | Should -Be 1
        $albumList[0].Name | Should -Be "Apple"
        $albumList[0].Tracks.Count | Should -Be 2
        $albumList[0].Tracks[0].BaseName | Should -Be "Content1"
        $albumList[0].Tracks[1].BaseName | Should -Be "Content2"
        $content1.OnAlbum.Name | Should -Be "Apple"
        $content2.OnAlbum.Name | Should -Be "Apple"

        # Do
        $albumBO.AddAlbumRelationshipsWithContent($content3, $albumList, "Cherry")

        # Test
        $albumList.Count | Should -Be 2
        $albumList[0].Name | Should -Be "Apple"
        $albumList[1].Name | Should -Be "Cherry"
        $albumList[0].Tracks.Count | Should -Be 2
        $albumList[1].Tracks.Count | Should -Be 1
        $albumList[0].Tracks[0].BaseName | Should -Be "Content1"
        $albumList[0].Tracks[1].BaseName | Should -Be "Content2"
        $albumList[1].Tracks[0].BaseName | Should -Be "Content3"
        $content1.OnAlbum.Name | Should -Be "Apple"
        $content2.OnAlbum.Name | Should -Be "Apple"
        $content3.OnAlbum.Name | Should -Be "Cherry"

        # Do
        $albumBO.AddAlbumRelationshipsWithContent($content4, $albumList, "Unknown")

        # Test
        $albumList.Count | Should -Be 3
        $albumList[0].Name | Should -Be "Apple"
        $albumList[1].Name | Should -Be "Cherry"
        $albumList[2].Name | Should -Be "<Unknown>"
        $albumList[0].Tracks.Count | Should -Be 2
        $albumList[1].Tracks.Count | Should -Be 1
        $albumList[2].Tracks.Count | Should -Be 1
        $albumList[0].Tracks[0].BaseName | Should -Be "Content1"
        $albumList[0].Tracks[1].BaseName | Should -Be "Content2"
        $albumList[1].Tracks[0].BaseName | Should -Be "Content3"
        $albumList[2].Tracks[0].BaseName | Should -Be "Content4"
        $content1.OnAlbum.Name | Should -Be "Apple"
        $content2.OnAlbum.Name | Should -Be "Apple"
        $content3.OnAlbum.Name | Should -Be "Cherry"
        $content4.OnAlbum.Name | Should -Be "<Unknown>"
    }

    It "RemoveAlbumRelationshipsWithContentAndCleanup" {
        # Do
        $albumBO = [AlbumBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $albumList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $true, $false, $false, $true, $false, $false, $false)

        $content1.ProducedBy = [Studio]::new("Banana", $true, $true)

        $albumBO.AddAlbumRelationshipsWithContent($content1, $albumList, "Apple")
        $albumBO.AddAlbumRelationshipsWithContent($content2, $albumList, "Cherry")

        $content1.OnAlbum.ProducedBy.Add($content1.ProducedBy)
        $content1.ProducedBy.ProducedAlbums.Add($content1.OnAlbum)

        # Do
        $albumBO.RemoveAlbumRelationshipsWithContentAndCleanup($albumList, $content1)

        # Test
        $albumList.Count | Should -Be 1
        $albumList[0].Name | Should -Be "Cherry"
        $albumList[0].Tracks.Count | Should -Be 1
        $albumList[0].Tracks[0].BaseName | Should -Be "Content2"

        # Do
        $albumBO.RemoveAlbumRelationshipsWithContentAndCleanup($albumList, $content2)

        # Test
        $albumList.Count | Should -Be 0
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}
