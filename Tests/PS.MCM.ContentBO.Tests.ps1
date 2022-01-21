using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ContentBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\FileSystemProvider.Class.psm1    

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "ContentBO Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()

        $config = [ContentModelConfig]::new()  
    }
    
    It "Constructing non compliant content" {
        # Do
        $config.ConfigureForSeries()
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("Non.test", "Non", ".test")

        # Test
        $content.FileName | Should -Be "Non.test"
        $content.BaseName | Should -Be "Non"
        $content.Extension | Should -Be ".test"
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename, [ContentWarning]::SubjectInfoSkipped)
        $content.AlteredBaseName | Should -Be $false
        $content.PendingFilenameUpdate | Should -Be $false
        $content.Title | Should -BeNullOrEmpty
        $content.FrameWidth | Should -Be $null
        $content.FrameHeight | Should -Be $null
        $content.FrameRate | Should -BeNullOrEmpty
        $content.BitRate | Should -BeNullOrEmpty
        $content.Duration | Should -BeNullOrEmpty
        $content.TimeSpan | Should -Be $null
        $content.Hash | Should -BeNullOrEmpty
        $content.Actors | Should -Be $null
        $content.Artists | Should -Be $null
        $content.ProducedBy | Should -Be $null
    }

    It "Constructing compliant content" {
        # Do
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)
        $content = $contentBO.CreateContentObject("Foo.mp4", "Foo", ".mp4")

        # Test
        $content.FileName | Should -Be "Foo.mp4"
        $content.BaseName | Should -Be "Foo"
        $content.Extension | Should -Be ".mp4"
        $content.Warnings | Should -Be @()
        $content.AlteredBaseName | Should -Be $false
        $content.PendingFilenameUpdate | Should -Be $false
        $content.Title | Should -Be "Foo"
        $content.FrameWidth | Should -Be $null
        $content.FrameHeight | Should -Be $null
        $content.FrameRate | Should -BeNullOrEmpty
        $content.BitRate | Should -BeNullOrEmpty
        $content.Duration | Should -BeNullOrEmpty
        $content.TimeSpan | Should -Be $null
        $content.Hash | Should -BeNullOrEmpty
        $content.Actors.Count | Should -Be 0
        $content.Artists.Count | Should -Be 0
        $content.ProducedBy | Should -Be $null
    }

    It "ToString" {
        # Do
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
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
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
        $config.LockFilenameFormat()
        [ContentBO] $contentBO = [ContentBO]::new($config)
        
        # Test
        $contentBO.SeasonEpisodeToString($season, $episode, $padSeason, $padEpisode, $pattern) | Should -BeExactly $expected
    }

    It "Update Content Basename" {
        # Do
        $config.ConfigureForSeries()
        $config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Title, [FilenameElement]::Actors))
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        $content = $contentBO.CreateContentObject("A - Bar - C.mp4", "A - Bar - C", ".mp4")
        $content.ProducedBy = [Studio]::new("Ecky")
        $content.Actors.Add([Actor]::new("Anne"))
        $content.Actors.Add([Actor]::new("Bob"))
        $content.Actors.Add([Actor]::new("Charlie"))

        $contentBO.UpdateContentBaseName($content)

        # Test
        $content.BaseName | Should -Be "Ecky - Bar - Anne, Bob, Charlie"

        # TODO
    }

    It "Update Content Filename" {
        # Do
        Set-Location $PSScriptRoot\TestData\ContentTestD
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
    }

    It "Update Content Filename - File Clash" {
        # Do
        Set-Location $PSScriptRoot\TestData\ContentTestD
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
    }

    It "Fill Properties" {
        # Do
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        $content = $contentBO.CreateContentObject("Foo - Bar.mp4", "Foo - Bar", ".mp4")
        Set-Location $PSScriptRoot\TestData\ContentTestA

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", $config.IncludedExtensions, $false)

        $contentBO.FillPropertiesWhereMissing($content, $null, $filesystemProvider) 

        # Test
        $content.FrameWidth | Should -Be 320
        $content.FrameHeight | Should -Be 240
        $content.FrameRate | Should -Be "30.00 frames/second"
        $content.BitRate | Should -Be "375kbps"

        # Do
        $filesystemProvider.Dispose()
    }

    It "Generate Hash" {
        # Do
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        $content = $contentBO.CreateContentObject("Foo - Bar.mp4", "Foo - Bar", ".mp4")
        Set-Location $PSScriptRoot\TestData\ContentTestA

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", $config.IncludedExtensions, $false)

        $contentBO.GenerateHashIfMissing($content, $null, $filesystemProvider) 

        # Test
        $content.Hash | Should -Be "88F292963ED23DA5F9C522CBF5075637"

        # Do
        $filesystemProvider.Dispose()
    }

    It "Check Hash" {
        # Do
        $config.LockFilenameFormat()
        $contentBO = [ContentBO]::new($config)

        $content = $contentBO.CreateContentObject("Foo - Bar.mp4", "Foo - Bar", ".mp4")
        Set-Location $PSScriptRoot\TestData\ContentTestA

        [FilesystemProvider] $filesystemProvider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", $config.IncludedExtensions, $false)

        $content.Hash = "88F292963ED23DA5F9C522CBF5075637"

        # Test
        $filesystemProvider.CheckFilesystemHash($content.Hash, $content.FileName) | Should -Be $true

        # Do
        $content.Hash = "88F292963ED23DA5F9C522CBF5075630"

        # Test
        $filesystemProvider.CheckFilesystemHash($content.Hash, $content.FileName) | Should -Be $false

        # Do
        $filesystemProvider.Dispose()
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}