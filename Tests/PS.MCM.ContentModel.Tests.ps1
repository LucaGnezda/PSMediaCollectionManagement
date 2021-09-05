using module .\..\PS.MediaContentManagement\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\PS.MediaContentManagement\Using\Types\PS.MCM.Types.psm1
using module .\..\PS.MediaContentManagement\Using\Helpers\PS.MCM.ElementParser.Abstract.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaContentManagement\PS.MediaContentManagement.psm1 -Force

    [ModuleState]::SetTestingState([TestAttribute]::SuppressConsoleOutput)
    [ModuleState]::SetTestingState([TestAttribute]::MockDestructiveActions)
    
}

Describe "ContentModel Integration Test" -Tag IntegrationTest {
    BeforeEach {
        [ModuleState]::ResetMockConsole()
    }
    
    It "Instantiation" {
        # Setup
        $contentModel = New-ContentModel

        # Test
        $contentModel.GetType() | Should -Be "ContentModel"
    }
}

Describe "ContentModel Integration Test - Built Model" -Tag IntegrationTest {
    BeforeAll {
        $contentModelB = New-ContentModel
        $contentModelB.Config.ConfigureForShortFilm()
        $contentModelB.Config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        Set-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
    }

    It "Build From FileSystem" {
        # Test
        $contentModelB.Content.Count | Should -Be 3
        $contentModelB.Studios.Count | Should -Be 2
        $contentModelB.Actors.Count | Should -Be 6
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
        $contentModelB.Actors[$i].Name | Should -Be $expected
    }

    It "Built Model - Actor Relationships" {
        # Test
        $contentModelB.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModelB.Actors[0].PerformedIn[0].Title | Should -Be "Delta"
    }

    It "Built Model - Studio - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModelB.Studios[$i].Name | Should -Be $expected
    }

    It "Built Model - Studio Relationships" {
        # Test
        $contentModelB.Studios[0].Produced.Count | Should -Be 2
        $contentModelB.Studios[0].Produced[0].Title | Should -Be "Delta"
    }

    It "Built Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Bar"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModelB.Content[$i].Title | Should -Be $expected
    }

    It "Built Model - Content Detail" {
        # Test
        $contentModelB.Content[0].FileName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModelB.Content[0].BaseName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModelB.Content[0].Extension | Should -Be ".mp4"
        $contentModelB.Content[0].Warnings | Should -Be @()
        $contentModelB.Content[0].AlteredBaseName | Should -Be $false
        $contentModelB.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModelB.Content[0].Title | Should -Be "Delta"
        $contentModelB.Content[0].FrameWidth | Should -Be "360"
        $contentModelB.Content[0].FrameHeight | Should -Be "360"
        $contentModelB.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModelB.Content[0].BitRate | Should -Be "228kbps"
        $contentModelB.Content[0].Duration | Should -Be "00:00:26"
        $contentModelB.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModelB.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Built Model - Content Relationships" {
        # Test
        $contentModelB.Content[0].Actors.Count | Should -Be 4
        $contentModelB.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModelB.Content[0].ProducedBy.Name | Should -Be "Foo"
    }

    It "Built Model - Actor.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Apple"}
        @{i = 1; expected = "Banana"}
        @{i = 2; expected = "Cherry"}
        @{i = 3; expected = "Ecky"}
        @{i = 4; expected = "Ni"}
        @{i = 5; expected = "Pear"}
    ) {
        # Test
        ($contentModelB.Actors.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Built Model - Studio.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        ($contentModelB.Studios.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Built Model - Content.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Bar"}
        @{i = 1; expected = "Beta"}
        @{i = 2; expected = "Delta"}
    ) {
        # Test
        ($contentModelB.Content.SortedBy("Title"))[$i].Title | Should -Be $expected
    }

    It "Built Model - Actor.Matching - <matcing>" -ForEach @(
        @{matching = "pp"; expected = "Apple"}
    ) {
        # Test
        $contentModelB.Actors.Matching($matching).Name | Should -Be $expected
    }

    It "Built Model - Actor.PerformedIn.Matching " -ForEach @(
        @{matching = "Delta"; expected = "Delta"}
    ) {
        # Test
        $contentModelB.Actors[0].PerformedIn.Matching($matching).Title | Should -Be $expected
    }

    It "Built Model - Studio.Matching - <matcing>" -ForEach @(
        @{matching = "o"; expected = "Foo"}
    ) {
        # Test
        $contentModelB.Studios.Matching($matching).Name | Should -Be $expected
    }

    It "Built Model - Studio.Produced.Matching " -ForEach @(
        @{matching = "Delta"; expected = "Delta"}
    ) {
        # Test
        $contentModelB.Studios[0].Produced.Matching($matching).Title | Should -Be $expected
    }

    It "Built Model - Content.Matching - <matcing>" -ForEach @(
        @{matching = "ar"; expected = "Bar"}
    ) {
        # Test
        $contentModelB.Content.Matching($matching).Title | Should -Be $expected
    }

    It "Built Model - Content.Actors.Matching" -ForEach @(
        @{matching = "Cherry"; expected = "Cherry"}
    ) {
        # Test
        $contentModelB.Content[0].Actors.Matching($matching).Name | Should -Be $expected
    }
}

Describe "ContentModel Integration Test - Rebuilt Model" -Tag IntegrationTest {
    BeforeAll {
        $contentModelB = New-ContentModel
        $contentModelB.Config.ConfigureForShortFilm()
        $contentModelB.Config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        Set-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
        $contentModelB.Rebuild($true, $true)
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
        $contentModelB.Actors[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Actor Relationships" {
        # Test
        $contentModelB.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModelB.Actors[0].PerformedIn[0].Title | Should -Be "Delta"
    }

    It "Rebuilt Model - Studio - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModelB.Studios[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Studio Relationships" {
        # Test
        $contentModelB.Studios[0].Produced.Count | Should -Be 2
        $contentModelB.Studios[0].Produced[0].Title | Should -Be "Delta"
    }

    It "Rebuilt Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Bar"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModelB.Content[$i].Title | Should -Be $expected
    }

    It "Rebuilt Model - Content Detail" {
        # Test
        $contentModelB.Content[0].FileName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModelB.Content[0].BaseName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModelB.Content[0].Extension | Should -Be ".mp4"
        $contentModelB.Content[0].Warnings | Should -Be @()
        $contentModelB.Content[0].AlteredBaseName | Should -Be $false
        $contentModelB.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModelB.Content[0].Title | Should -Be "Delta"
        $contentModelB.Content[0].FrameWidth | Should -Be "360"
        $contentModelB.Content[0].FrameHeight | Should -Be "360"
        $contentModelB.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModelB.Content[0].BitRate | Should -Be "228kbps"
        $contentModelB.Content[0].Duration | Should -Be "00:00:26"
        $contentModelB.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModelB.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Rebuilt Model - Content Relationships" {
        # Test
        $contentModelB.Content[0].Actors.Count | Should -Be 4
        $contentModelB.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModelB.Content[0].ProducedBy.Name | Should -Be "Foo"
    }

    It "Rebuilt Model - Actor.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Apple"}
        @{i = 1; expected = "Banana"}
        @{i = 2; expected = "Cherry"}
        @{i = 3; expected = "Ecky"}
        @{i = 4; expected = "Ni"}
        @{i = 5; expected = "Pear"}
    ) {
        # Test
        ($contentModelB.Actors.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Studio.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        ($contentModelB.Studios.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Rebuilt Model - Content.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Bar"}
        @{i = 1; expected = "Beta"}
        @{i = 2; expected = "Delta"}
    ) {
        # Test
        ($contentModelB.Content.SortedBy("Title"))[$i].Title | Should -Be $expected
    }

    It "Rebuilt Model - Actor.Matching - <matcing>" -ForEach @(
        @{matching = "pp"; expected = "Apple"}
    ) {
        # Test
        $contentModelB.Actors.Matching($matching).Name | Should -Be $expected
    }

    It "Rebuilt Model - Actor.PerformedIn.Matching " -ForEach @(
        @{matching = "Delta"; expected = "Delta"}
    ) {
        # Test
        $contentModelB.Actors[0].PerformedIn.Matching($matching).Title | Should -Be $expected
    }

    It "Rebuilt Model - Studio.Matching - <matcing>" -ForEach @(
        @{matching = "o"; expected = "Foo"}
    ) {
        # Test
        $contentModelB.Studios.Matching($matching).Name | Should -Be $expected
    }

    It "Rebuilt Model - Studio.Produced.Matching " -ForEach @(
        @{matching = "Delta"; expected = "Delta"}
    ) {
        # Test
        $contentModelB.Studios[0].Produced.Matching($matching).Title | Should -Be $expected
    }

    It "Rebuilt Model - Content.Matching - <matcing>" -ForEach @(
        @{matching = "ar"; expected = "Bar"}
    ) {
        # Test
        $contentModelB.Content.Matching($matching).Title | Should -Be $expected
    }

    It "Rebuilt Model - Content.Actors.Matching" -ForEach @(
        @{matching = "Cherry"; expected = "Cherry"}
    ) {
        # Test
        $contentModelB.Content[0].Actors.Matching($matching).Name | Should -Be $expected
    } 
}

Describe "ContentModel Integration Test - Rebuild Adds & Removes" -Tag IntegrationTest {
    BeforeAll {
        $contentModelB = New-ContentModel
        $contentModelB.Config.ConfigureForShortFilm()
        $contentModelB.Config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        Set-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
    }

    It "Rebuild Model" {
        # Test
        $contentModelB.Studios | Should -Be @("Foo", "Zim")

        # Do
        Set-Location $PSScriptRoot\TestData\ContentTestE
        $contentModelB.Rebuild($true, $true)

        # Test
        $contentModelB.Studios | Should -Be @("Foo", "Zim2")
    }
}

Describe "ContentModel Integration Test - Reset" -Tag IntegrationTest {
    BeforeAll {
        $contentModelB = New-ContentModel
        $contentModelB.Config.ConfigureForShortFilm()
        $contentModelB.Config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        Set-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
    }

    It "Reset Model" {
        # Do
        $contentModelB.Reset()

        # Test
        $contentModelB.Content | Should -Be $null
        $contentModelB.Actors | Should -Be $null
        $contentModelB.Studios | Should -Be $null
    }
}

Describe "ContentModel Integration Test - Save & Load Model" -Tag IntegrationTest {
    BeforeAll {
        $contentModelB = New-ContentModel
        $contentModelB.Config.ConfigureForShortFilm()
        $contentModelB.Config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        Set-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)

        Remove-Item -Path ".\Index.test.output.json" -ErrorAction SilentlyContinue
    }

    It "Save Model" {
        # Do
        $contentModelB.SaveIndex(".\Index.test.output.json")

        # Test
        Test-Path ".\Index.test.output.json" -PathType Leaf | Should -Be $true
    }
    
    It "Load Model" {
        # Do
        $contentModelB.LoadIndex(".\Index.test.output.json", $true)

        # Test
        Test-Path ".\Index.test.output.json" -PathType Leaf | Should -Be $true
    }
    
    It "Loaded Model - Actor - <expected>" -ForEach @(
        @{i = 0; expected = "Cherry"}
        @{i = 1; expected = "Apple"}
        @{i = 2; expected = "Banana"}
        @{i = 3; expected = "Pear"}
        @{i = 4; expected = "Ecky"}
        @{i = 5; expected = "Ni"}
    ) {
        # Test
        $contentModelB.Actors[$i].Name | Should -Be $expected
    }

    It "Loaded Model - Actor Relationships" {
        # Test
        $contentModelB.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModelB.Actors[0].PerformedIn[0].Title | Should -Be "Delta"
    }

    It "Loaded Model - Studio - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModelB.Studios[$i].Name | Should -Be $expected
    }

    It "Loaded Model - Studio Relationships" {
        # Test
        $contentModelB.Studios[0].Produced.Count | Should -Be 2
        $contentModelB.Studios[0].Produced[0].Title | Should -Be "Delta"
    }

    It "Loaded Model - Content - <expected>" -ForEach @(
        @{i = 0; expected = "Delta"}
        @{i = 1; expected = "Bar"}
        @{i = 2; expected = "Beta"}
    ) {
        # Test
        $contentModelB.Content[$i].Title | Should -Be $expected
    }

    It "Loaded Model - Content Detail" {
        # Test
        $contentModelB.Content[0].FileName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModelB.Content[0].BaseName | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModelB.Content[0].Extension | Should -Be ".mp4"
        $contentModelB.Content[0].Warnings | Should -Be @()
        $contentModelB.Content[0].AlteredBaseName | Should -Be $false
        $contentModelB.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModelB.Content[0].Title | Should -Be "Delta"
        $contentModelB.Content[0].FrameWidth | Should -Be "360"
        $contentModelB.Content[0].FrameHeight | Should -Be "360"
        $contentModelB.Content[0].FrameRate | Should -Be "30.00 frames/second"
        $contentModelB.Content[0].BitRate | Should -Be "228kbps"
        $contentModelB.Content[0].Duration | Should -Be "00:00:26"
        $contentModelB.Content[0].TimeSpan | Should -Be "00:00:26"
        $contentModelB.Content[0].Hash | Should -Be "B7692D825173283BC3E7A423E283BFE1"
    }

    It "Loaded Model - Content Relationships" {
        # Test
        $contentModelB.Content[0].Actors.Count | Should -Be 4
        $contentModelB.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModelB.Content[0].ProducedBy.Name | Should -Be "Foo"
    }

    It "Loaded Model - Actor.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Apple"}
        @{i = 1; expected = "Banana"}
        @{i = 2; expected = "Cherry"}
        @{i = 3; expected = "Ecky"}
        @{i = 4; expected = "Ni"}
        @{i = 5; expected = "Pear"}
    ) {
        # Test
        ($contentModelB.Actors.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Loaded Model - Studio.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        ($contentModelB.Studios.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Loaded Model - Content.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Bar"}
        @{i = 1; expected = "Beta"}
        @{i = 2; expected = "Delta"}
    ) {
        # Test
        ($contentModelB.Content.SortedBy("Title"))[$i].Title | Should -Be $expected
    }

    It "Loaded Model - Actor.Matching - <matcing>" -ForEach @(
        @{matching = "pp"; expected = "Apple"}
    ) {
        # Test
        $contentModelB.Actors.Matching($matching).Name | Should -Be $expected
    }

    It "Loaded Model - Actor.PerformedIn.Matching " -ForEach @(
        @{matching = "Delta"; expected = "Delta"}
    ) {
        # Test
        $contentModelB.Actors[0].PerformedIn.Matching($matching).Title | Should -Be $expected
    }

    It "Loaded Model - Studio.Matching - <matcing>" -ForEach @(
        @{matching = "o"; expected = "Foo"}
    ) {
        # Test
        $contentModelB.Studios.Matching($matching).Name | Should -Be $expected
    }

    It "Loaded Model - Studio.Produced.Matching " -ForEach @(
        @{matching = "Delta"; expected = "Delta"}
    ) {
        # Test
        $contentModelB.Studios[0].Produced.Matching($matching).Title | Should -Be $expected
    }

    It "Loaded Model - Content.Matching - <matcing>" -ForEach @(
        @{matching = "ar"; expected = "Bar"}
    ) {
        # Test
        $contentModelB.Content.Matching($matching).Title | Should -Be $expected
    }

    It "Loaded Model - Content.Actors.Matching" -ForEach @(
        @{matching = "Cherry"; expected = "Cherry"}
    ) {
        # Test
        $contentModelB.Content[0].Actors.Matching($matching).Name | Should -Be $expected
    } 
}

Describe "ContentModel Integration Test - Model Variant - Series" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelA = New-ContentModel
        $contentModelA.LoadIndex(".\index.test.inputA.json", $true)
    }

    It "Model Variant - Series - <expected>" -ForEach @(
        @{i = 0; expected = "Alpha"}
        @{i = 1; expected = "Beta"}
        @{i = 2; expected = "Gamma"}
    ) {
        # Test
        $contentModelA.Series[$i].Name | Should -Be $expected
    }

    It "Model Variant - Series Relationships" {
        # Test
        $contentModelA.Series[0].Episodes.Count | Should -Be 3
        $contentModelA.Series[0].Episodes[0].Title | Should -Be "Apple"
    }

    It "Model Variant - Series.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Alpha"}
        @{i = 1; expected = "Beta"}
        @{i = 2; expected = "Gamma"}
    ) {
        # Test
        ($contentModelA.Series.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Model Variant - Series.Matching - <matcing>" -ForEach @(
        @{matching = "mm"; expected = "Gamma"}
    ) {
        # Test
        $contentModelA.Series.Matching($matching).Name | Should -Be $expected
    }

    It "Model Variant - Series.Episodes.Matching " -ForEach @(
        @{matching = "Banana"; expected = "Banana"}
    ) {
        # Test
        $contentModelA.Series[0].Episodes.Matching($matching).Title | Should -Be $expected
    }
}

