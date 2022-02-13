using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Series.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    $validSeries = [Series]::new("Foo", $true)

    $validSeries.Episodes.Add([Content]::new("Foo.test", "Foo", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validSeries.Episodes.Add([Content]::new("Fooish.test", "Fooish", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))
    $validSeries.Episodes.Add([Content]::new("Bar.test", "Bar", ".test", $true, $true, $true, $true, $true, $true, $true, $true, $true))

    $validSeries.Episodes[0].Title = "Foo"
    $validSeries.Episodes[1].Title = "Fooish"
    $validSeries.Episodes[2].Title = "Bar"

    $validSeries.ProducedBy.Add([Studio]::new("StudioFoo"))
    $validSeries.ProducedBy.Add([Studio]::new("StudioBar"))
}

Describe "Series Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        # Do
        $nullSeries = [Series]::new()

        # Test
        $nullSeries.Name | Should -Be ""
    }

    It "Constructing with single parameters" {
        # Do
        $minAlbum = [Series]::new("Foo")

        # Test
        $minAlbum.Name | Should -Be "Foo"
        $minAlbum.ProducedBy | Should -Be $null
    }

    It "Constructing with all parameters" {
        # Test
        $validSeries.Name | Should -Be "Foo"
    }

    It "Matching within Episodes" {     
        # Test   
        $validSeries.Episodes.Matching("Foo").Count | Should -Be 2
        $validSeries.Episodes.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $validSeries.Episodes.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Episodes" {  
        # Test      
        $validSeries.Episodes.SortedBy("Title")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByFileName Episodes" {
        # Test
        $validSeries.Episodes.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $validSeries.Episodes.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }

    It "Matching within ProducedBy" {     
        # Test   
        $validSeries.ProducedBy.Matching("StudioFoo").Count | Should -Be 1
        $validSeries.ProducedBy.Matching("StudioFoo").GetType() | Should -Be "Studio"
        $validSeries.ProducedBy.Matching("StudioFoo")[0].Name | Should -Be "StudioFoo"
    }

    It "Sorting ProducedBy" {  
        # Test      
        $validSeries.ProducedBy.SortedBy("Name")[0].Name | Should -Be "StudioBar"
    }

    It "FindByFileName ProducedBy" {
        # Test
        $validSeries.ProducedBy.GetByName("StudioBar").Name | Should -Be "StudioBar"
        $validSeries.ProducedBy.GetByName("studiobar") | Should -BeNullOrEmpty
    }

    It "EpisodeCount" {
        # Test
        $validSeries.EpisodeCount | Should -Be 3
    }

    It "ProducedBy" {
        # Test
        $validSeries.ProducedBy.Name | Should -Be @("StudioFoo", "StudioBar")
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}