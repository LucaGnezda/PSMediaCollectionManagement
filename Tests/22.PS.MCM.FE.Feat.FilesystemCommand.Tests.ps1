using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ObjectModels\FileMetadataProperty.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "Get-AvailableFileMetadataKeys" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Get All Keys" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestA
        $metadata = Get-AvailableFileMetadataKeys
        Pop-Location
        
        # Test
        $metadata.Count | Should -Be 309
    }

    It "Get All Keys - Remote" -Tag RemoteFilesystem {
        # Do
        Push-Location \\$env:COMPUTERNAME\d
        $metadata = Get-AvailableFileMetadataKeys
        Pop-Location
        
        # Test
        $metadata.Count | Should -Be 309
    }
}

Describe "Get-FileMetadata" -Tag IntegrationTest {
    BeforeAll {
        Push-Location $PSScriptRoot\TestData\ContentTestA
        $file = Get-ChildItem ".\Foo - Bar.mp4"
        $file > $null
        Pop-Location
    }

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Get All File Metadata" {
        # Test
        $file | Should -Exist
        
        # Do
        $metadata = (Get-FileMetadata $file) 
        
        # Test
        Write-Host Write-Host ($metadata | Format-Table | Out-String)

        $metadata.Count | Should -Be 37
        $metadata[0].Index | Should -Be 0
        $metadata[0].Property | Should -Be "Name"
        $metadata[0].Value | Should -Be "Foo - Bar.mp4"
    }

    It "Get Specific Key Value Pair" {
        # Test
        $file | Should -Exist
        
        # Do
        $metadata = (Get-FileMetadata $file 320)
        
        # Test
        $metadata.Index | Should -Be 320
        $metadata.Property | Should -Be "TotalBitrate"
        $metadata.Value | Should -Be "375kbps"
    }
}

Describe "Initialize-PersistentFilesystemShell, Remove-PersistentFilesystemShell" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Test" {
        # Test
        Initialize-PersistentFilesystemShell
        Remove-PersistentFilesystemShell
    }
}

Describe "Rename-File" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Rename File - Rename conflict" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestD

        # Test
        Rename-File "Foo - Cherry, Apple, Banana, Pear - Delta.mp4" "Foo - Cherry, Apple, Banana, Pear - Delta.mp4" | Should -Be $false
        Rename-File ".\Foo - Cherry, Apple, Banana, Pear - Delta.mp4" "Foo2 - Cherry, Apple, Banana, Pear - Delta.mp4" | Should -Be $false
        Rename-File ".\Foo - Cherry, Apple, Banana, Pear - Delta.mp4" "Foo - Cherry2, Apple, Banana, Pear - Delta.mp4" | Should -Be $false

        # Do
        Pop-Location
    }

    It "Rename File - Mocked Rename" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestD

        # Test
        Rename-File ".\Foo - Cherry, Apple, Banana, Pear - Delta.mp4" "Foo - Cherry3, Apple, Banana, Pear - Delta.mp4" | Should -Be $true

        # Do
        Pop-Location
    }
}

Describe "Save-File" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Save" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestA
        
        # Test
        Save-File "Foo - Bar.txt" "Text"

        # Do
        Pop-Location
    }
}

Describe "Test-PersistentFilesystemShellExistence" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Test" {
        # Test
        Test-PersistentFilesystemShellExistence
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}