Describe "ContentModel Integration Test - Model Variant - Album" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelB = New-ContentModel
        $contentModelB.LoadIndex(".\index.test.inputB.json", $true)
    }

    It "Model Variant - Album - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        $contentModelB.Albums[$i].Name | Should -Be $expected
    }

    It "Model Variant - Album Relationships" {
        # Test
        $contentModelB.Albums[0].Tracks.Count | Should -Be 2
        $contentModelB.Albums[0].Tracks[0].Title | Should -Be "Delta"
    }

    It "Model Variant - Album.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Foo"}
        @{i = 1; expected = "Zim"}
    ) {
        # Test
        ($contentModelB.Albums.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Model Variant - Album.Matching - <matcing>" -ForEach @(
        @{matching = "z"; expected = "Zim"}
    ) {
        # Test
        $contentModelB.Albums.Matching($matching).Name | Should -Be $expected
    }

    It "Model Variant - Album.Tracks.Matching " -ForEach @(
        @{matching = "Bar"; expected = "Bar"}
    ) {
        # Test
        $contentModelB.Albums[0].Tracks.Matching($matching).Title | Should -Be $expected
    }
}

Describe "ContentModel Integration Test - Model Variant - Artist" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelB = New-ContentModel
        $contentModelB.LoadIndex(".\index.test.inputB.json", $true)
    }

    It "Model Variant - Artist - <expected>" -ForEach @(
        @{i = 0; expected = "Cherry"}
        @{i = 1; expected = "Apple"}
        @{i = 2; expected = "Banana"}
        @{i = 3; expected = "Pear"}
        @{i = 4; expected = "Ecky"}
        @{i = 5; expected = "Ni"}
    ) {
        # Test
        $contentModelB.Artists[$i].Name | Should -Be $expected
    }

    It "Model Variant - Artist Relationships" {
        # Test
        $contentModelB.Artists[0].Performed.Count | Should -Be 2
        $contentModelB.Artists[0].Performed[0].Title | Should -Be "Delta"
    }

    It "Model Variant - Artist.SortedBy - <expected>" -ForEach @(
        @{i = 0; expected = "Apple"}
        @{i = 1; expected = "Banana"}
        @{i = 2; expected = "Cherry"}
        @{i = 3; expected = "Ecky"}
        @{i = 4; expected = "Ni"}
        @{i = 5; expected = "Pear"}
    ) {
        # Test
        ($contentModelB.Artists.SortedBy("Name"))[$i].Name | Should -Be $expected
    }

    It "Model Variant - Artist.Matching - <matcing>" -ForEach @(
        @{matching = "ea"; expected = "Pear"}
    ) {
        # Test
        $contentModelB.Artists.Matching($matching).Name | Should -Be $expected
    }

    It "Model Variant - Artist.Performed.Matching " -ForEach @(
        @{matching = "et"; expected = "Beta"}
    ) {
        # Test
        $contentModelB.Artists[0].Performed.Matching($matching).Title | Should -Be $expected
    }
}

