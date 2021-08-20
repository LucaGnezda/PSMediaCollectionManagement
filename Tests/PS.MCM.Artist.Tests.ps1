using module .\..\Module\Using\ObjectModels\PS.MCM.ContentModelConfig.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Artist.Class.psm1
using module .\..\Module\Using\ObjectModels\PS.MCM.Content.Class.psm1
using module .\..\Module\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1
using module .\..\Module\Using\Types\PS.MCM.Types.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\Module\PS.MediaContentManagement.psm1 -Force

    [ModuleState]::SetTestingState([TestAttribute]::SuppressConsoleOutput)
    [ModuleState]::SetTestingState([TestAttribute]::MockDestructiveActions)

    $config = [ContentModelConfig]::new()  
    $config.ConfigureForFilm()

    $nullArtist = [Artist]::new()
    $fooArtist = [Artist]::new("Foo")
    $fooArtist.Performed.Add([Content]::new("Foo.test", "Foo", ".test", $config))
    $fooArtist.Performed.Add([Content]::new("Fooish.test", "Fooish", ".test", $config))
    $fooArtist.Performed.Add([Content]::new("Bar.test", "Bar", ".test", $config))
}

Describe "Artist Unit Test" -Tag UnitTest {
    BeforeEach {
        [ModuleState]::ResetMockConsole()
    }
    
    It "Constructing with no parameters" {
        $nullArtist.Name | Should -Be ""
    }

    It "Constructing with parameter" {
        $fooArtist.Name | Should -Be "Foo"
    }

    It "Matching within Performed" {        
        $fooArtist.Performed.Matching("Foo").Count | Should -Be 2
        $fooArtist.Performed.Matching("Foo").GetType() | Should -Be "System.Object[]"
        $fooArtist.Performed.Matching("Foo")[0].Filename | Should -Be "Foo.test"
    }

    It "Sorting Performed" {        
        $fooArtist.Performed.SortedBy("Name")[0].Filename | Should -Be "Bar.test"
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ModuleState]::ClearTestingStates()
}