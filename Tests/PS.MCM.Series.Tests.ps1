using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Series.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1


BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
    
    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()

    $nullSeries = [Series]::new()
    $fooSeries = [Series]::new("Foo", $true)
    $fooSeries.Episodes.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooSeries.Episodes.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooSeries.Episodes.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Series Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullSeries.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooSeries.Name | Should -Be "Foo"
    }

    It "Matching within Tracks" {        
        $fooSeries.Episodes.Matching("Foo").Count | Should -Be 2
        $fooSeries.Episodes.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooSeries.Episodes.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Tracks" {        
        $fooSeries.Episodes.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByFileName Episodes" {
        # Test
        $fooSeries.Episodes.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $fooSeries.Episodes.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}