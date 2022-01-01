using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1


BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "Content Unit Test" -Tag UnitTest {    
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
        $config = [ContentModelConfig]::new()  
        $config.ConfigureForShortFilm()
    }

    It "Constructing non compliant content" {
        # Do
        $content = [Content]::new("Non.test", "Non", ".test", $config)

        # Test
        $content.FileName | Should -Be "Non.test"
        $content.BaseName | Should -Be "Non"
        $content.Extension | Should -Be ".test"
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename, [ContentWarning]::PartialLoad)
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
        $content = [Content]::new("Foo - Bar.mp4", "Foo - Bar", ".mp4", $config)

        # Test
        $content.FileName | Should -Be "Foo - Bar.mp4"
        $content.BaseName | Should -Be "Foo - Bar"
        $content.Extension | Should -Be ".mp4"
        $content.Warnings | Should -Be @()
        $content.AlteredBaseName | Should -Be $false
        $content.PendingFilenameUpdate | Should -Be $false
        $content.Title | Should -Be "Bar"
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
        $content = [Content]::new("Foo - Bar.mp4", "Foo - Bar", ".mp4", $config)

        # Test
        $content.ToString() | Should -Be "Bar"
    }

    It "Update Content Basename" {
        # Do
        $config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Title, [FilenameElement]::Actors))
        $content = [Content]::new("A - Bar - C.mp4", "A - Bar - C", ".mp4", $config)
        $content.ProducedBy = [Studio]::new("Ecky")
        $content.Actors.Add([Actor]::new("Anne"))
        $content.Actors.Add([Actor]::new("Bob"))
        $content.Actors.Add([Actor]::new("Charlie"))
        $content.UpdateContentBaseName()

        # Test
        $content.BaseName | Should -Be "Ecky - Bar - Anne, Bob, Charlie"

        # TODO
    }

    It "Update Content Filename" {
        # Do
        Set-Location $PSScriptRoot\TestData\ContentTestD
        $config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $content = [Content]::new("Foo - Cherry, Apple, Banana, Pear - Delta.mp4", "Foo - Cherry, Apple, Banana, Pear - Delta", ".mp4", $config)
        $content.ProducedBy = [Studio]::new("Ecky")
        $content.Actors.Add([Actor]::new("Cherry"))
        $content.Actors.Add([Actor]::new("Apple"))
        $content.Actors.Add([Actor]::new("Banana"))
        $content.Actors.Add([Actor]::new("Pear"))
        $content.AlteredBaseName = $true
        $content.PendingFilenameUpdate = $true
        $content.UpdateContentBaseName()
        
        # Test
        $content.UpdateFileName() | Should -Be $true
    }

    It "Update Content Filename - File Clash" {
        # Do
        Set-Location $PSScriptRoot\TestData\ContentTestD
        $config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        $content = [Content]::new("Foo - Cherry, Apple, Banana, Pear - Delta.mp4", "Foo - Cherry, Apple, Banana, Pear - Delta", ".mp4", $config)
        $content.ProducedBy = [Studio]::new("Foo")
        $content.Actors.Add([Actor]::new("Cherry2"))
        $content.Actors.Add([Actor]::new("Apple"))
        $content.Actors.Add([Actor]::new("Banana"))
        $content.Actors.Add([Actor]::new("Pear"))
        $content.AlteredBaseName = $true
        $content.PendingFilenameUpdate = $true
        $content.UpdateContentBaseName()
        
        # Test
        $content.UpdateFileName() | Should -Be $false
    }

    It "Fill Properties" {
        # Do
        $content = [Content]::new("Foo - Bar.mp4", "Foo - Bar", ".mp4", $config)
        Set-Location $PSScriptRoot\TestData\ContentTestA
        $content.FillPropertiesWhereMissing() 

        # Test
        $content.FrameWidth | Should -Be 320
        $content.FrameHeight | Should -Be 240
        $content.FrameRate | Should -Be "30.00 frames/second"
        $content.BitRate | Should -Be "375kbps"
    }

    It "Generate Hash" {
        # Do
        $content = [Content]::new("Foo - Bar.mp4", "Foo - Bar", ".mp4", $config)
        Set-Location $PSScriptRoot\TestData\ContentTestA
        $content.GenerateHashIfMissing() 

        # Test
        $content.Hash | Should -Be "88F292963ED23DA5F9C522CBF5075637"
    }

    It "Check Hash" {
        # Do
        $content = [Content]::new("Foo - Bar.mp4", "Foo - Bar", ".mp4", $config)
        Set-Location $PSScriptRoot\TestData\ContentTestA
        $content.Hash = "88F292963ED23DA5F9C522CBF5075637"

        # Test
        $content.CheckFilesystemHash() | Should -Be $true

        # Do
        $content.Hash = "88F292963ED23DA5F9C522CBF5075630"

        # Test
        $content.CheckFilesystemHash() | Should -Be $false
    }

    It "Add Warnings" {
        # Do
        $content = [Content]::new("Foo - Bar.mp4", "Foo - Bar", ".mp4", $config)
        $content.AddWarning([ContentWarning]::ErrorLoadingProperties)
        $content.AddWarning([ContentWarning]::ErrorLoadingProperties)
        $content.AddWarning([ContentWarning]::NonCompliantFilename)

        # Test
        $content.Warnings | Should -Be @([ContentWarning]::ErrorLoadingProperties, [ContentWarning]::NonCompliantFilename)
    }

    It "Clear Warnings" {
        # Do
        $content = [Content]::new("Foo - Bar.mp4", "Foo - Bar", ".mp4", $config)
        $content.AddWarning([ContentWarning]::ErrorLoadingProperties)
        $content.AddWarning([ContentWarning]::ErrorLoadingProperties)
        $content.AddWarning([ContentWarning]::NonCompliantFilename)
        $content.ClearWarnings()

        # Test
        $content.Warnings | Should -Be @()
    }

    
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}