Describe "ContentModel Integration Test - Model Variant - SeasonEpisode" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelB = New-ContentModel
        $contentModelB.LoadIndex(".\index.test.inputC.json", $true)
    }

    It "Model Variant - Season - <expected>" -ForEach @(
        @{i = 0; expected = 1}
        @{i = 1; expected = 2}
        @{i = 2; expected = 3}
        @{i = 3; expected = 4}
        @{i = 4; expected = $null}
    ) {
        # Test
        $contentModelB.Content[$i].Season | Should -Be $expected
    }

    It "Model Variant - Episode - <expected>" -ForEach @(
        @{i = 0; expected = 5}
        @{i = 1; expected = 6}
        @{i = 2; expected = 7}
        @{i = 3; expected = 8}
        @{i = 4; expected = $null}
    ) {
        # Test
        $contentModelB.Content[$i].Episode | Should -Be $expected
    }

    It "Model Variant - SeasonEpisode - <expected>" -ForEach @(
        @{i = 0; expected = "01x05"}
        @{i = 1; expected = "2X6"}
        @{i = 2; expected = "s03e07"}
        @{i = 3; expected = "s4e8"}
        @{i = 4; expected = ""}
    ) {
        # Test
        $contentModelB.Content[$i].SeasonEpisode | Should -BeExactly $expected
    }
}

