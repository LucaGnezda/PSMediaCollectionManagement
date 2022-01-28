using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $config = [ContentModelConfig]::new()
    $config  # line to make parser happy 
}

Describe "ContentModelConfig Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing" {        
        # Test
        {$config.IncludedExtensions} | Should -Not -Throw
        {$config.DecorateAsTags} | Should -Not -Throw
        {$config.TagOpenDelimiter} | Should -Not -Throw
        {$config.TagCloseDelimiter} | Should -Not -Throw
        {$config.FilenameFormat} | Should -Not -Throw
        {$config.FilenameSplitter} | Should -Not -Throw
        {$config.ListSplitter} | Should -Not -Throw
        {$config.ExportFormat} | Should -Not -Throw
        {$config.IsFilenameFormatLocked} | Should -Not -Throw
        {$config.TitleSplitIndex} | Should -Not -Throw
        {$config.ActorsSplitIndex} | Should -Not -Throw
        {$config.AlbumSplitIndex} | Should -Not -Throw
        {$config.ArtistsSplitIndex} | Should -Not -Throw
        {$config.SeasonEpisodeSplitIndex} | Should -Not -Throw
        {$config.SeriesSplitIndex} | Should -Not -Throw
        {$config.StudioSplitIndex} | Should -Not -Throw
        {$config.TrackSplitIndex} | Should -Not -Throw
        {$config.YearSplitIndex} | Should -Not -Throw
        {$config.IncludeTitles} | Should -Not -Throw
        {$config.IncludeActors} | Should -Not -Throw
        {$config.IncludeAlbums} | Should -Not -Throw
        {$config.IncludeArtists} | Should -Not -Throw
        {$config.IncludeSeasonEpisodes} | Should -Not -Throw
        {$config.IncludeSeries} | Should -Not -Throw
        {$config.IncludeStudios} | Should -Not -Throw
        {$config.IncludeTracks} | Should -Not -Throw
        {$config.IncludeYears} | Should -Not -Throw
    }

    It "OverrideIncludedExtensions" {
        # Do
        $config.OverrideIncludedExtensions($null)
        
        # Test
        $config.IncludedExtensions | Should -Be @()

        # Do
        $config.OverrideIncludedExtensions(@(".foo"))
        
        # Test
        $config.IncludedExtensions | Should -Be @(".foo")
    }

    It "OverrideTagsToDecorate" {
        # Do
        $config.OverrideTagsToDecorate($null)

        # Test
        $config.DecorateAsTags | Should -Be @()

        # Do
        $config.OverrideTagsToDecorate(@("Foo"))

        # Test
        $config.DecorateAsTags | Should -Be @("Foo")
    }

    It "OverrideTagDelimiters" {
        # Do
        $config.OverrideTagDelimiters("", "")

        # Test
        $config.TagOpenDelimiter | Should -Be ""
        $config.TagCloseDelimiter | Should -Be ""

        # Do
        $config.OverrideTagDelimiters("<",">")

        # Test
        $config.TagOpenDelimiter | Should -Be "<"
        $config.TagCloseDelimiter | Should -Be ">"
    }

    It "OverrideFilenameFormat" {        
        # Do
        $config.OverrideFilenameFormat($null)

        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Title)

        # Do
        $config.OverrideFilenameFormat(@([FilenameElement]::Studio, [FilenameElement]::Title))

        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Studio, [FilenameElement]::Title)
    }

    It "OverrideFilenameSplitter" {
        # Do
        $config.OverrideFilenameSplitter($null)

        # Test
        $config.FilenameSplitter | Should -Be @(" - ")

        # Do
        $config.OverrideFilenameSplitter("")

        # Test
        $config.FilenameSplitter | Should -Be @(" - ")

        # Do
        $config.OverrideFilenameSplitter("|")

        # Test
        $config.FilenameSplitter | Should -Be @("|")
    }
    
    It "OverrideListSplitter" {
        # Do
        $config.OverrideListSplitter($null)

        # Test
        $config.ListSplitter | Should -Be @(", ")

        # Do
        $config.OverrideListSplitter("")

        # Test
        $config.ListSplitter | Should -Be @(", ")

        # Do
        $config.OverrideListSplitter("|")

        # Test
        $config.ListSplitter | Should -Be @("|")
    }

    It "OverrideExportFormat" {
        # Do
        $config.OverrideExportFormat($null)

        # Test
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)

        # Do
        $config.OverrideExportFormat(@([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension))

        # Test
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension)
    }

    It "RemodelFilenameFormat" {
        # Do
        $config.OverrideFilenameFormat(@([FilenameElement]::Studio, [FilenameElement]::Title, [FilenameElement]::Year))

        # Test
        $config.RemodelFilenameFormat(0,2) | Should -Be $true
        $config.FilenameFormat | Should -Be @([FilenameElement]::Year, [FilenameElement]::Title, [FilenameElement]::Studio)
        $config.RemodelFilenameFormat(-1,2) | Should -Be $false
        $config.RemodelFilenameFormat(0,-2) | Should -Be $false
        $config.RemodelFilenameFormat(5,2) | Should -Be $false
        $config.RemodelFilenameFormat(0,5) | Should -Be $false
    }

    It "ConfigureForUnstructuredFiles" {
        # Do
        $config.ConfigureForUnstructuredFiles()

        # Test
        $config.IncludedExtensions | Should -Be @()
        $config.DecorateAsTags | Should -Be @()
        $config.TagOpenDelimiter | Should -Be ""
        $config.TagCloseDelimiter | Should -Be ""
        $config.FilenameFormat | Should -Be @([FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be ""
        $config.ListSplitter | Should -Be ""
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "ConfigureForStructuredFiles" {
        # Do
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Studio, [FilenameElement]::Title, [FilenameElement]::Year))

        # Test
        $config.IncludedExtensions | Should -Be @()
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.TagOpenDelimiter | Should -Be "<"
        $config.TagCloseDelimiter | Should -Be ">"
        $config.FilenameFormat | Should -Be @([FilenameElement]::Studio, [FilenameElement]::Title, [FilenameElement]::Year)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }
    
    It "ConfigureForFilm" {
        # Do
        $config.ConfigureForFilm()

        # Test
        $config.IncludedExtensions | Should -Be @(".mp4", ".wmv", ".mkv")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.TagOpenDelimiter | Should -Be "<"
        $config.TagCloseDelimiter | Should -Be ">"
        $config.FilenameFormat | Should -Be @([FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "ConfigureForShortFilm" {
        # Do
        $config.ConfigureForShortFilm()

        # Test
        $config.IncludedExtensions | Should -Be @(".mp4", ".wmv", ".mkv")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.TagOpenDelimiter | Should -Be "<"
        $config.TagCloseDelimiter | Should -Be ">"
        $config.FilenameFormat | Should -Be @([FilenameElement]::Studio, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "ConfigureForSeries" {
        # Do
        $config.ConfigureForSeries()

        # Test
        $config.IncludedExtensions | Should -Be @(".mp4", ".wmv", ".mkv")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.TagOpenDelimiter | Should -Be "<"
        $config.TagCloseDelimiter | Should -Be ">"
        $config.FilenameFormat | Should -Be @([FilenameElement]::Series, [FilenameElement]::SeasonEpisode, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "ConfigureForTrack" {
        # Do
        $config.ConfigureForTrack()

        # Test
        $config.IncludedExtensions | Should -Be @(".mp3", ".aac", ".wav")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.TagOpenDelimiter | Should -Be "<"
        $config.TagCloseDelimiter | Should -Be ">"
        $config.FilenameFormat | Should -Be @([FilenameElement]::Track, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "ConfigureForAlbumAndTrack" {
        # Do
        $config.ConfigureForAlbumAndTrack()

        # Test
        $config.IncludedExtensions | Should -Be @(".mp3", ".aac", ".wav")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.TagOpenDelimiter | Should -Be "<"
        $config.TagCloseDelimiter | Should -Be ">"
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album, [FilenameElement]::Track, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "Display" {
        # Do
        $config.ConfigureForAlbumAndTrack()

        # Test
        {$config.DisplayConfig()} | Should -Not -Throw
    }
    
    It "Locking" {
        # Do
        $config.OverrideFilenameFormat(@([FilenameElement]::Album))
        $config.LockFilenameFormat()

        # Do
        $config.OverrideFilenameFormat(@([FilenameElement]::Title))
        
        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        # Do
        $config.ConfigureForUnstructuredFiles()
        
        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)
        
        # Do
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Title))
        
        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)
        
        # Do
        $config.ConfigureForFilm()
        
        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        # Do
        $config.ConfigureForShortFilm()

        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        # Do
        $config.ConfigureForFilm()
        
        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

         # Do
         $config.ConfigureForSeries()
        
         # Test
         $config.FilenameFormat | Should -Be @([FilenameElement]::Album)
        
        # Do
        $config.ConfigureForTrack()
        
        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        # Do
        $config.ConfigureForAlbumAndTrack()
        
        # Test
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}