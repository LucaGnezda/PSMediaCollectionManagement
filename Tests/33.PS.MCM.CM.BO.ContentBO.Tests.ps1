using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ContentBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Album.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Series.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\FileSystemProvider.Class.psm1  
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "ContentBO Unit Test" -Tag UnitTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Constructing invalid config" {
        # Do
        $invalidConfig = [ContentModelConfig]::new()
        $invalidConfig.ConfigureForStructuredFiles(@([FilenameElement]::Actors))

        # Test
        {$contentBO = [ContentBO]::new($invalidConfig); $contentBO} | Should -Throw
    }
    
    It "Constructing non compliant content - Incorrect number of elements" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Series, [FilenameElement]::Title))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("Non.test", "Non", ".test")

        # Test
        $content.FileName | Should -Be "Non.test"
        $content.BaseName | Should -Be "Non"
        $content.Extension | Should -Be ".test"
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename, [ContentWarning]::SubjectInfoSkipped)
    }

    It "Constructing non compliant content - Invalid SeasonEpisode" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::SeasonEpisode, [FilenameElement]::Title)) 
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("3i3 - Non.test", "3i3 - Non", ".test")

        # Test
        $content.FileName | Should -Be "3i3 - Non.test"
        $content.BaseName | Should -Be "3i3 - Non"
        $content.Extension | Should -Be ".test"
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename, [ContentWarning]::SubjectInfoNotFullyLoaded)
    }

    It "Constructing non compliant content - Invalid Track" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Track, [FilenameElement]::Title)) 
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("A - Non.test", "A - Non", ".test")

        # Test
        $content.FileName | Should -Be "A - Non.test"
        $content.BaseName | Should -Be "A - Non"
        $content.Extension | Should -Be ".test"
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename, [ContentWarning]::SubjectInfoNotFullyLoaded)
    }

    It "Constructing non compliant content - Invalid Year" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Year, [FilenameElement]::Title)) 
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("3 - Non.test", "3 - Non", ".test")

        # Test
        $content.FileName | Should -Be "3 - Non.test"
        $content.BaseName | Should -Be "3 - Non"
        $content.Extension | Should -Be ".test"
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename, [ContentWarning]::SubjectInfoNotFullyLoaded)
    }

    It "Constructing compliant content - All elements" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Artists, [FilenameElement]::Series, [FilenameElement]::Album, [FilenameElement]::SeasonEpisode, [FilenameElement]::Track, [FilenameElement]::Title, [FilenameElement]::Year))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("Stu - ActA, ActB - ArtA, ArtB - Ser - Alb - 01x02 - 03 - Title - 1984.test", "Stu - ActA, ActB - ArtA, ArtB - Ser - Alb - 01x02 - 03 - Title - 1984", ".test")

        # Test
        $content.FileName | Should -Be "Stu - ActA, ActB - ArtA, ArtB - Ser - Alb - 01x02 - 03 - Title - 1984.test"
        $content.BaseName | Should -Be "Stu - ActA, ActB - ArtA, ArtB - Ser - Alb - 01x02 - 03 - Title - 1984"
        $content.Extension | Should -Be ".test"
        $content.Warnings | Should -Be @()

        $content.SeasonEpisode | Should -Be "01x02"
        $content.Season | Should -Be 1
        $content.Episode | Should -Be 2
        $content.TrackLabel | Should -Be "03"
        $content.Track | Should -Be 3
        $content.Title | Should -Be "Title"
        $content.Year | Should -Be 1984
    }

    It "Constructing compliant content - with tag title" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Title))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("Unknown.test", "Unknown", ".test")

        # Test
        $content.Title | Should -Be "<Unknown>"
    }

    It "ToString" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("Foo - Bar.test", "Foo - Bar", ".test")

        # Test
        $content.ToString() | Should -Be "Foo - Bar"
    }

    It "IsValidSeasonEpisode" -ForEach @(
        @{s = "Foo"; expected = $false}
        @{s = "aS15E12"; expected = $false}
        @{s = "Sa15E12"; expected = $false}
        @{s = "S15aE12"; expected = $false}
        @{s = "S15Ea12"; expected = $false}
        @{s = "S15E12a"; expected = $false}
        @{s = "S15E12"; expected = $true}
        @{s = "s15e12"; expected = $true}
        @{s = "S15e12"; expected = $false}
        @{s = "s15E12"; expected = $false}
        @{s = "a15X12"; expected = $false}
        @{s = "15aX12"; expected = $false}
        @{s = "15Xa12"; expected = $false}
        @{s = "15X12a"; expected = $false}
        @{s = "15X12"; expected = $true}
        @{s = "15x12"; expected = $true}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO._validSeasonEpisodeRegexPatterns | Should -Be @("^S[\d]+E[\d]+$", "^s[\d]+e[\d]+$", "^[\d]+X[\d]+$", "^[\d]+x[\d]+$")
        $contentBO.IsValidSeasonEpisode($s) | Should -Be $expected
    }

    It "IsSeasonEpisodePattern" -ForEach @(
        @{s = "Foo"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "aS15E12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "Sa15E12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15aE12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15Ea12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15E12a"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15E12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $true}
        @{s = "s15e12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "as15e12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "sa15e12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15ae12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15ea12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15e12a"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15e12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $true}
        @{s = "S15E12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "a15X12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15aX12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15Xa12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15X12a"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15X12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $true}
        @{s = "15x12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "a15x12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15ax12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15xa12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15x12a"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15x12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $true}
        @{s = "15X12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO.IsSeasonEpisodePattern($s, $p) | Should -Be $expected
    }

    It "IsValidTrackNumber" -ForEach @(
        @{s = "Foo"; expected = $false}
        @{s = "111a"; expected = $false}
        @{s = "a111"; expected = $false}
        @{s = "1"; expected = $true}
        @{s = "01"; expected = $true}
        @{s = "99"; expected = $true}
        @{s = "111"; expected = $true}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)

        # Test
        $contentBO.IsValidTrackNumber($s) | Should -Be $expected
    }

    It "IsValidYear" -ForEach @(
        @{s = "Foo"; expected = $false}
        @{s = "0000"; expected = $false}
        @{s = "1929"; expected = $true}
        @{s = "2021"; expected = $true}
        @{s = "3400"; expected = $false}
        @{s = "82"; expected = $true}
        @{s = "821"; expected = $false}
        @{s = "8"; expected = $false}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO.IsValidYear($s) | Should -Be $expected
    }

    It "GetSeason" -ForEach @(
        @{s = "Foo"; expected = $null}
        @{s = "S15E12"; expected = 15}
        @{s = "s15e12"; expected = 15}
        @{s = "15X12"; expected = 15}
        @{s = "15x12"; expected = 15}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO.GetSeasonFromString($s) | Should -Be $expected
    }

    It "GetEpisode" -ForEach @(
        @{s = "Foo"; expected = $null}
        @{s = "S15E12"; expected = 12}
        @{s = "s15e12"; expected = 12}
        @{s = "15X12"; expected = 12}
        @{s = "15x12"; expected = 12}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO.GetEpisodeFromString($s) | Should -Be $expected
    }

    It "SeasonEpisodeToString" -ForEach @(
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S1E2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S01E2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S1E02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S01E02"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s1e2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s01e2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s1e02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s01e02"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "1X2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "01X2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "1X02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "01X02"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "1x2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "01x2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "1x02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "01x02"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO.SeasonEpisodeToString($season, $episode, $padSeason, $padEpisode, $pattern) | Should -BeExactly $expected
    }

    It "TrackToString" -ForEach @(
        @{track = 1; padTrack = 0; expected = "1"}
        @{track = 12; padTrack = 0; expected = "12"}
        @{track = 1; padTrack = 1; expected = "1"}
        @{track = 12; padTrack = 1; expected = "12"}
        @{track = 1; padTrack = 2; expected = "01"}
        @{track = 12; padTrack = 2; expected = "12"}
        @{track = 1; padTrack = 3; expected = "001"}
        @{track = 12; padTrack = 3; expected = "012"}
    ) {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO.TrackToString($track, $padTrack) | Should -BeExactly $expected
    }

    It "AddContentToList, RemoveContentFromList" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForUnstructuredFiles()
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        [Content] $content = $contentBO.CreateContentObject("Name.test", "Name", ".test")
        [System.Collections.Generic.List[Content]] $contentList = [System.Collections.Generic.List[Content]]::new()
        $contentBO.AddContentToList($contentList, $content)
        
        # Test
        $contentList.Count | Should -Be 1
        $contentList[0].Title | Should -Be "Name"

        # Do
        $contentBO.RemoveContentFromList($contentList, $content)

        # Test
        $contentList.Count | Should -Be 0
    }

    It "UpdateContentBaseName" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Artists, [FilenameElement]::Series, [FilenameElement]::Album, [FilenameElement]::SeasonEpisode, [FilenameElement]::Track, [FilenameElement]::Title, [FilenameElement]::Year))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        
        $content = $contentBO.CreateContentObject("Stu - ActA, ActB - ArtA, ArtB - Ser - Alb - 01x02 - 03 - Title - 1984.test", "Stu - ActA, ActB - ArtA, ArtB - Ser - Alb - 01x02 - 03 - Title - 1984", ".test")
        $content.ProducedBy = [Studio]::new("Ecky")
        $content.Actors.Add([Actor]::new("Anne"))
        $content.Actors.Add([Actor]::new("Bob"))
        $content.Artists.Add([Artist]::new("Charlie"))
        $content.FromSeries = [Series]::new("Delta")
        $content.OnAlbum = [Album]::new("Gamma")

        $contentBO.UpdateContentBaseName($content)

        # Test
        $content.BaseName | Should -Be "Ecky - Anne, Bob - Charlie - Delta - Gamma - 01x02 - 03 - Title - 1984"

        # TODO
    }

    It "UpdateFileName" {
        # Do
        $config = [ContentModelConfig]::new()
        Push-Location $PSScriptRoot\TestData\ContentTestD
        $config.ConfigureForSeries()
        $config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestD", $config.IncludedExtensions, $false)

        $content = $contentBO.CreateContentObject("Foo - Cherry, Apple, Banana, Pear - Delta.mp4", "Foo - Cherry, Apple, Banana, Pear - Delta", ".mp4")
        $content.ProducedBy = [Studio]::new("Ecky")
        $content.Actors.Add([Actor]::new("Cherry"))
        $content.Actors.Add([Actor]::new("Apple"))
        $content.Actors.Add([Actor]::new("Banana"))
        $content.Actors.Add([Actor]::new("Pear"))
        $content.AlteredBaseName = $true
        $content.PendingFilenameUpdate = $true

        $contentBO.UpdateContentBaseName($content)
        
        # Test
        $contentBO.UpdateFileName($content, $filesystemProvider) | Should -Be $true

        # Do
        Pop-Location
    }

    It "UpdateFileName - With Path" {
        # Do
        $config = [ContentModelConfig]::new()
        Push-Location $PSScriptRoot
        $config.ConfigureForSeries()
        $config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestD", $config.IncludedExtensions, ".\TestData\ContentTestD")

        $content = $contentBO.CreateContentObject("Foo - Cherry, Apple, Banana, Pear - Delta.mp4", "Foo - Cherry, Apple, Banana, Pear - Delta", ".mp4")
        $content.ProducedBy = [Studio]::new("Ecky")
        $content.Actors.Add([Actor]::new("Cherry"))
        $content.Actors.Add([Actor]::new("Apple"))
        $content.Actors.Add([Actor]::new("Banana"))
        $content.Actors.Add([Actor]::new("Pear"))
        $content.AlteredBaseName = $true
        $content.PendingFilenameUpdate = $true

        $contentBO.UpdateContentBaseName($content)
        
        # Test
        $contentBO.UpdateFileName($content, $filesystemProvider) | Should -Be $true

        # Do
        Pop-Location
    }

    It "UpdateFileName - File Clash" {
        # Do
        $config = [ContentModelConfig]::new()
        Push-Location $PSScriptRoot\TestData\ContentTestD
        $config.ConfigureForSeries()
        $config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestD", $config.IncludedExtensions, $false)

        $content = $contentBO.CreateContentObject("Foo - Cherry, Apple, Banana, Pear - Delta.mp4", "Foo - Cherry, Apple, Banana, Pear - Delta", ".mp4")
        $content.ProducedBy = [Studio]::new("Foo")
        $content.Actors.Add([Actor]::new("Cherry2"))
        $content.Actors.Add([Actor]::new("Apple"))
        $content.Actors.Add([Actor]::new("Banana"))
        $content.Actors.Add([Actor]::new("Pear"))
        $content.AlteredBaseName = $true
        $content.PendingFilenameUpdate = $true

        $contentBO.UpdateContentBaseName($content)
        
        # Test
        $contentBO.UpdateFileName($content, $filesystemProvider) | Should -Be $false

        # Do
        Pop-Location
    }

    It "FillPropertiesWhereMissing" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", $config.IncludedExtensions, $false)

        # Do
        $content = $contentBO.CreateContentObject("Foo - Bar.mp4", "Foo - Bar", ".mp4")
        $contentBO.FillPropertiesWhereMissing($content, $null, $filesystemProvider) 

        # Test
        $content.FrameWidth | Should -Be 320
        $content.FrameHeight | Should -Be 240
        $content.FrameRate | Should -Be "30.00 frames/second"
        $content.BitRate | Should -Be "375kbps"
        $content.TimeSpan | Should -Be (New-TimeSpan -Minutes 3 -Seconds 32)

        # Do
        $content = $contentBO.CreateContentObject("Foo - Bar.wav", "Foo - Bar", ".wav")
        $contentBO.FillPropertiesWhereMissing($content, $null, $filesystemProvider)
        
        # Test
        $content.TimeSpan | Should -Be (New-TimeSpan -Seconds 3) 
        $content.BitRate | Should -Be "352kbps"

        # Do
        $content = $contentBO.CreateContentObject("Foo - Bar.txt", "Foo - Bar", ".txt")
        $contentBO.FillPropertiesWhereMissing($content, $null, $filesystemProvider)

        # Test
        $content.Warnings.Count | Should -Be 2

        # Do
        $content = $contentBO.CreateContentObject("Doesnotexist.wav", "Doesnotexist", ".wav")
        $contentBO.FillPropertiesWhereMissing($content, $null, $filesystemProvider)

        # Test
        $content.Warnings.Count | Should -Be 2

        # Do
        $filesystemProvider.Dispose()
    }

    It "GenerateHashIfMissing" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", $config.IncludedExtensions, $false)

        # Do
        $content = $contentBO.CreateContentObject("Foo - Bar.mp4", "Foo - Bar", ".mp4")
        $contentBO.GenerateHashIfMissing($content, $null, $filesystemProvider) 

        # Test
        $content.Hash | Should -Be "88F292963ED23DA5F9C522CBF5075637"

        # Do
        $content = $contentBO.CreateContentObject("Doesnotexist.mp4", "Doesnotexist", ".mp4")
        $contentBO.GenerateHashIfMissing($content, $null, $filesystemProvider) 

        # Test
        $content.Warnings.Count | Should -Be 2

        # Do
        $filesystemProvider.Dispose()
    }

    It "CopyPropertiesHashAndWarnings" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        $contentA = $contentBO.CreateContentObject("Foo - Bar.mp4", "Foo - Bar", ".mp4")
        $contentA.AlteredBaseName = $false
        $contentA.PendingFilenameUpdate = $false
        $contentA.FrameWidth = 100
        $contentA.FrameHeight = 200
        $contentA.FrameRate = "AString"
        $contentA.BitRate = "AString"
        $contentA.TimeSpan = New-TimeSpan -Hours 1 -Minutes 12
        $contentA.Hash = "ABCDEF"
        $contentA.AddWarning([ContentWarning]::HashLoadingError)


        $contentB = $contentBO.CreateContentObject("Foo - Bar.mp4", "Foo - Bar", ".mp4")

        $contentBO.CopyPropertiesHashAndWarnings($contentA, $contentB) 

        # Test
        $contentB.AlteredBaseName | Should -Be $false
        $contentB.PendingFilenameUpdate | Should -Be $false
        $contentB.FrameWidth | Should -Be 100
        $contentB.FrameHeight | Should -Be 200
        $contentB.FrameRate | Should -Be "AString"
        $contentB.BitRate | Should -Be "AString"
        $contentB.TimeSpan | Should -Be $contentA.TimeSpan
        $contentB.Hash | Should -Be "ABCDEF"
        $contentB.Warnings.Count | Should -Be 1        
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}