Describe "ContentModel Integration Test - Model Variant - Track" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelB = New-ContentModel
        $contentModelB.LoadIndex(".\index.test.inputD.json", $true)
    }

    It "Model Variant - Track - <expected>" -ForEach @(
        @{i = 0; expected = 1}
        @{i = 1; expected = 2}
        @{i = 2; expected = 3}
        @{i = 3; expected = 4}
        @{i = 4; expected = $null}
    ) {
        # Test
        $contentModelB.Content[$i].Track | Should -Be $expected
    }

    It "Model Variant - TrackLabel - <expected>" -ForEach @(
        @{i = 0; expected = "01"}
        @{i = 1; expected = "2"}
        @{i = 2; expected = "003"}
        @{i = 3; expected = "4"}
        @{i = 4; expected = ""}
    ) {
        # Test
        $contentModelB.Content[$i].TrackLabel | Should -BeExactly $expected
    }
}

Describe "ContentModel Integration Test - Model Variant - Year" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelB = New-ContentModel
        $contentModelB.LoadIndex(".\index.test.inputE.json", $true)
    }

    It "Model Variant - Year - <expected>" -ForEach @(
        @{i = 0; expected = 1929}
        @{i = 1; expected = 84}
        @{i = 2; expected = 2021}
        @{i = 3; expected = $null}
        @{i = 4; expected = $null}
    ) {
        # Test
        $contentModelB.Content[$i].Year | Should -Be $expected
    }
}

