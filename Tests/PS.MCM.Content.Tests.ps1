using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Actor.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Artist.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "Content Unit Test" -Tag UnitTest {    
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()

        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true)
        $content.TimeSpan = New-TimeSpan -Hours 1 -Minutes 12

        $content.Actors.Add([Actor]::new("Foo"))
        $content.Actors.Add([Actor]::new("Fooish"))
        $content.Actors.Add([Actor]::new("Bar"))

        $content.Artists.Add([Artist]::new("Foo"))
        $content.Artists.Add([Artist]::new("Fooish"))
        $content.Artists.Add([Artist]::new("Bar"))
    }

    It "Constructing" {
        # Test
        $content.Filename | Should -Be "Foo.test"
        $content.Basename | Should -Be "Foo"
        $content.Extension | Should -Be ".test"
    }

    It "Matching Actors" {
        # Test
        $content.Actors.Matching("Foo").Count | Should -Be 2
        $content.Actors.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $content.Actors.Matching("Foo")[0].Name | Should -Be "Foo"
    }

    It "Sorting Actors" {        
        $content.Actors.SortedBy("Name")[0].Name | Should -Be "Bar"
    }

    It "FindByName Actors" {
        # Test
        $content.Actors.GetByName("Foo").Name | Should -Be "Foo"
        $content.Actors.GetByName("foo") | Should -BeNullOrEmpty
    }

    It "Matching Artists" {
        # Test
        $content.Artists.Matching("Foo").Count | Should -Be 2
        $content.Artists.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $content.Artists.Matching("Foo")[0].Name | Should -Be "Foo"
    }

    It "Sorting Artists" {        
        $content.Artists.SortedBy("Name")[0].Name | Should -Be "Bar"
    }

    It "FindByName Artists" {
        # Test
        $content.Artists.GetByName("Foo").Name | Should -Be "Foo"
        $content.Artists.GetByName("foo") | Should -BeNullOrEmpty
    }

    It "Timespan & Duration accessor" {
        # Do
        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true)
        $content.TimeSpan = New-TimeSpan -Hours 1 -Minutes 12

        # Test
        $content.TimeSpan.TotalMilliseconds | Should -Be 4320000
        $content.Duration | Should -Be "01:12:00"
    }

    It "Add Warnings" {
        # Do
        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true)
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::NonCompliantFilename)

        # Test
        $content.Warnings | Should -Be @([ContentWarning]::PropertyInfoLoadingError, [ContentWarning]::NonCompliantFilename)
    }

    It "Remove Warning" {
        # Do
        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true)
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::NonCompliantFilename)
        $content.ClearWarning([ContentWarning]::PropertyInfoLoadingError)

        # Test
        $content.Warnings | Should -Be @([ContentWarning]::NonCompliantFilename)
    }

    It "Clear Warnings" {
        # Do
        [Content] $content = [Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true)
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
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