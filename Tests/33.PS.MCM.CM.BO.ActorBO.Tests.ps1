using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ActorBO.Class.psm1
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
    $config.ConfigureForStructuredFiles(@([FilenameElement]::Actors))
    $config.LockFilenameFormat()
}

Describe "ActorBO Unit Test" -Tag UnitTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Constructing" {
        # Test
        {$actorBO = [ActorBO]::new($config); $actorBO} | Should -Not -Throw

        # Do
        $invalidConfig = [ContentModelConfig]::new()
        $invalidConfig.ConfigureForStructuredFiles(@([FilenameElement]::Actors))

        # Test
        {$actorBO = [ActorBO]::new($invalidConfig); $actorBO} | Should -Throw
    }

    It "ActsOnType" {
        # Do
        $actorBO = [ActorBO]::new($config)

        # Test
        $actorBO.ActsOnType().Name | Should -Be "Actor"
    }

    It "ActsOnFilenameElement" {
        # Do
        $actorBO = [ActorBO]::new($config)

        # Test
        $actorBO.ActsOnFilenameElement() -eq [FilenameElement]::Actors | Should -Be $true
    }

    It "ReplaceSubjectLinkedToContent" {
        # Do
        $actorBO = [ActorBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)
        $content.Actors.Add([Actor]::new("Apple"))
        $content.Actors.Add([Actor]::new("Banana"))
        $content.Actors.Add([Actor]::new("Cherry"))

        $replacementActor = [Actor]::new("Date")
        $incorrectType = [Artist]::new("Kiwi")

        # Do
        $actorBO.ReplaceSubjectLinkedToContent($content, $content.Actors[1], $incorrectType)

        # Test
        $content.Actors[0].Name | Should -Be "Apple"
        $content.Actors[1].Name | Should -Be "Banana"
        $content.Actors[2].Name | Should -Be "Cherry"

        # Do
        $actorBO.ReplaceSubjectLinkedToContent($content, $content.Actors[1], $replacementActor)

        # Test
        $content.Actors[0].Name | Should -Be "Apple"
        $content.Actors[1].Name | Should -Be "Date"
        $content.Actors[2].Name | Should -Be "Cherry"
    }

    It "ReplaceActorLinkedWithContent" {
        # Do
        $actorBO = [ActorBO]::new($config)

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)
        $content.Actors.Add([Actor]::new("Apple"))
        $content.Actors.Add([Actor]::new("Banana"))
        $content.Actors.Add([Actor]::new("Cherry"))

        $replacementActor = [Actor]::new("Date")

        # Do
        $actorBO.ReplaceActorLinkedWithContent($content, $content.Actors[1], $replacementActor)

        # Test
        $content.Actors[0].Name | Should -Be "Apple"
        $content.Actors[1].Name | Should -Be "Date"
        $content.Actors[2].Name | Should -Be "Cherry"

        # Do
        $actorBO.ReplaceActorLinkedWithContent($content, $content.Actors[2], $replacementActor)

        # Test
        $content.Actors[0].Name | Should -Be "Apple"
        $content.Actors[1].Name | Should -Be "Date"
        $content.Actors[2].Name | Should -Be "Date"
    }
    It "AddActorRelationshipsWithContent" {
        # Do
        $actorBO = [ActorBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $actorsList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)
        [Content] $content3 = [Content]::new("Content3.test", "Content3", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)
        [Content] $content4 = [Content]::new("Content4.test", "Content4", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)
    
        # Do
        $actorBO.AddActorRelationshipsWithContent($content1, $actorsList, @("Apple", "Banana"))

        # Test
        $actorsList.Count | Should -Be 2
        $actorsList[0].Name | Should -Be "Apple"
        $actorsList[1].Name | Should -Be "Banana"
        $actorsList[0].PerformedIn.Count | Should -Be 1
        $actorsList[1].PerformedIn.Count | Should -Be 1
        $actorsList[0].PerformedIn[0].BaseName | Should -Be "Content1"
        $actorsList[1].PerformedIn[0].BaseName | Should -Be "Content1"
        $content1.Actors.Count | Should -Be 2
        $content1.Actors[0].Name | Should -Be "Apple"
        $content1.Actors[1].Name | Should -Be "Banana"

        # Do
        $actorBO.AddActorRelationshipsWithContent($content2, $actorsList, @("Cherry"))

        # Test
        $actorsList.Count | Should -Be 3
        $actorsList[0].Name | Should -Be "Apple"
        $actorsList[1].Name | Should -Be "Banana"
        $actorsList[2].Name | Should -Be "Cherry"
        $actorsList[0].PerformedIn.Count | Should -Be 1
        $actorsList[1].PerformedIn.Count | Should -Be 1
        $actorsList[2].PerformedIn.Count | Should -Be 1
        $actorsList[0].PerformedIn[0].BaseName | Should -Be "Content1"
        $actorsList[1].PerformedIn[0].BaseName | Should -Be "Content1"
        $actorsList[2].PerformedIn[0].BaseName | Should -Be "Content2"
        $content1.Actors.Count | Should -Be 2
        $content1.Actors[0].Name | Should -Be "Apple"
        $content1.Actors[1].Name | Should -Be "Banana"
        $content2.Actors.Count | Should -Be 1
        $content2.Actors[0].Name | Should -Be "Cherry"

        # Do
        $actorBO.AddActorRelationshipsWithContent($content3, $actorsList, @("Cherry"))

        # Test
        $actorsList.Count | Should -Be 3
        $actorsList[0].Name | Should -Be "Apple"
        $actorsList[1].Name | Should -Be "Banana"
        $actorsList[2].Name | Should -Be "Cherry"
        $actorsList[0].PerformedIn.Count | Should -Be 1
        $actorsList[1].PerformedIn.Count | Should -Be 1
        $actorsList[2].PerformedIn.Count | Should -Be 2
        $actorsList[0].PerformedIn[0].BaseName | Should -Be "Content1"
        $actorsList[1].PerformedIn[0].BaseName | Should -Be "Content1"
        $actorsList[2].PerformedIn[0].BaseName | Should -Be "Content2"
        $actorsList[2].PerformedIn[1].BaseName | Should -Be "Content3"
        $content1.Actors.Count | Should -Be 2
        $content1.Actors[0].Name | Should -Be "Apple"
        $content1.Actors[1].Name | Should -Be "Banana"
        $content2.Actors.Count | Should -Be 1
        $content2.Actors[0].Name | Should -Be "Cherry"
        $content3.Actors.Count | Should -Be 1
        $content3.Actors[0].Name | Should -Be "Cherry"

        # Do
        $actorBO.AddActorRelationshipsWithContent($content4, $actorsList, @("Unknown"))

        # Test
        $actorsList.Count | Should -Be 4
        $actorsList[0].Name | Should -Be "Apple"
        $actorsList[1].Name | Should -Be "Banana"
        $actorsList[2].Name | Should -Be "Cherry"
        $actorsList[3].Name | Should -Be "<Unknown>"
        $actorsList[0].PerformedIn.Count | Should -Be 1
        $actorsList[1].PerformedIn.Count | Should -Be 1
        $actorsList[2].PerformedIn.Count | Should -Be 2
        $actorsList[3].PerformedIn.Count | Should -Be 1
        $actorsList[0].PerformedIn[0].BaseName | Should -Be "Content1"
        $actorsList[1].PerformedIn[0].BaseName | Should -Be "Content1"
        $actorsList[2].PerformedIn[0].BaseName | Should -Be "Content2"
        $actorsList[2].PerformedIn[1].BaseName | Should -Be "Content3"
        $actorsList[3].PerformedIn[0].BaseName | Should -Be "Content4"
        $content1.Actors.Count | Should -Be 2
        $content1.Actors[0].Name | Should -Be "Apple"
        $content1.Actors[1].Name | Should -Be "Banana"
        $content2.Actors.Count | Should -Be 1
        $content2.Actors[0].Name | Should -Be "Cherry"
        $content3.Actors.Count | Should -Be 1
        $content3.Actors[0].Name | Should -Be "Cherry"
        $content4.Actors.Count | Should -Be 1
        $content4.Actors[0].Name | Should -Be "<Unknown>"
    }

    It "RemoveActorRelationshipsWithContentAndCleanup" {
        # Do
        $actorBO = [ActorBO]::new($config)

        [System.Collections.Generic.List[ContentSubjectBase]] $actorsList = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        [Content] $content1 = [Content]::new("Content1.test", "Content1", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)
        [Content] $content2 = [Content]::new("Content2.test", "Content2", ".test", $false, $true, $false, $false, $false, $false, $false, $false, $false)

        $actorBO.AddActorRelationshipsWithContent($content1, $actorsList, @("Apple", "Banana"))
        $actorBO.AddActorRelationshipsWithContent($content2, $actorsList, @("Apple", "Cherry"))

        # Do
        $actorBO.RemoveActorRelationshipsWithContentAndCleanup($actorsList, $content1)

        # Test
        $actorsList.Count | Should -Be 2
        $actorsList[0].Name | Should -Be "Apple"
        $actorsList[1].Name | Should -Be "Cherry"
        $actorsList[0].PerformedIn.Count | Should -Be 1
        $actorsList[1].PerformedIn.Count | Should -Be 1
        $actorsList[0].PerformedIn[0].BaseName | Should -Be "Content2"
        $actorsList[1].PerformedIn[0].BaseName | Should -Be "Content2"

        # Do
        $actorBO.RemoveActorRelationshipsWithContentAndCleanup($actorsList, $content2)

        # Test
        $actorsList.Count | Should -Be 0
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}
