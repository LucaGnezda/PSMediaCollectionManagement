using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $validActor = [Actor]::new("Foo")

    $validActor.PerformedIn.Add([Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validActor.PerformedIn.Add([Content]::new("Fooish.test", "Fooish", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validActor.PerformedIn.Add([Content]::new("Bar.test", "Bar", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))

    $validActor.PerformedIn[0].Title = "Foo"
    $validActor.PerformedIn[1].Title = "Fooish"
    $validActor.PerformedIn[2].Title = "Bar"
}

Describe "Actor Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        # Do
        $nullActor = [Actor]::new()
        
        # Test
        $nullActor.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        # Test
        $validActor.Name | Should -Be "Foo"
    }

    It "Matching within PerformedIn" { 
        # Test       
        $validActor.PerformedIn.Matching("Foo").Count | Should -Be 2
        $validActor.PerformedIn.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $validActor.PerformedIn.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting PerformedIn" {
        # Test        
        $validActor.PerformedIn.SortedBy("Name")[0].Filename | Should -Be "Bar.test"

        $validActor.PerformedIn
    }

    It "FindByFileName PerformedIn" {
        # Test
        $validActor.PerformedIn.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $validActor.PerformedIn.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }

    It "PerformanceCount" {
        # Test
        $validActor.PerformanceCount | Should -Be 3
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}