using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1

BeforeAll {     
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $config = [ContentModelConfig]::new()
    $config.ConfigureForFilm()
}

Describe "ContentModelConfig Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $config.IncludedExtensions | Should -Be @(".mp4", ".wmv", ".mkv")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.FilenameFormat | Should -Be @([FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "Set IncludedExtensions" {
        $config.OverrideIncludedExtensions($null)
        $config.IncludedExtensions | Should -Be @()

        $config.OverrideIncludedExtensions(@(".foo"))
        $config.IncludedExtensions | Should -Be @(".foo")
    }

    It "Set OverrideTagsToDecorate" {
        $config.OverrideTagsToDecorate($null)
        $config.DecorateAsTags | Should -Be @()

        $config.OverrideTagsToDecorate(@("Foo"))
        $config.DecorateAsTags | Should -Be @("Foo")
    }

    It "Set OverrideFilenameFormat" {        
        $config.OverrideFilenameFormat($null)
        $config.FilenameFormat | Should -Be @([FilenameElement]::Title)

        $config.OverrideFilenameFormat(@([FilenameElement]::Studio, [FilenameElement]::Title))
        $config.FilenameFormat | Should -Be @([FilenameElement]::Studio, [FilenameElement]::Title)
    }

    It "Set OverrideFilenameSplitter" {
        $config.OverrideFilenameSplitter($null)
        $config.FilenameSplitter | Should -Be @(" - ")

        $config.OverrideFilenameSplitter("")
        $config.FilenameSplitter | Should -Be @(" - ")

        $config.OverrideFilenameSplitter("|")
        $config.FilenameSplitter | Should -Be @("|")
    }
    
    It "Set OverrideListSplitter" {
        $config.OverrideListSplitter($null)
        $config.ListSplitter | Should -Be @(", ")

        $config.OverrideListSplitter("")
        $config.ListSplitter | Should -Be @(", ")

        $config.OverrideListSplitter("|")
        $config.ListSplitter | Should -Be @("|")
    }

    It "Set OverrideExportFormat" {
        $config.OverrideExportFormat($null)
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)

        $config.OverrideExportFormat(@([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension))
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension)
    }

    It "Configuration for Files" {
        $config.ConfigureForUnstructuredFiles()
        $config.IncludedExtensions | Should -Be @()
        $config.DecorateAsTags | Should -Be @()
        $config.FilenameFormat | Should -Be @([FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be ""
        $config.ListSplitter | Should -Be ""
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }
    
    It "Configuration for Film" {
        $config.ConfigureForFilm()
        $config.IncludedExtensions | Should -Be @(".mp4", ".wmv", ".mkv")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.FilenameFormat | Should -Be @([FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "Configuration for Short Film" {
        $config.ConfigureForShortFilm()
        $config.IncludedExtensions | Should -Be @(".mp4", ".wmv", ".mkv")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.FilenameFormat | Should -Be @([FilenameElement]::Studio, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "Configuration for Series" {
        $config.ConfigureForSeries()
        $config.IncludedExtensions | Should -Be @(".mp4", ".wmv", ".mkv")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.FilenameFormat | Should -Be @([FilenameElement]::Series, [FilenameElement]::SeasonEpisode, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "Configuration for Track" {
        $config.ConfigureForTrack()
        $config.IncludedExtensions | Should -Be @(".mp3", ".aac", ".wav")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.FilenameFormat | Should -Be @([FilenameElement]::Artists, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "Configuration for Album and Track" {
        $config.ConfigureForAlbumAndTrack()
        $config.IncludedExtensions | Should -Be @(".mp3", ".aac", ".wav")
        $config.DecorateAsTags | Should -Be @("Unknown", "Various")
        $config.FilenameFormat | Should -Be @([FilenameElement]::Artists, [FilenameElement]::Album, [FilenameElement]::Title)
        $config.FilenameSplitter | Should -Be " - "
        $config.ListSplitter | Should -Be ", "
        $config.ExportFormat | Should -Be @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Duration, [ExportableAttribute]::Bitrate, [ExportableAttribute]::Hash)
        $config.IsFilenameFormatLocked | Should -Be $false
    }

    It "Display" {
        $config.ConfigureForAlbumAndTrack()
        $config.DisplayConfig()
    }
    
    It "Locking" {
        
        $config.OverrideFilenameFormat(@([FilenameElement]::Album))
        
        $config.LockFilenameFormat()

        $config.OverrideFilenameFormat(@([FilenameElement]::Title))
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        $config.ConfigureForFilm()
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        $config.ConfigureForShortFilm()
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        $config.ConfigureForFilm()
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        $config.ConfigureForTrack()
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)

        $config.ConfigureForAlbumAndTrack()
        $config.FilenameFormat | Should -Be @([FilenameElement]::Album)
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}