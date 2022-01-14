using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Studio.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ContentBO.Class.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
    
    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()
    $config.LockFilenameFormat()

    $contentBO = [ContentBO]::new($config)

    $nullStudio = [Studio]::new()
    $fooStudio = [Studio]::new("Foo", $true, $true)

    $fooStudio.Produced.Add($contentBO.CreateContentObject("Foo.test", "Foo", ".test"))
    $fooStudio.Produced.Add($contentBO.CreateContentObject("Fooish.test", "Fooish", ".test"))
    $fooStudio.Produced.Add($contentBO.CreateContentObject("Bar.test", "Bar", ".test"))
}

Describe "Studio Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullStudio.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooStudio.Name | Should -Be "Foo"
    }

    It "Matching within Produced" {        
        $fooStudio.Produced.Matching("Foo").Count | Should -Be 2
        $fooStudio.Produced.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooStudio.Produced.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Produced" {        
        $fooStudio.Produced.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }

    It "FindByFileName Produced" {
        # Test
        $fooStudio.Produced.GetByFileName("Fooish.test").FileName | Should -Be "Fooish.test"
        $fooStudio.Produced.GetByFileName("Fooish") | Should -BeNullOrEmpty
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}