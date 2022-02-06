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
        # $validActor.PerformedIn.SortedBy("Name")[0].Filename | Should -Be "Bar.test"

        Write-Host $validActor.PerformedIn
        Write-Host $validActor.PerformedIn.SortedBy("Title")
        Write-Host $validActor._Content
        Write-Host $validActor._Content.SortedBy("Name")
        Write-Host ($validActor._Content | Sort-Object "Name")
        Write-Host ($validActor._Content | Sort-Object "Name")[0]
        Write-Host ($validActor._Content | Sort-Object "Name")[1]
        Write-Host ($validActor._Content | Sort-Object "Name")[2]
        Write-Host ($validActor._Content[0].Name)
        Write-Host ($validActor._Content[1].Name)
        Write-Host ($validActor._Content[2].Name)
        
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