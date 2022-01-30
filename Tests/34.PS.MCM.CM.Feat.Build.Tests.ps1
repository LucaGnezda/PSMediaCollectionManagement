using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
    
}

Describe "ContentModel.Build Integration Test (Series, Actors, Title)" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Series, [FilenameElement]::Actors, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestB", $true, $true)
    }

    It "Build From FileSystem" {
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Series.Count | Should -Be 2
        $contentModel.Actors.Count | Should -Be 6
    }

    It "Built Model - Actor - <expected>" -ForEach @(
        @{i = 0; expected = "Cherry"}
        @{i = 1; expected = "Apple"}
        @{i = 2; expected = "Banana"}
        @{i = 3; expected = "Pear"}
        @{i = 4; expected = "Ecky"}
        @{i = 5; expected = "Ni"}
    ) {
        # Test
        $contentModel.Actors[$i].Name | Should -Be $expected
    }

    It "Built Model - Actor Relationships" {
        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"
    }

    It "Built Model - Series - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModel.Series[$i].Name | Should -Be $expected
    }

    It "Built Model - Series Relationships" {
        # Test
        $contentModel.Series[0].Episodes.Count | Should -Be 2
        $contentModel.Series[0].Episodes[0].Title | Should -Be "Delta"
    }

    It "Built Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Bar"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModel.Content[$i].Title | Should -Be $expected
    }

    It "Built Model - Content Detail" {
        # Test
        $contentModel.Content[0].FileName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModel.Content[0].BaseName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModel.Content[0].Extension | Should -Be ".mp4"
        $contentModel.Content[0].Warnings | Should -Be @()
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].Title | Should -Be "Delta"
        $contentModel.Content[0].FrameWidth | Should -Be "360"
        $contentModel.Content[0].FrameHeight | Should -Be "360"
        $contentModel.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModel.Content[0].BitRate | Should -Be "228kbps"
        $contentModel.Content[0].Duration | Should -Be "00:00:26"
        $contentModel.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModel.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Built Model - Content Relationships" {
        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].FromSeries.Name | Should -Be "Foo"
    }
}

Describe "ContentModel.Build Integration Test (Album, Artists, Title)" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Album, [FilenameElement]::Artists, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestB", $true, $true)
    }

    It "Build From FileSystem" {
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Albums.Count | Should -Be 2
        $contentModel.Artists.Count | Should -Be 6
    }

    It "Built Model - Artists - <expected>" -ForEach @(
        @{i = 0; expected = "Cherry"}
        @{i = 1; expected = "Apple"}
        @{i = 2; expected = "Banana"}
        @{i = 3; expected = "Pear"}
        @{i = 4; expected = "Ecky"}
        @{i = 5; expected = "Ni"}
    ) {
        # Test
        $contentModel.Artists[$i].Name | Should -Be $expected
    }

    It "Built Model - Artists Relationships" {
        # Test
        $contentModel.Artists[0].Performed.Count | Should -Be 2
        $contentModel.Artists[0].Performed[0].Title | Should -Be "Delta"
    }

    It "Built Model - Album - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModel.Albums[$i].Name | Should -Be $expected
    }

    It "Built Model - Album Relationships" {
        # Test
        $contentModel.Albums[0].Tracks.Count | Should -Be 2
        $contentModel.Albums[0].Tracks[0].Title | Should -Be "Delta"
    }

    It "Built Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Bar"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModel.Content[$i].Title | Should -Be $expected
    }

    It "Built Model - Content Detail" {
        # Test
        $contentModel.Content[0].FileName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModel.Content[0].BaseName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModel.Content[0].Extension | Should -Be ".mp4"
        $contentModel.Content[0].Warnings | Should -Be @()
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].Title | Should -Be "Delta"
        $contentModel.Content[0].FrameWidth | Should -Be "360"
        $contentModel.Content[0].FrameHeight | Should -Be "360"
        $contentModel.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModel.Content[0].BitRate | Should -Be "228kbps"
        $contentModel.Content[0].Duration | Should -Be "00:00:26"
        $contentModel.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModel.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Built Model - Content Relationships" {
        # Test
        $contentModel.Content[0].Artists.Count | Should -Be 4
        $contentModel.Content[0].Artists[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].OnAlbum.Name | Should -Be "Foo"
    }
}

