using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ArtistBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $config = [ContentModelConfig]::new()
    $config.ConfigureForStructuredFiles(@([FilenameElement]::Artists))
    $config.LockFilenameFormat()
}

Describe "ArtistBO Unit Test" -Tag UnitTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Constructing" {
        # Test
        {$artistBO = [ArtistBO]::new($config); $artistBO} | Should -Not -Throw

        # Do
        $invalidConfig = [ContentModelConfig]::new()
        $invalidConfig.ConfigureForStructuredFiles(@([FilenameElement]::Artists))

        # Test
        {$artistBO = [ArtistBO]::new($invalidConfig); $artistBO} | Should -Throw
    }

    It "ActsOnType" {
        # Do
        $artistBO = [ArtistBO]::new($config)

        # Test
        $artistBO.ActsOnType().Name | Should -Be "Artist"
    }

    It "ActsOnFilenameElement" {
        # Do
        $artistBO = [ArtistBO]::new($config)

        # Test
        $artistBO.ActsOnFilenameElement() -eq [FilenameElement]::Artists | Should -Be $true
    }

    It "ReplaceSubjectLinkedToContent" {
        # Do
        $artistBO = [ArtistBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)
        $content.Artists.Add([Artist]::new("Apple"))
        $content.Artists.Add([Artist]::new("Banana"))
        $content.Artists.Add([Artist]::new("Cherry"))

        $replacementArtist = [Artist]::new("Date")
        $incorrectType = [Actor]::new("Kiwi")

        # Do
        $artistBO.ReplaceSubjectLinkedToContent($content, $content.Artists[1], $incorrectType)

        # Test
        $content.Artists[0].Name | Should -Be "Apple"
        $content.Artists[1].Name | Should -Be "Banana"
        $content.Artists[2].Name | Should -Be "Cherry"

        # Do
        $artistBO.ReplaceSubjectLinkedToContent($content, $content.Artists[1], $replacementArtist)

        # Test
        $content.Artists[0].Name | Should -Be "Apple"
        $content.Artists[1].Name | Should -Be "Date"
        $content.Artists[2].Name | Should -Be "Cherry"
    }

    It "ReplaceArtistLinkedWithContent" {
        # Do
        $artistBO = [ArtistBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)
        $content.Artists.Add([Artist]::new("Apple"))
        $content.Artists.Add([Artist]::new("Banana"))
        $content.Artists.Add([Artist]::new("Cherry"))

        $replacementArtist = [Artist]::new("Date")

        # Do
        $artistBO.ReplaceArtistLinkedWithContent($content, $content.Artists[1], $replacementArtist)

        # Test
        $content.Artists[0].Name | Should -Be "Apple"
        $content.Artists[1].Name | Should -Be "Date"
        $content.Artists[2].Name | Should -Be "Cherry"

        # Do
        $artistBO.ReplaceArtistLinkedWithContent($content, $content.Artists[2], $replacementArtist)

        # Test
        $content.Artists[0].Name | Should -Be "Apple"
        $content.Artists[1].Name | Should -Be "Date"
        $content.Artists[2].Name | Should -Be "Date"
    }
    It "AddArtistRelationshipsWithContent" {
        # Do
        $artistBO = [ArtistBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $artistsList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)
        [Content] $content3 = [Content]::new("Content3.test", "Content3", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)
        [Content] $content4 = [Content]::new("Content4.test", "Content4", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)
    
        # Do
        $artistBO.AddArtistRelationshipsWithContent($content1, $artistsList, @("Apple", "Banana"))

        # Test
        $artistsList.Count | Should -Be 2
        $artistsList[0].Name | Should -Be "Apple"
        $artistsList[1].Name | Should -Be "Banana"
        $artistsList[0].Performed.Count | Should -Be 1
        $artistsList[1].Performed.Count | Should -Be 1
        $artistsList[0].Performed[0].BaseName | Should -Be "Content1"
        $artistsList[1].Performed[0].BaseName | Should -Be "Content1"
        $content1.Artists.Count | Should -Be 2
        $content1.Artists[0].Name | Should -Be "Apple"
        $content1.Artists[1].Name | Should -Be "Banana"

        # Do
        $artistBO.AddArtistRelationshipsWithContent($content2, $artistsList, @("Cherry"))

        # Test
        $artistsList.Count | Should -Be 3
        $artistsList[0].Name | Should -Be "Apple"
        $artistsList[1].Name | Should -Be "Banana"
        $artistsList[2].Name | Should -Be "Cherry"
        $artistsList[0].Performed.Count | Should -Be 1
        $artistsList[1].Performed.Count | Should -Be 1
        $artistsList[2].Performed.Count | Should -Be 1
        $artistsList[0].Performed[0].BaseName | Should -Be "Content1"
        $artistsList[1].Performed[0].BaseName | Should -Be "Content1"
        $artistsList[2].Performed[0].BaseName | Should -Be "Content2"
        $content1.Artists.Count | Should -Be 2
        $content1.Artists[0].Name | Should -Be "Apple"
        $content1.Artists[1].Name | Should -Be "Banana"
        $content2.Artists.Count | Should -Be 1
        $content2.Artists[0].Name | Should -Be "Cherry"

        # Do
        $artistBO.AddArtistRelationshipsWithContent($content3, $artistsList, @("Cherry"))

        # Test
        $artistsList.Count | Should -Be 3
        $artistsList[0].Name | Should -Be "Apple"
        $artistsList[1].Name | Should -Be "Banana"
        $artistsList[2].Name | Should -Be "Cherry"
        $artistsList[0].Performed.Count | Should -Be 1
        $artistsList[1].Performed.Count | Should -Be 1
        $artistsList[2].Performed.Count | Should -Be 2
        $artistsList[0].Performed[0].BaseName | Should -Be "Content1"
        $artistsList[1].Performed[0].BaseName | Should -Be "Content1"
        $artistsList[2].Performed[0].BaseName | Should -Be "Content2"
        $artistsList[2].Performed[1].BaseName | Should -Be "Content3"
        $content1.Artists.Count | Should -Be 2
        $content1.Artists[0].Name | Should -Be "Apple"
        $content1.Artists[1].Name | Should -Be "Banana"
        $content2.Artists.Count | Should -Be 1
        $content2.Artists[0].Name | Should -Be "Cherry"
        $content3.Artists.Count | Should -Be 1
        $content3.Artists[0].Name | Should -Be "Cherry"

        # Do
        $artistBO.AddArtistRelationshipsWithContent($content4, $artistsList, @("Unknown"))

        # Test
        $artistsList.Count | Should -Be 4
        $artistsList[0].Name | Should -Be "Apple"
        $artistsList[1].Name | Should -Be "Banana"
        $artistsList[2].Name | Should -Be "Cherry"
        $artistsList[3].Name | Should -Be "<Unknown>"
        $artistsList[0].Performed.Count | Should -Be 1
        $artistsList[1].Performed.Count | Should -Be 1
        $artistsList[2].Performed.Count | Should -Be 2
        $artistsList[3].Performed.Count | Should -Be 1
        $artistsList[0].Performed[0].BaseName | Should -Be "Content1"
        $artistsList[1].Performed[0].BaseName | Should -Be "Content1"
        $artistsList[2].Performed[0].BaseName | Should -Be "Content2"
        $artistsList[2].Performed[1].BaseName | Should -Be "Content3"
        $artistsList[3].Performed[0].BaseName | Should -Be "Content4"
        $content1.Artists.Count | Should -Be 2
        $content1.Artists[0].Name | Should -Be "Apple"
        $content1.Artists[1].Name | Should -Be "Banana"
        $content2.Artists.Count | Should -Be 1
        $content2.Artists[0].Name | Should -Be "Cherry"
        $content3.Artists.Count | Should -Be 1
        $content3.Artists[0].Name | Should -Be "Cherry"
        $content4.Artists.Count | Should -Be 1
        $content4.Artists[0].Name | Should -Be "<Unknown>"
    }

    It "RemoveArtistRelationshipsWithContentAndCleanup" {
        # Do
        $artistBO = [ArtistBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $artistsList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $false, $false, $true, $false, $false, $false, $false, $false)

        $artistBO.AddArtistRelationshipsWithContent($content1, $artistsList, @("Apple", "Banana"))
        $artistBO.AddArtistRelationshipsWithContent($content2, $artistsList, @("Apple", "Cherry"))

        # Do
        $artistBO.RemoveArtistRelationshipsWithContentAndCleanup($artistsList, $content1)

        # Test
        $artistsList.Count | Should -Be 2
        $artistsList[0].Name | Should -Be "Apple"
        $artistsList[1].Name | Should -Be "Cherry"
        $artistsList[0].Performed.Count | Should -Be 1
        $artistsList[1].Performed.Count | Should -Be 1
        $artistsList[0].Performed[0].BaseName | Should -Be "Content2"
        $artistsList[1].Performed[0].BaseName | Should -Be "Content2"

        # Do
        $artistBO.RemoveArtistRelationshipsWithContentAndCleanup($artistsList, $content2)

        # Test
        $artistsList.Count | Should -Be 0
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}
