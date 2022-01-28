using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1

BeforeAll {     
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
    
}


Describe "ContentModel.SaveIndex ContentModel.LoadIndex Integration Test" -Tag IntegrationTest {
    BeforeEach {
        $contentModel = New-ContentModel
        $contentModel.Config.ConfigureForStructuredFiles(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $contentModel.Config.OverrideIncludedExtensions(@(".mp4", ".wmv", ".mkv"))
    }

    It "Save and load, with path, collect on load" {
        # Do
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestB", $false, $false)
        Remove-Item -Path "$PSScriptRoot\TestData\ContentTestB\Index.test.output.json" -ErrorAction SilentlyContinue
        $contentModel.SaveIndex("$PSScriptRoot\TestData\ContentTestB\Index.test.output.json", $false)
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestB\Index.test.output.json", "$PSScriptRoot\TestData\ContentTestB\", $true)

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

        # Test
        $contentModel.Actors[0].Name | Should -Be "Cherry"
        $contentModel.Actors[1].Name | Should -Be "Apple"
        $contentModel.Actors[2].Name | Should -Be "Banana"
        $contentModel.Actors[3].Name | Should -Be "Pear"
        $contentModel.Actors[4].Name | Should -Be "Ecky"
        $contentModel.Actors[5].Name | Should -Be "Ni"

        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"

        # Studio
        $contentModel.Studios[0].Name | Should -Be "Foo"
        $contentModel.Studios[1].Name | Should -Be "Zim"

        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"

        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"

    }

    It "Save and load, with path, collect on save" {
        # Do
        $contentModel.Build("$PSScriptRoot\TestData\ContentTestB", $false, $false)
        Remove-Item -Path "$PSScriptRoot\TestData\ContentTestB\Index.test.output.json" -ErrorAction SilentlyContinue
        $contentModel.SaveIndex("$PSScriptRoot\TestData\ContentTestB\Index.test.output.json", "$PSScriptRoot\TestData\ContentTestB\", $true)
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestB\Index.test.output.json", $false)

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

        # Test
        $contentModel.Actors[0].Name | Should -Be "Cherry"
        $contentModel.Actors[1].Name | Should -Be "Apple"
        $contentModel.Actors[2].Name | Should -Be "Banana"
        $contentModel.Actors[3].Name | Should -Be "Pear"
        $contentModel.Actors[4].Name | Should -Be "Ecky"
        $contentModel.Actors[5].Name | Should -Be "Ni"

        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"

        # Studio
        $contentModel.Studios[0].Name | Should -Be "Foo"
        $contentModel.Studios[1].Name | Should -Be "Zim"

        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"

        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"

    }

    It "Save and load, no params" {
        # Do
        Push-Location "$PSScriptRoot\TestData\ContentTestB"
        $contentModel.Build($true, $true)
        Remove-Item -Path "index.json" -ErrorAction SilentlyContinue
        $contentModel.SaveIndex()
        $contentModel.LoadIndex()
        Remove-Item -Path "index.json" -ErrorAction SilentlyContinue
        Pop-Location

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

        # Test
        $contentModel.Actors[0].Name | Should -Be "Cherry"
        $contentModel.Actors[1].Name | Should -Be "Apple"
        $contentModel.Actors[2].Name | Should -Be "Banana"
        $contentModel.Actors[3].Name | Should -Be "Pear"
        $contentModel.Actors[4].Name | Should -Be "Ecky"
        $contentModel.Actors[5].Name | Should -Be "Ni"

        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"

        # Studio
        $contentModel.Studios[0].Name | Should -Be "Foo"
        $contentModel.Studios[1].Name | Should -Be "Zim"

        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"

        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"

    }

    It "Save and load, current path, with collect" {
        # Do
        Push-Location "$PSScriptRoot\TestData\ContentTestB"
        $contentModel.Build($true, $true)
        Remove-Item -Path "index.json" -ErrorAction SilentlyContinue
        $contentModel.SaveIndex($true)
        $contentModel.LoadIndex($true)
        Remove-Item -Path "index.json" -ErrorAction SilentlyContinue
        Pop-Location

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

        # Test
        $contentModel.Actors[0].Name | Should -Be "Cherry"
        $contentModel.Actors[1].Name | Should -Be "Apple"
        $contentModel.Actors[2].Name | Should -Be "Banana"
        $contentModel.Actors[3].Name | Should -Be "Pear"
        $contentModel.Actors[4].Name | Should -Be "Ecky"
        $contentModel.Actors[5].Name | Should -Be "Ni"

        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"

        # Studio
        $contentModel.Studios[0].Name | Should -Be "Foo"
        $contentModel.Studios[1].Name | Should -Be "Zim"

        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"

        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"

    }

    It "Save and load, path, without collect" {
        # Do
        Push-Location "$PSScriptRoot\TestData\ContentTestB"
        $contentModel.Build($true, $true)
        Remove-Item -Path "$PSScriptRoot\TestData\ContentTestB\Index.test.output.json" -ErrorAction SilentlyContinue
        $contentModel.SaveIndex("$PSScriptRoot\TestData\ContentTestB\Index.test.output.json")
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestB\Index.test.output.json")
        Pop-Location

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

        # Test
        $contentModel.Actors[0].Name | Should -Be "Cherry"
        $contentModel.Actors[1].Name | Should -Be "Apple"
        $contentModel.Actors[2].Name | Should -Be "Banana"
        $contentModel.Actors[3].Name | Should -Be "Pear"
        $contentModel.Actors[4].Name | Should -Be "Ecky"
        $contentModel.Actors[5].Name | Should -Be "Ni"

        # Test
        $contentModel.Actors[0].PerformedIn.Count | Should -Be 2
        $contentModel.Actors[0].PerformedIn[0].Title | Should -Be "Delta"

        # Studio
        $contentModel.Studios[0].Name | Should -Be "Foo"
        $contentModel.Studios[1].Name | Should -Be "Zim"

        # Test
        $contentModel.Studios[0].Produced.Count | Should -Be 2
        $contentModel.Studios[0].Produced[0].Title | Should -Be "Delta"

        # Test
        $contentModel.Content[0].Actors.Count | Should -Be 4
        $contentModel.Content[0].Actors[0].Name | Should -Be "Cherry"
        $contentModel.Content[0].ProducedBy.Name | Should -Be "Foo"

    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}