Describe "ContentModel.Build Integration Test (Studio, Series, Title)" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Studio, [FilenameElement]::Series, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestH", $true, $true)
    }

    It "Build From FileSystem" {
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Series.Count | Should -Be 2
    }

    It "Built Model - Series - <expected>" -ForEach @(
        @{i = 0; expected = "Bar"}
        @{i = 1; expected = "Ecky"}
    ) {
        # Test
        $contentModel.Series[$i].Name | Should -Be $expected
    }

    It "Built Model - Series Relationships" {
        # Test
        $contentModel.Series[0].Episodes.Count | Should -Be 2
        $contentModel.Series[0].Episodes[0].Title | Should -Be "Delta"
    }

    It "Built Model - Studio - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModel.Studios[$i].Name | Should -Be $expected
    }

    It "Built Model - Studio Relationships" {
        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"
    }

    It "Built Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Ni"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModel.Content[$i].Title | Should -Be $expected
    }

    It "Built Model - Content Detail" {
        # Test
        $contentModel.Content[0].FileName | Should -Be "Foo - Bar - Delta.mp4"
        $contentModel.Content[0].BaseName | Should -Be "Foo - Bar - Delta"
        $contentModel.Content[0].Extension | Should -Be ".mp4"
        $contentModel.Content[0].Warnings | Should -Be @()
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].Title | Should -Be "Delta"
        $contentModel.Content[0].FrameWidth | Should -Be "360"
        $contentModel.Content[0].FrameHeight | Should -Be "360"
        $contentModel.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModel.Content[0].BitRate | Should -Be "228kbps"
        $contentModel.Content[0].Duration | Should -Be "00:00:26"
        $contentModel.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModel.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Built Model - Content Relationships" {
        # Test
        $contentModel.Content[0].FromSeries.Name | Should -Be "Bar"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"
    }

    It "Built Model - Series Studio Cross Relationships" {
        # Test
        $contentModel.Series[0].ProducedBy[0].Name | Should -Be "Foo"
        $contentModel.Studios[0].ProducedSeries[0].Name | Should -Be "Bar"
    }
}

Describe "ContentModel.Build Integration Test (Studio, Album, Title)" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Studio, [FilenameElement]::Album, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestH", $true, $true)
    }

    It "Build From FileSystem" {
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Albums.Count | Should -Be 2
    }

    It "Built Model - Albums - <expected>" -ForEach @(
        @{i = 0; expected = "Bar"}
        @{i = 1; expected = "Ecky"}
    ) {
        # Test
        $contentModel.Albums[$i].Name | Should -Be $expected
    }

    It "Built Model - Albums Relationships" {
        # Test
        $contentModel.Albums[0].Tracks.Count | Should -Be 2
        $contentModel.Albums[0].Tracks[0].Title | Should -Be "Delta"
    }

    It "Built Model - Studio - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModel.Studios[$i].Name | Should -Be $expected
    }

    It "Built Model - Studio Relationships" {
        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"
    }

    It "Built Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Ni"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModel.Content[$i].Title | Should -Be $expected
    }

    It "Built Model - Content Detail" {
        # Test
        $contentModel.Content[0].FileName | Should -Be "Foo - Bar - Delta.mp4"
        $contentModel.Content[0].BaseName | Should -Be "Foo - Bar - Delta"
        $contentModel.Content[0].Extension | Should -Be ".mp4"
        $contentModel.Content[0].Warnings | Should -Be @()
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].Title | Should -Be "Delta"
        $contentModel.Content[0].FrameWidth | Should -Be "360"
        $contentModel.Content[0].FrameHeight | Should -Be "360"
        $contentModel.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModel.Content[0].BitRate | Should -Be "228kbps"
        $contentModel.Content[0].Duration | Should -Be "00:00:26"
        $contentModel.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModel.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Built Model - Content Relationships" {
        # Test
        $contentModel.Content[0].OnAlbum.Name | Should -Be "Bar"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"
    }

    It "Built Model - Series Studio Cross Relationships" {
        # Test
        $contentModel.Albums[0].ProducedBy[0].Name | Should -Be "Foo"
        $contentModel.Studios[0].ProducedAlbums[0].Name | Should -Be "Bar"
    }
}

Describe "ContentModel.Build Integration Test (Minimal params)" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Studio, [FilenameElement]::Album, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
    }

    It "Build no params" {
        # Do
        Push-Location "$PSScriptRoot\TestData\ContentTestH"
        $contentModel.Build()
        Pop-Location
        
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Albums.Count | Should -Be 2
    }

    It "Build path only" {
        # Do
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestH")
        
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Albums.Count | Should -Be 2
    }
}