Describe "ContentModel Integration Test - Model Variant - Studio with Series" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelA = New-ContentModel
        $contentModelA.LoadIndex(".\index.test.inputF.json", $true)
    }

    It "Model Variant - Core Model" {
        # Test
        $contentModelA.Content[0].Basename | Should -Be "StuA - SerA - 1x01 - Apple"
        $contentModelA.Content[1].Basename | Should -Be "StuA - SerA - 1x02 - Banana"
        $contentModelA.Content[2].Basename | Should -Be "StuB - SerA - 2x01 - Cherry"
        $contentModelA.Content[3].Basename | Should -Be "StuB - SerB - 1x01 - Pear"
        $contentModelA.Content[4].Basename | Should -Be "StuC - SerC - 1x01 - Kiwi"
        $contentModelA.Studios[0].Name | Should -Be "StuA"
        $contentModelA.Studios[1].Name | Should -Be "StuB"
        $contentModelA.Studios[2].Name | Should -Be "StuC"
        $contentModelA.Series[0].Name | Should -Be "SerA"
        $contentModelA.Series[1].Name | Should -Be "SerB"
        $contentModelA.Series[2].Name | Should -Be "SerC"
    }

    It "Model Variant - Cross Relationships" {
        # Test
        $contentModelA.Series[0].ProducedBy[0].Name | Should -Be "StuA"
        $contentModelA.Series[0].ProducedBy[1].Name | Should -Be "StuB"
        $contentModelA.Series[1].ProducedBy[0].Name | Should -Be "StuB"
        $contentModelA.Series[2].ProducedBy[0].Name | Should -Be "StuC"
        $contentModelA.Studios[0].ProducedSeries[0].Name | Should -Be "SerA"
        $contentModelA.Studios[1].ProducedSeries[0].Name | Should -Be "SerA"
        $contentModelA.Studios[1].ProducedSeries[1].Name | Should -Be "SerB"
        $contentModelA.Studios[2].ProducedSeries[0].Name | Should -Be "SerC"
    }
}

Describe "ContentModel Integration Test - Model Variant - Studio with Albums" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelA = New-ContentModel
        $contentModelA.LoadIndex(".\index.test.inputG.json", $true)
    }

    It "Model Variant - Core Model" {
        # Test
        $contentModelA.Content[0].Basename | Should -Be "StuA - AlbA - 01 - Apple"
        $contentModelA.Content[1].Basename | Should -Be "StuA - AlbA - 02 - Banana"
        $contentModelA.Content[2].Basename | Should -Be "StuB - AlbA - 03 - Cherry"
        $contentModelA.Content[3].Basename | Should -Be "StuB - AlbB - 01 - Pear"
        $contentModelA.Content[4].Basename | Should -Be "StuC - AlbC - 01 - Kiwi"
        $contentModelA.Studios[0].Name | Should -Be "StuA"
        $contentModelA.Studios[1].Name | Should -Be "StuB"
        $contentModelA.Studios[2].Name | Should -Be "StuC"
        $contentModelA.Albums[0].Name | Should -Be "AlbA"
        $contentModelA.Albums[1].Name | Should -Be "AlbB"
        $contentModelA.Albums[2].Name | Should -Be "AlbC"
    }

    It "Model Variant - Cross Relationships" {
        # Test
        $contentModelA.Albums[0].ProducedBy[0].Name | Should -Be "StuA"
        $contentModelA.Albums[0].ProducedBy[1].Name | Should -Be "StuB"
        $contentModelA.Albums[1].ProducedBy[0].Name | Should -Be "StuB"
        $contentModelA.Albums[2].ProducedBy[0].Name | Should -Be "StuC"
        $contentModelA.Studios[0].ProducedAlbums[0].Name | Should -Be "AlbA"
        $contentModelA.Studios[1].ProducedAlbums[0].Name | Should -Be "AlbA"
        $contentModelA.Studios[1].ProducedAlbums[1].Name | Should -Be "AlbB"
        $contentModelA.Studios[2].ProducedAlbums[0].Name | Should -Be "AlbC"
    }
}

Describe "ContentModel Integration Test - Remodel Filename Format" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)
    }

    It "Remodel" {
        # Test
        $contentModelC.Content[0].Basename | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModelC.RemodelFilenameFormat(-1,1) | Should -Be $false 
        $contentModelC.RemodelFilenameFormat(4,1) | Should -Be $false
        $contentModelC.RemodelFilenameFormat(1,-1) | Should -Be $false 
        $contentModelC.RemodelFilenameFormat(1,4) | Should -Be $false 

        # Do
        $contentModelC.RemodelFilenameFormat(1,2) | Should -Be $true

        # Test
        $contentModelC.Content[0].Basename | Should -Be "Foo - Delta - Cherry, Apple, Banana, Pear"

    }
}

Describe "ContentModel Integration Test - Alter Model - Actor, Studio" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)
        $contentModelD = New-ContentModel
        $contentModelD.LoadIndex(".\index.test.inputB.json", $true)
    }

    It "Alter Actor" {
        # Test 
        $contentModelC.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Do + Test
        $contentModelC.AlterActor("Apple", "Alice") | Should -Be $true
        $contentModelC.Actors | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModelC.Actors.Matching("Alice").PerformedIn.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterActor("Banana", "Bob") | Should -Be $true
        $contentModelC.Actors | Should -Be @("Cherry", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModelC.Actors.Matching("Bob").PerformedIn.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterActor("Cherry", "Charlie") | Should -Be $true
        $contentModelC.Actors | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModelC.Actors.Matching("Charlie").PerformedIn.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterActor("Ecky", "Alice") | Should -Be $true
        $contentModelC.Actors | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModelC.Actors.Matching("Alice").PerformedIn.Count | Should -Be 3

        # Do + Test
        $contentModelC.AlterActor("Missing", "Alice") | Should -Be $false
        $contentModelC.Actors | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModelC.Actors.Matching("Alice").PerformedIn.Count | Should -Be 3
        $contentModelC.Actors.Matching("Missing") | Should -Be $null
    }

    It "Alter Actor - Colision" {
        # Test 
        $contentModelD.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
        
        # Do + Test
        $contentModelD.AlterActor("Cherry2", "Cherry") | Should -Be $false
        $contentModelD.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
    }

    It "Alter Studio" {
        # Test 
        $contentModelC.Studios | Should -Be @("Foo", "Zim")
        
        # Do + Test
        $contentModelC.AlterStudio("Foo", "Studio A") | Should -Be $true
        $contentModelC.Studios | Should -Be @("Studio A", "Zim")
        $contentModelC.Studios.Matching("Studio A").Produced.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterStudio("Missing", "Studio B") | Should -Be $false
        $contentModelC.Studios | Should -Be @("Studio A", "Zim")
        $contentModelC.Studios.Matching("Studio B") | Should -Be $null
    }

    It "Alter Studio - Colision" {
        # Test 
        $contentModelD.Studios | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
        
        # Do + Test
        $contentModelD.AlterStudio("Zim2", "Zim") | Should -Be $false
        $contentModelD.Studios | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
    }
}

