using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $validArtist = [Artist]::new("Foo")

    $validArtist.Performed.Add([Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validArtist.Performed.Add([Content]::new("Fooish.test", "Fooish", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validArtist.Performed.Add([Content]::new("Bar.test", "Bar", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))

    $validArtist.Performed[0].Title = "Foo"
    $validArtist.Performed[1].Title = "Fooish"
    $validArtist.Performed[2].Title = "Bar"
}

Describe "Artist Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        # Do
        $nullArtist = [Artist]::new()
        
        # Test
        $nullArtist.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        # Test
        $validArtist.Name | Should -Be "Foo"
    }

    It "Matching within Performed" { 
        # Test       
        $validArtist.Performed.Matching("Foo").Count | Should -Be 2
        $validArtist.Performed.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $validArtist.Performed.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Performed" {
        # Test        
        $validArtist.Performed.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByFileName Performed" {
        # Test
        $validArtist.Performed.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $validArtist.Performed.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }

    It "PerformanceCount" {
        # Test
        $validArtist.PerformanceCount | Should -Be 3
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}