Describe "ContentModel.Rebuild Integration Test (Studio, Actors, Title)" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestB", $true, $true)
        $contentModel.Rebuild("$PSScriptRoot\TestData\ContentTestB", $true, $true)
    }

    It "Rebuild From FileSystem" {
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Actors.Count | Should -Be 6
    }

    It "Rebuilt Model - Actor - <expected>" -ForEach @(
        @{i = 0; expected = "Cherry"}
        @{i = 1; expected = "Apple"}
        @{i = 2; expected = "Banana"}
        @{i = 3; expected = "Pear"}
        @{i = 4; expected = "Ecky"}
        @{i = 5; expected = "Ni"}
    ) {
        # Test
        $contentModel.Actors[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Actor Relationships" {
        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"
    }

    It "Rebuilt Model - Studios - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModel.Studios[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Studios Relationships" {
        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"
    }

    It "Rebuilt Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Bar"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModel.Content[$i].Title | Should -Be $expected
    }

    It "Rebuilt Model - Content Detail" {
        # Test
        $contentModel.Content[0].FileName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModel.Content[0].BaseName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModel.Content[0].Extension | Should -Be ".mp4"
        $contentModel.Content[0].Warnings | Should -Be @()
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].Title | Should -Be "Delta"
        $contentModel.Content[0].FrameWidth | Should -Be "360"
        $contentModel.Content[0].FrameHeight | Should -Be "360"
        $contentModel.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModel.Content[0].BitRate | Should -Be "228kbps"
        $contentModel.Content[0].Duration | Should -Be "00:00:26"
        $contentModel.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModel.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Rebuilt Model - Content Relationships" {
        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"
    }
}

Describe "ContentModel.Rebuild Integration Test (Studio, Actors, Title) with changes" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestB", $true, $true)
        $contentModel.Rebuild("$PSScriptRoot\TestData\ContentTestE", $true, $true)
    }

    It "Rebuild From FileSystem" {
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Actors.Count | Should -Be 6
    }

    It "Rebuilt Model - Actor - <expected>" -ForEach @(
        @{i = 0; expected = "Cherry"}
        @{i = 1; expected = "Apple"}
        @{i = 2; expected = "Banana"}
        @{i = 3; expected = "Pear"}
        @{i = 4; expected = "Ecky"}
        @{i = 5; expected = "Ni"}
    ) {
        # Test
        $contentModel.Actors[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Actor Relationships" {
        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"
    }

    It "Rebuilt Model - Studios - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim2"}
    ) {
        # Test
        $contentModel.Studios[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Studios Relationships" {
        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"
    }

    It "Rebuilt Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Bar"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModel.Content[$i].Title | Should -Be $expected
    }

    It "Rebuilt Model - Content Detail" {
        # Test
        $contentModel.Content[0].FileName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModel.Content[0].BaseName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModel.Content[0].Extension | Should -Be ".mp4"
        $contentModel.Content[0].Warnings | Should -Be @()
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].Title | Should -Be "Delta"
        $contentModel.Content[0].FrameWidth | Should -Be "360"
        $contentModel.Content[0].FrameHeight | Should -Be "360"
        $contentModel.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModel.Content[0].BitRate | Should -Be "228kbps"
        $contentModel.Content[0].Duration | Should -Be "00:00:26"
        $contentModel.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModel.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Rebuilt Model - Content Relationships" {
        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"
    }
}

Describe "ContentModel.Build Integration Test (Minimal params)" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Studio, [FilenameElement]::Album, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
    }

    It "Rebuild no params" {
        # Do
        Push-Location "$PSScriptRoot\TestData\ContentTestH"
        $contentModel.Build()
        $contentModel.Rebuild()
        Pop-Location
        
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Albums.Count | Should -Be 2
    }

    It "Rebuild bolleans only" {
        # Do
        Push-Location "$PSScriptRoot\TestData\ContentTestH"
        $contentModel.Build()
        $contentModel.Rebuild($false, $false)
        Pop-Location
        
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Albums.Count | Should -Be 2
    }

    It "Rebuild path only" {
        # Do
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestH")
        $contentModel.Rebuild("$PSScriptRoot\TestData\ContentTestH")
        
        # Test
        $contentModel.Content.Count | Should -Be 3
        $contentModel.Studios.Count | Should -Be 2
        $contentModel.Albums.Count | Should -Be 2
    }
}

Describe "ContentModel.RemoveContentFromModel Integration Test" -Tag IntegrationTest {    
    It "Remove Content - Actor, Studio, Does not exist" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        # Test
        $contentModel.Content.Count | Should -Be 3

        # Do 
        $contentModel.RemoveContentFromModel("Foo - Cherry, Apple, Banana, Pear - Delta.mp4")
        
        # Test
        $contentModel.Content.Count | Should -Be 2

        # Do 
        $contentModel.RemoveContentFromModel("Doesnotexist.mp4")
        
        # Test
        $contentModel.Content.Count | Should -Be 2
    }

    It "Remove Content - Actor, Series" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputC.json", $true)

        # Test
        $contentModel.Content.Count | Should -Be 3

        # Do 
        $contentModel.RemoveContentFromModel("Foo - Cherry, Apple, Banana, Pear - Delta.mp4")
        
        # Test
        $contentModel.Content.Count | Should -Be 2
    }

    It "Remove Content - Artist, Album" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)

        # Test
        $contentModel.Content.Count | Should -Be 3

        # Do 
        $contentModel.RemoveContentFromModel("Foo - Cherry, Apple, Banana, Pear - Delta.mp4")
        
        # Test
        $contentModel.Content.Count | Should -Be 2
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}