Describe "ContentModel Integration Test - Alter Model - Series" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputC.json", $true)
        $contentModelD = New-ContentModel
        $contentModelD.LoadIndex(".\index.test.inputD.json", $true)
    }

    It "Alter Series" {
        # Test 
        $contentModelC.Series | Should -Be @("Foo", "Zim")
        
        # Do + Test
        $contentModelC.AlterSeries("Foo", "Series A") | Should -Be $true
        $contentModelC.Series | Should -Be @("Series A", "Zim")
        $contentModelC.Series.Matching("Series A").Episodes.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterSeries("Missing", "Series B") | Should -Be $false
        $contentModelC.Series | Should -Be @("Series A", "Zim")
        $contentModelC.Series.Matching("Series B") | Should -Be $null
    }

    It "Alter Series - Colision" {
        # Test 
        $contentModelD.Series | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
        
        # Do + Test
        $contentModelD.AlterSeries("Zim2", "Zim") | Should -Be $false
        $contentModelD.Series | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
    }
}

Describe "ContentModel Integration Test - Alter Model - Artist, Album" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputE.json", $true)
        $contentModelD = New-ContentModel
        $contentModelD.LoadIndex(".\index.test.inputF.json", $true)
    }

    It "Alter Artist" {
        # Test 
        $contentModelC.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Do + Test
        $contentModelC.AlterArtist("Apple", "Alice") | Should -Be $true
        $contentModelC.Artists | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModelC.Artists.Matching("Alice").Performed.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterArtist("Banana", "Bob") | Should -Be $true
        $contentModelC.Artists | Should -Be @("Cherry", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModelC.Artists.Matching("Bob").Performed.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterArtist("Cherry", "Charlie") | Should -Be $true
        $contentModelC.Artists | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModelC.Artists.Matching("Charlie").Performed.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterArtist("Ecky", "Alice") | Should -Be $true
        $contentModelC.Artists | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModelC.Artists.Matching("Alice").Performed.Count | Should -Be 3

        # Do + Test
        $contentModelC.AlterArtist("Missing", "Alice") | Should -Be $false
        $contentModelC.Artists | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModelC.Artists.Matching("Alice").Performed.Count | Should -Be 3
        $contentModelC.Artists.Matching("Missing") | Should -Be $null
    }

    It "Alter Artist - Colision" {
        # Test 
        $contentModelD.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
        
        # Do + Test
        $contentModelD.AlterArtist("Cherry2", "Cherry") | Should -Be $false
        $contentModelD.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
    }

    It "Alter Album" {
        # Test 
        $contentModelC.Albums | Should -Be @("Foo", "Zim")
        
        # Do + Test
        $contentModelC.AlterAlbum("Foo", "Studio A") | Should -Be $true
        $contentModelC.Albums | Should -Be @("Studio A", "Zim")
        $contentModelC.Albums.Matching("Studio A").Tracks.Count | Should -Be 2

        # Do + Test
        $contentModelC.AlterAlbum("Missing", "Studio B") | Should -Be $false
        $contentModelC.Albums | Should -Be @("Studio A", "Zim")
        $contentModelC.Albums.Matching("Studio B") | Should -Be $null
    }

    It "Alter Album - Colision" {
        # Test 
        $contentModelD.Albums | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
        
        # Do + Test
        $contentModelD.AlterAlbum("Zim2", "Zim") | Should -Be $false
        $contentModelD.Albums | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
    }
}

