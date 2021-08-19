using module .\..\Module\Using\ObjectModels\PS.MCM.ContentModelConfig.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Album.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Content.Class.psm1
using module .\..\Module\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\Module\Using\Types\PS.MCM.Types.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\Module\PS.MediaContentManagement.psm1 -Force

    [ModuleState]::SetTestingState([TestAttribute]::SuppressConsoleOutput)
    [ModuleState]::SetTestingState([TestAttribute]::MockDestructiveActions)
    
    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()

    $nullAlbum = [Album]::new()
    $fooAlbum = [Album]::new("Foo", $true)
    $fooAlbum.Tracks.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooAlbum.Tracks.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooAlbum.Tracks.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Album Unit Test" -Tag UnitTest {
    BeforeEach {
        [ModuleState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullAlbum.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooAlbum.Name | Should -Be "Foo"
    }

    It "Matching within Tracks" {        
        $fooAlbum.Tracks.Matching("Foo").Count | Should -Be 2
        $fooAlbum.Tracks.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooAlbum.Tracks.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Tracks" {        
        $fooAlbum.Tracks.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }
}

AfterAll {
    Set-Location $PSScriptRoot\Output
    [ModuleState]::ClearTestingStates()
}