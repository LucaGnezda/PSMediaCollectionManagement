using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\StudioBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
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
    $config.ConfigureForStructuredFiles(@([FilenameElement]::Album, [FilenameElement]::Series, [FilenameElement]::Studio))
    $config.LockFilenameFormat()
}

Describe "StudioBO Unit Test" -Tag UnitTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Constructing" {
        # Test
        {$studioBO = [StudioBO]::new($config); $studioBO} | Should -Not -Throw

        # Do
        $invalidConfig = [ContentModelConfig]::new()
        $invalidConfig.ConfigureForStructuredFiles(@([FilenameElement]::Album, [FilenameElement]::Series, [FilenameElement]::Studio))

        # Test
        {$studioBO = [StudioBO]::new($invalidConfig); $studioBO} | Should -Throw
    }

    It "ActsOnType" {
        # Do
        $studioBO = [StudioBO]::new($config)

        # Test
        $studioBO.ActsOnType().Name | Should -Be "Studio"
    }

    It "ActsOnFilenameElement" {
        # Do
        $studioBO = [StudioBO]::new($config)

        # Test
        $studioBO.ActsOnFilenameElement() -eq [FilenameElement]::Studio | Should -Be $true
    }

    It "ReplaceSubjectLinkedToContent" {
        # Do
        $studioBO = [StudioBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)
        $content.OnAlbum = [Album]::new("Apple", $true)
        $content.FromSeries = [Series]::new("Banana", $true)
        $content.ProducedBy = [Studio]::new("Cherry", $true, $true)
        $content.OnAlbum.ProducedBy.Add($content.ProducedBy)
        $content.OnAlbum.Tracks.Add($content)
        $content.FromSeries.ProducedBy.Add($content.ProducedBy)
        $content.FromSeries.Episodes.Add($content)
        $content.ProducedBy.ProducedAlbums.Add($content.OnAlbum)
        $content.ProducedBy.ProducedSeries.Add($content.FromSeries)
        $content.ProducedBy.Produced.Add($content)

        $replacementStudio = [Studio]::new("Date", $true, $true)

        $incorrectType = [Actor]::new("Kiwi")

        # Do
        $studioBO.ReplaceSubjectLinkedToContent($content, $content.ProducedBy, $incorrectType)

        # Test
        $content.ProducedBy.Name | Should -Be "Cherry"

        # Do
        $studioBO.ReplaceSubjectLinkedToContent($content, $content.ProducedBy, $replacementStudio)

        # Test
        $content.ProducedBy.Name | Should -Be "Date"
    }

    It "ReplaceStudioLinkedWithContent" {
        # Do
        $studioBO = [StudioBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)
        $content.OnAlbum = [Album]::new("Apple", $true)
        $content.FromSeries = [Series]::new("Banana", $true)
        $content.ProducedBy = [Studio]::new("Cherry", $true, $true)
        $content.OnAlbum.ProducedBy.Add($content.ProducedBy)
        $content.OnAlbum.Tracks.Add($content)
        $content.FromSeries.ProducedBy.Add($content.ProducedBy)
        $content.FromSeries.Episodes.Add($content)
        $content.ProducedBy.ProducedAlbums.Add($content.OnAlbum)
        $content.ProducedBy.ProducedSeries.Add($content.FromSeries)
        $content.ProducedBy.Produced.Add($content)

        $replacementStudio = [Studio]::new("Date", $true, $true)

        # Do
        $studioBO.ReplaceStudioLinkedWithContent($content, $replacementStudio)

        # Test
        $content.ProducedBy.Name | Should -Be "Date"
    }

    It "ModifyCrossLinksBetweenAlbumAndStudio" {
        # Do
        $studioBO = [StudioBO]::new($config)

        $replaceStudio = [Studio]::new("Apple", $true, $true)
        $withStudio = [Studio]::new("Cherry", $true, $true)
        $album = [Album]::new("Banana", $true)
        $replaceStudio.ProducedAlbums.Add($album)
        $withStudio.ProducedAlbums.Add($album)
        $album.ProducedBy.Add($replaceStudio)
        $album.ProducedBy.Add($withStudio)

        # Test
        $studioBO.ModifyCrossLinksBetweenAlbumAndStudio($replaceStudio, $withStudio)

        # Do
        $replaceStudio = [Studio]::new("Apple", $true, $true)
        $withStudio = [Studio]::new("Cherry", $true, $true)
        $album1 = [Album]::new("Banana", $true)
        $album2 = [Album]::new("Date", $true)
        $replaceStudio.ProducedAlbums.Add($album1)
        $withStudio.ProducedAlbums.Add($album2)
        $album1.ProducedBy.Add($replaceStudio)
        $album2.ProducedBy.Add($withStudio)

        # Test
        $studioBO.ModifyCrossLinksBetweenAlbumAndStudio($replaceStudio, $withStudio)

    }

    It "ModifyCrossLinksBetweenSeriesAndStudio" {
        # Do
        $studioBO = [StudioBO]::new($config)

        $replaceStudio = [Studio]::new("Apple", $true, $true)
        $withStudio = [Studio]::new("Cherry", $true, $true)
        $series = [Series]::new("Banana", $true)
        $replaceStudio.ProducedSeries.Add($series)
        $withStudio.ProducedSeries.Add($series)
        $series.ProducedBy.Add($replaceStudio)
        $series.ProducedBy.Add($withStudio)

        # Test
        $studioBO.ModifyCrossLinksBetweenSeriesAndStudio($replaceStudio, $withStudio)

        # Do
        $replaceStudio = [Studio]::new("Apple", $true, $true)
        $withStudio = [Studio]::new("Cherry", $true, $true)
        $series1 = [Series]::new("Banana", $true)
        $series2 = [Series]::new("Date", $true)
        $replaceStudio.ProducedSeries.Add($series1)
        $withStudio.ProducedSeries.Add($series2)
        $series1.ProducedBy.Add($replaceStudio)
        $series2.ProducedBy.Add($withStudio)

        # Test
        $studioBO.ModifyCrossLinksBetweenSeriesAndStudio($replaceStudio, $withStudio)

    }

    It "AddStudioRelationshipsWithContent" {
        # Do
        $studioBO = [StudioBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $studioList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)
        [Content] $content3 = [Content]::new("Content3.test", "Content3", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)
        [Content] $content4 = [Content]::new("Content4.test", "Content4", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)
    
        # Do
        $studioBO.AddStudioRelationshipsWithContent($content1, $studioList, "Apple")

        # Test
        $studioList.Count | Should -Be 1
        $studioList[0].Name | Should -Be "Apple"
        $studioList[0].Produced.Count | Should -Be 1
        $studioList[0].Produced[0].BaseName | Should -Be "Content1"
        $content1.ProducedBy.Name | Should -Be "Apple"

        # Do
        $studioBO.AddStudioRelationshipsWithContent($content2, $studioList, "Apple")

        # Test
        $studioList.Count | Should -Be 1
        $studioList[0].Name | Should -Be "Apple"
        $studioList[0].Produced.Count | Should -Be 2
        $studioList[0].Produced[0].BaseName | Should -Be "Content1"
        $studioList[0].Produced[1].BaseName | Should -Be "Content2"
        $content1.ProducedBy.Name | Should -Be "Apple"
        $content2.ProducedBy.Name | Should -Be "Apple"

        # Do
        $studioBO.AddStudioRelationshipsWithContent($content3, $studioList, "Cherry")

        # Test
        $studioList.Count | Should -Be 2
        $studioList[0].Name | Should -Be "Apple"
        $studioList[1].Name | Should -Be "Cherry"
        $studioList[0].Produced.Count | Should -Be 2
        $studioList[1].Produced.Count | Should -Be 1
        $studioList[0].Produced[0].BaseName | Should -Be "Content1"
        $studioList[0].Produced[1].BaseName | Should -Be "Content2"
        $studioList[1].Produced[0].BaseName | Should -Be "Content3"
        $content1.ProducedBy.Name | Should -Be "Apple"
        $content2.ProducedBy.Name | Should -Be "Apple"
        $content3.ProducedBy.Name | Should -Be "Cherry"

        # Do
        $studioBO.AddStudioRelationshipsWithContent($content4, $studioList, "Unknown")

        # Test
        $studioList.Count | Should -Be 3
        $studioList[0].Name | Should -Be "Apple"
        $studioList[1].Name | Should -Be "Cherry"
        $studioList[2].Name | Should -Be "<Unknown>"
        $studioList[0].Produced.Count | Should -Be 2
        $studioList[1].Produced.Count | Should -Be 1
        $studioList[2].Produced.Count | Should -Be 1
        $studioList[0].Produced[0].BaseName | Should -Be "Content1"
        $studioList[0].Produced[1].BaseName | Should -Be "Content2"
        $studioList[1].Produced[0].BaseName | Should -Be "Content3"
        $studioList[2].Produced[0].BaseName | Should -Be "Content4"
        $content1.ProducedBy.Name | Should -Be "Apple"
        $content2.ProducedBy.Name | Should -Be "Apple"
        $content3.ProducedBy.Name | Should -Be "Cherry"
        $content4.ProducedBy.Name | Should -Be "<Unknown>"
    }

    It "RemoveStudioRelationshipsWithContentAndCleanup" {
        # Do
        $studioBO = [StudioBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $studioList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $true, $false, $true, $true, $false, $false, $false)

        $content1.OnAlbum = [Album]::new("Banana", $true)
        $content2.FromSeries = [Series]::new("Date", $true)

        $studioBO.AddStudioRelationshipsWithContent($content1, $studioList, "Apple")
        $studioBO.AddStudioRelationshipsWithContent($content2, $studioList, "Cherry")

        $content1.OnAlbum.ProducedBy.Add($content1.ProducedBy)
        $content1.ProducedBy.ProducedAlbums.Add($content1.OnAlbum)
        $content2.FromSeries.ProducedBy.Add($content2.ProducedBy)
        $content2.ProducedBy.ProducedSeries.Add($content2.FromSeries)

        # Do
        $studioBO.RemoveStudioRelationshipsWithContentAndCleanup($studioList, $content1)

        # Test
        $studioList.Count | Should -Be 1
        $studioList[0].Name | Should -Be "Cherry"
        $studioList[0].ProducedAlbums.Count | Should -Be 0
        $studioList[0].ProducedSeries.Count | Should -Be 1
        $studioList[0].Produced.Count | Should -Be 1
        $studioList[0].Produced[0].BaseName | Should -Be "Content2"

        # Do
        $studioBO.RemoveStudioRelationshipsWithContentAndCleanup($studioList, $content2)

        # Test
        $studioList.Count | Should -Be 0
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}