Describe "ContentModel Integration Test - Alter Model - SeasonEpisode" -Tag IntegrationTest {
    BeforeEach {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelA = New-ContentModel
        $contentModelA.LoadIndex(".\index.test.inputC.json", $true)
    }

    It "Alter SeasonEpisode - Initial" {
        # Test
        $contentModelA.Content[0].Season | Should -Be 1
        $contentModelA.Content[1].Season | Should -Be 2
        $contentModelA.Content[2].Season | Should -Be 3
        $contentModelA.Content[3].Season | Should -Be 4
        $contentModelA.Content[4].Season | Should -Be $null
        $contentModelA.Content[0].Episode | Should -Be 5
        $contentModelA.Content[1].Episode | Should -Be 6
        $contentModelA.Content[2].Episode | Should -Be 7
        $contentModelA.Content[3].Episode | Should -Be 8
        $contentModelA.Content[4].Episode | Should -Be $null
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - 01x05"
        $contentModelA.Content[1].Basename | Should -BeExactly "Foo - Banana - 2X6"
        $contentModelA.Content[2].Basename | Should -BeExactly "Foo - Cherry - s03e07"
        $contentModelA.Content[3].Basename | Should -BeExactly "Foo - Pear - s4e8"
        $contentModelA.Content[4].Basename | Should -BeExactly "Foo - Zim - Unknown"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $false
        $contentModelA.Content[1].AlteredBaseName | Should -Be $false
        $contentModelA.Content[2].AlteredBaseName | Should -Be $false
        $contentModelA.Content[3].AlteredBaseName | Should -Be $false
        $contentModelA.Content[4].AlteredBaseName | Should -Be $false
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[1].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[2].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[3].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[4].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[0].SeasonEpisode | Should -BeExactly "01x05"
        $contentModelA.Content[1].SeasonEpisode | Should -BeExactly "2X6"
        $contentModelA.Content[2].SeasonEpisode | Should -BeExactly "s03e07"
        $contentModelA.Content[3].SeasonEpisode | Should -BeExactly "s4e8"
        $contentModelA.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to S0E0 no padding" {
        # Test
        $contentModelA.AlterSeasonEpisodeFormat(0, 0, [SeasonEpisodePattern]::Uppercase_S0E0, $false) | Should -Be $true
        $contentModelA.Content[0].Season | Should -Be 1
        $contentModelA.Content[0].Episode | Should -Be 5
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - S1E5"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $true
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModelA.Content[0].SeasonEpisode | Should -BeExactly "S1E5"
        $contentModelA.Content[1].SeasonEpisode | Should -BeExactly "S2E6"
        $contentModelA.Content[2].SeasonEpisode | Should -BeExactly "S3E7"
        $contentModelA.Content[3].SeasonEpisode | Should -BeExactly "S4E8"
        $contentModelA.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to s0s0 padding s2" {
        # Test
        $contentModelA.AlterSeasonEpisodeFormat(2, 0, [SeasonEpisodePattern]::Lowercase_S0E0, $false) | Should -Be $true
        $contentModelA.Content[0].Season | Should -Be 1
        $contentModelA.Content[0].Episode | Should -Be 5
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - s01e5"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $true
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModelA.Content[0].SeasonEpisode | Should -BeExactly "s01e5"
        $contentModelA.Content[1].SeasonEpisode | Should -BeExactly "s02e6"
        $contentModelA.Content[2].SeasonEpisode | Should -BeExactly "s03e7"
        $contentModelA.Content[3].SeasonEpisode | Should -BeExactly "s04e8"
        $contentModelA.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to 0X0 padding e2" {
        # Test
        $contentModelA.AlterSeasonEpisodeFormat(0, 2, [SeasonEpisodePattern]::Uppercase_0X0, $false) | Should -Be $true
        $contentModelA.Content[0].Season | Should -Be 1
        $contentModelA.Content[0].Episode | Should -Be 5
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - 1X05"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $true
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModelA.Content[0].SeasonEpisode | Should -BeExactly "1X05"
        $contentModelA.Content[1].SeasonEpisode | Should -BeExactly "2X06"
        $contentModelA.Content[2].SeasonEpisode | Should -BeExactly "3X07"
        $contentModelA.Content[3].SeasonEpisode | Should -BeExactly "4X08"
        $contentModelA.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to 0x0 padding s3 e2" {
        # Test
        $contentModelA.AlterSeasonEpisodeFormat(3, 2, [SeasonEpisodePattern]::Lowercase_0X0, $false) | Should -Be $true
        $contentModelA.Content[0].Season | Should -Be 1
        $contentModelA.Content[0].Episode | Should -Be 5
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - 001x05"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $true
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModelA.Content[0].SeasonEpisode | Should -BeExactly "001x05"
        $contentModelA.Content[1].SeasonEpisode | Should -BeExactly "002x06"
        $contentModelA.Content[2].SeasonEpisode | Should -BeExactly "003x07"
        $contentModelA.Content[3].SeasonEpisode | Should -BeExactly "004x08"
        $contentModelA.Content[4].SeasonEpisode | Should -BeExactly ""
    }
}

Describe "ContentModel Integration Test - Alter Model - Track" -Tag IntegrationTest {
    BeforeEach {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelA = New-ContentModel
        $contentModelA.LoadIndex(".\index.test.inputD.json", $true)
    }

    It "Alter Track - Initial" {
        # Test
        $contentModelA.Content[0].Track | Should -Be 1
        $contentModelA.Content[1].Track | Should -Be 2
        $contentModelA.Content[2].Track | Should -Be 3
        $contentModelA.Content[3].Track | Should -Be 4
        $contentModelA.Content[4].Track | Should -Be $null
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - 01"
        $contentModelA.Content[1].Basename | Should -BeExactly "Foo - Banana - 2"
        $contentModelA.Content[2].Basename | Should -BeExactly "Foo - Cherry - 003"
        $contentModelA.Content[3].Basename | Should -BeExactly "Foo - Pear - 4"
        $contentModelA.Content[4].Basename | Should -BeExactly "Foo - Zim - Unknown"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $false
        $contentModelA.Content[1].AlteredBaseName | Should -Be $false
        $contentModelA.Content[2].AlteredBaseName | Should -Be $false
        $contentModelA.Content[3].AlteredBaseName | Should -Be $false
        $contentModelA.Content[4].AlteredBaseName | Should -Be $false
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[1].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[2].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[3].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[4].PendingFilenameUpdate | Should -Be $false
        $contentModelA.Content[0].TrackLabel | Should -BeExactly "01"
        $contentModelA.Content[1].TrackLabel | Should -BeExactly "2"
        $contentModelA.Content[2].TrackLabel | Should -BeExactly "003"
        $contentModelA.Content[3].TrackLabel | Should -BeExactly "4"
        $contentModelA.Content[4].TrackLabel | Should -BeExactly ""
    }

    It "Alter Track - Alter to no padding" {
        # Test
        $contentModelA.AlterTrackFormat(0, $false) | Should -Be $true
        $contentModelA.Content[0].Track | Should -Be 1
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - 1"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $true
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModelA.Content[0].TrackLabel | Should -BeExactly "1"
        $contentModelA.Content[1].TrackLabel | Should -BeExactly "2"
        $contentModelA.Content[2].TrackLabel | Should -BeExactly "3"
        $contentModelA.Content[3].TrackLabel | Should -BeExactly "4"
        $contentModelA.Content[4].TrackLabel | Should -BeExactly ""
    }

    It "Alter Track - Alter to padding 2" {
        # Test
        $contentModelA.AlterTrackFormat(3, $false) | Should -Be $true
        $contentModelA.Content[0].Track | Should -Be 1
        $contentModelA.Content[0].Basename | Should -BeExactly "Foo - Apple - 001"
        $contentModelA.Content[0].AlteredBaseName | Should -Be $true
        $contentModelA.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModelA.Content[0].TrackLabel | Should -BeExactly "001"
        $contentModelA.Content[1].TrackLabel | Should -BeExactly "002"
        $contentModelA.Content[2].TrackLabel | Should -BeExactly "003"
        $contentModelA.Content[3].TrackLabel | Should -BeExactly "004"
        $contentModelA.Content[4].TrackLabel | Should -BeExactly ""
    }
}

