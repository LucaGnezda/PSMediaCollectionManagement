using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ContentModelConfigBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "ContentModelConfigBO Unit Test" -Tag UnitTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Constructing" {
       # Test
       {$contentModelConfigBO = [ContentModelConfigBO]::new(); $contentModelConfigBO} | Should -Not -Throw
    }

    It "IsMatch" {
        # Do
        $contentModelConfigBO = [ContentModelConfigBO]::new()
        
        $config1 = [ContentModelConfig]::new()
        $config1.ConfigureForShortFilm()
        $config1.LockFilenameFormat()

        $config2 = [ContentModelConfig]::new()
        $config2.ConfigureForShortFilm()
        $config2.LockFilenameFormat()

        $config3 = [ContentModelConfig]::new()
        $config3.ConfigureForAlbumAndTrack()
        $config3.LockFilenameFormat()

        # Test
        $contentModelConfigBO.IsMatch($config1, $config2) | Should -Be $true

        # Test
        $contentModelConfigBO.IsMatch($config1, $config3) | Should -Be $false
    }

    It "CloneCopy" {
        # Do
        $contentModelConfigBO = [ContentModelConfigBO]::new()
        
        $config1 = [ContentModelConfig]::new()
        $config1.ConfigureForShortFilm()
        $config1.LockFilenameFormat()

        $config2 = [ContentModelConfig]::new()

        $contentModelConfigBO.CloneCopy($config1, $config2)

        # Test
        $contentModelConfigBO.IsMatch($config1, $config2) | Should -Be $true
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}
