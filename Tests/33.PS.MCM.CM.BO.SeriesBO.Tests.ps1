using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\SeriesBO.Class.psm1
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
    $config.ConfigureForStructuredFiles(@([FilenameElement]::Series, [FilenameElement]::Studio))
    $config.LockFilenameFormat()
}

Describe "SeriesBO Unit Test" -Tag UnitTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Constructing" {
        # Test
        {$seriesBO = [SeriesBO]::new($config); $seriesBO} | Should -Not -Throw

        # Do
        $invalidConfig = [ContentModelConfig]::new()
        $invalidConfig.ConfigureForStructuredFiles(@([FilenameElement]::Series, [FilenameElement]::Studio))

        # Test
        {$seriesBO = [SeriesBO]::new($invalidConfig); $seriesBO} | Should -Throw
    }

    It "ActsOnType" {
        # Do
        $seriesBO = [SeriesBO]::new($config)

        # Test
        $seriesBO.ActsOnType().Name | Should -Be "Series"
    }

    It "ActsOnFilenameElement" {
        # Do
        $seriesBO = [SeriesBO]::new($config)

        # Test
        $seriesBO.ActsOnFilenameElement() -eq [FilenameElement]::Series | Should -Be $true
    }

    It "ReplaceSubjectLinkedToContent" {
        # Do
        $seriesBO = [SeriesBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)
        $content.FromSeries = [Series]::new("Apple", $true)
        $content.ProducedBy = [Studio]::new("Banana", $true, $true)
        $content.FromSeries.ProducedBy.Add($content.ProducedBy)
        $content.FromSeries.Episodes.Add($content)
        $content.ProducedBy.ProducedSeries.Add($content.FromSeries)
        $content.ProducedBy.Produced.Add($content)

        $replacementSeries = [Series]::new("Date", $true)

        $incorrectType = [Album]::new("Kiwi")

        # Do
        $seriesBO.ReplaceSubjectLinkedToContent($content, $content.FromSeries, $incorrectType)

        # Test
        $content.FromSeries.Name | Should -Be "Apple"

        # Do
        $seriesBO.ReplaceSubjectLinkedToContent($content, $content.FromSeries, $replacementSeries)

        # Test
        $content.FromSeries.Name | Should -Be "Date"
    }

    It "ReplaceSeriesLinkedWithContent" {
        # Do
        $seriesBO = [SeriesBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)
        $content.FromSeries = [Series]::new("Apple", $true)
        $content.ProducedBy = [Studio]::new("Banana", $true, $true)
        $content.FromSeries.ProducedBy.Add($content.ProducedBy)
        $content.FromSeries.Episodes.Add($content)
        $content.ProducedBy.ProducedSeries.Add($content.OnAFromSerieslbum)
        $content.ProducedBy.Produced.Add($content)

        $replacementSeries = [Series]::new("Date", $true)

        # Do
        $seriesBO.ReplaceSeriesLinkedWithContent($content, $replacementSeries)

        # Test
        $content.FromSeries.Name | Should -Be "Date"
    }

    It "ModifyCrossLinksBetweenSeriesAndStudio" {
        # Do
        $seriesBO = [SeriesBO]::new($config)

        $replaceSeries = [Series]::new("Apple", $true)
        $withSeries = [Series]::new("Cherry", $true)
        $studio = [Studio]::new("Banana", $true, $true)
        $replaceSeries.ProducedBy.Add($studio)
        $withSeries.ProducedBy.Add($studio)
        $studio.ProducedSeries.Add($replaceSeries)
        $studio.ProducedSeries.Add($withSeries)

        # Test
        $seriesBO.ModifyCrossLinksBetweenSeriesAndStudio($replaceSeries, $withSeries)

        # Do
        $replaceSeries = [Series]::new("Apple", $true)
        $withSeries = [Series]::new("Cherry", $true)
        $studio1 = [Studio]::new("Banana", $true, $true)
        $studio2 = [Studio]::new("Date", $true, $true)
        $replaceSeries.ProducedBy.Add($studio1)
        $withSeries.ProducedBy.Add($studio2)
        $studio1.ProducedSeries.Add($replaceSeries)
        $studio2.ProducedSeries.Add($withSeries)

        # Test
        $seriesBO.ModifyCrossLinksBetweenSeriesAndStudio($replaceSeries, $withSeries)

    }

    It "AddSeriesRelationshipsWithContent" {
        # Do
        $seriesBO = [SeriesBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $seriesList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)
        [Content] $content3 = [Content]::new("Content3.test", "Content3", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)
        [Content] $content4 = [Content]::new("Content4.test", "Content4", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)
    
        # Do
        $seriesBO.AddSeriesRelationshipsWithContent($content1, $seriesList, "Apple")

        # Test
        $seriesList.Count | Should -Be 1
        $seriesList[0].Name | Should -Be "Apple"
        $seriesList[0].Episodes.Count | Should -Be 1
        $seriesList[0].Episodes[0].BaseName | Should -Be "Content1"
        $content1.FromSeries.Name | Should -Be "Apple"

        # Do
        $seriesBO.AddSeriesRelationshipsWithContent($content2, $seriesList, "Apple")

        # Test
        $seriesList.Count | Should -Be 1
        $seriesList[0].Name | Should -Be "Apple"
        $seriesList[0].Episodes.Count | Should -Be 2
        $seriesList[0].Episodes[0].BaseName | Should -Be "Content1"
        $seriesList[0].Episodes[1].BaseName | Should -Be "Content2"
        $content1.FromSeries.Name | Should -Be "Apple"
        $content2.FromSeries.Name | Should -Be "Apple"

        # Do
        $seriesBO.AddSeriesRelationshipsWithContent($content3, $seriesList, "Cherry")

        # Test
        $seriesList.Count | Should -Be 2
        $seriesList[0].Name | Should -Be "Apple"
        $seriesList[1].Name | Should -Be "Cherry"
        $seriesList[0].Episodes.Count | Should -Be 2
        $seriesList[1].Episodes.Count | Should -Be 1
        $seriesList[0].Episodes[0].BaseName | Should -Be "Content1"
        $seriesList[0].Episodes[1].BaseName | Should -Be "Content2"
        $seriesList[1].Episodes[0].BaseName | Should -Be "Content3"
        $content1.FromSeries.Name | Should -Be "Apple"
        $content2.FromSeries.Name | Should -Be "Apple"
        $content3.FromSeries.Name | Should -Be "Cherry"

        # Do
        $seriesBO.AddSeriesRelationshipsWithContent($content4, $seriesList, "Unknown")

        # Test
        $seriesList.Count | Should -Be 3
        $seriesList[0].Name | Should -Be "Apple"
        $seriesList[1].Name | Should -Be "Cherry"
        $seriesList[2].Name | Should -Be "<Unknown>"
        $seriesList[0].Episodes.Count | Should -Be 2
        $seriesList[1].Episodes.Count | Should -Be 1
        $seriesList[2].Episodes.Count | Should -Be 1
        $seriesList[0].Episodes[0].BaseName | Should -Be "Content1"
        $seriesList[0].Episodes[1].BaseName | Should -Be "Content2"
        $seriesList[1].Episodes[0].BaseName | Should -Be "Content3"
        $seriesList[2].Episodes[0].BaseName | Should -Be "Content4"
        $content1.FromSeries.Name | Should -Be "Apple"
        $content2.FromSeries.Name | Should -Be "Apple"
        $content3.FromSeries.Name | Should -Be "Cherry"
        $content4.FromSeries.Name | Should -Be "<Unknown>"
    }

    It "RemoveSeriesRelationshipsWithContentAndCleanup" {
        # Do
        $seriesBO = [SeriesBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $seriesList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $false, $false, $true, $true, $false, $false, $false)

        $content1.ProducedBy = [Studio]::new("Banana", $true, $true)

        $seriesBO.AddSeriesRelationshipsWithContent($content1, $seriesList, "Apple")
        $seriesBO.AddSeriesRelationshipsWithContent($content2, $seriesList, "Cherry")

        $content1.FromSeries.ProducedBy.Add($content1.ProducedBy)
        $content1.ProducedBy.ProducedSeries.Add($content1.FromSeries)

        # Do
        $seriesBO.RemoveSeriesRelationshipsWithContentAndCleanup($seriesList, $content1)

        # Test
        $seriesList.Count | Should -Be 1
        $seriesList[0].Name | Should -Be "Cherry"
        $seriesList[0].Episodes.Count | Should -Be 1
        $seriesList[0].Episodes[0].BaseName | Should -Be "Content2"

        # Do
        $seriesBO.RemoveSeriesRelationshipsWithContentAndCleanup($seriesList, $content2)

        # Test
        $seriesList.Count | Should -Be 0
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}