Describe "ContentModel Integration Test - Alter Model - Studio Series cross reference" -Tag IntegrationTest {
    BeforeEach {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelA = New-ContentModel
        $contentModelA.LoadIndex(".\index.test.inputF.json", $true)
    }

    It "Alter Studio" {
        # Test
        $contentModelA.AlterStudio("StuB", "StuA") | Should -Be $true
        $contentModelA.Studios[0].Name | Should -Be "StuA"
        $contentModelA.Studios[1].Name | Should -Be "StuC"
        $contentModelA.Studios[0].ProducedSeries[0] | Should -Be "SerA"
        $contentModelA.Studios[0].ProducedSeries[1] | Should -Be "SerB"
        $contentModelA.Studios[1].ProducedSeries[0] | Should -Be "SerC"
        $contentModelA.Series[0].ProducedBy[0] | Should -Be "StuA"
        $contentModelA.Series[1].ProducedBy[0] | Should -Be "StuA"
        $contentModelA.Series[2].ProducedBy[0] | Should -Be "StuC"
    }

    It "Alter Series" {
        # Test
        $contentModelA.AlterSeries("SerA", "SerB") | Should -Be $true
        $contentModelA.Series[0].Name | Should -Be "SerB"
        $contentModelA.Series[1].Name | Should -Be "SerC"
        $contentModelA.Studios[0].ProducedSeries[0] | Should -Be "SerB"
        $contentModelA.Studios[1].ProducedSeries[0] | Should -Be "SerB"
        $contentModelA.Studios[2].ProducedSeries[0] | Should -Be "SerC"
        $contentModelA.Series[0].ProducedBy[0] | Should -Be "StuB"
        $contentModelA.Series[0].ProducedBy[1] | Should -Be "StuA"
        $contentModelA.Series[1].ProducedBy[0] | Should -Be "StuC"
    }
}

Describe "ContentModel Integration Test - Alter Model - Studio Album cross reference" -Tag IntegrationTest {
    BeforeEach {
        Set-Location $PSScriptRoot\TestData\ContentTestF
        $contentModelA = New-ContentModel
        $contentModelA.LoadIndex(".\index.test.inputG.json", $true)
    }

    It "Alter Studio" {
        # Test
        $contentModelA.AlterStudio("StuB", "StuA") | Should -Be $true
        $contentModelA.Studios[0].Name | Should -Be "StuA"
        $contentModelA.Studios[1].Name | Should -Be "StuC"
        $contentModelA.Studios[0].ProducedAlbums[0] | Should -Be "AlbA"
        $contentModelA.Studios[0].ProducedAlbums[1] | Should -Be "AlbB"
        $contentModelA.Studios[1].ProducedAlbums[0] | Should -Be "AlbC"
        $contentModelA.Albums[0].ProducedBy[0] | Should -Be "StuA"
        $contentModelA.Albums[1].ProducedBy[0] | Should -Be "StuA"
        $contentModelA.Albums[2].ProducedBy[0] | Should -Be "StuC"
    }

    It "Alter Album" {
        # Test
        $contentModelA.AlterAlbum("AlbA", "AlbB") | Should -Be $true
        $contentModelA.Albums[0].Name | Should -Be "AlbB"
        $contentModelA.Albums[1].Name | Should -Be "AlbC"
        $contentModelA.Studios[0].ProducedAlbums[0] | Should -Be "AlbB"
        $contentModelA.Studios[1].ProducedAlbums[0] | Should -Be "AlbB"
        $contentModelA.Studios[2].ProducedAlbums[0] | Should -Be "AlbC"
        $contentModelA.Albums[0].ProducedBy[0] | Should -Be "StuB"
        $contentModelA.Albums[0].ProducedBy[1] | Should -Be "StuA"
        $contentModelA.Albums[1].ProducedBy[0] | Should -Be "StuC"
    }
}

Describe "ContentModel Integration Test - Remove Content" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)
        $contentModelD = New-ContentModel
        $contentModelD.LoadIndex(".\index.test.inputB.json", $true)
    }
    
    It "Remove Content" {
        # Test
        $contentModelC.Content.Count | Should -Be 3

        # Do 
        $contentModelC.RemoveContentFromModel("Foo - Cherry, Apple, Banana, Pear - Delta.mp4")
        
        # Test
        $contentModelC.Content.Count | Should -Be 2
    }
}

Describe "ContentModel Integration Test - Analyse Model" -Tag IntegrationTest {
    BeforeAll {
        $contentModelC = New-ContentModel
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)

        $contentModelD = New-ContentModel
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelD.LoadIndex(".\index.test.inputB.json", $true)
    }

    It "Analyse Actors" {
        $contentModelC.AnalyseActorsForPossibleLabellingIssues($true) | Should -Be @(6, 0, 0, 0, 0, 6)
    }

    It "Analyse Studios" {
        $contentModelC.AnalyseStudiosForPossibleLabellingIssues($true) | Should -Be @(2, 0, 0, 0, 0, 2)
    }

    It "Summary" {
        $contentModelc.Summary() # Nothing to test, other than it doesn't error
    }
}

Describe "ContentModel Integration Test - Spellcheck Titles" -Tag IntegrationTest {
    BeforeAll {
        $contentModel = New-ContentModel
        Set-Location $PSScriptRoot\TestData\ContentTestG
        $contentModel.LoadIndex(".\index.test.inputA.json", $true)
    }

    It "Spellcheck" {
        $results = $contentModel.SpellcheckContentTitles($true)
        $results.Count | Should -Be 9
        $results.Contains("cat") | Should -Be $true
        $results["cat"].IsCorrect | Should -Be $true
        $results.Contains("Ths") | Should -Be $true
        $results["Ths"].IsCorrect | Should -Be $false
        $results["Ths"].Suggestions | Should -Contain "This"
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ModuleState]::ClearTestingStates()
}