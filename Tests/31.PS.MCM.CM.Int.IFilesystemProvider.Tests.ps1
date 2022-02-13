using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IFilesystemProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ObjectModels\FileMetadataProperty.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockFilesystemProvider : IFilesystemProvider {
    [Void] ChangePath ([String] $path) { }
    [System.IO.FileInfo[]] GetFiles () { return $null }
    [System.IO.FileInfo] GetFileIfExists([String] $filename) { return $null }
    [Bool] FileExists([String] $filename) { return $null }
    [String] GenerateHash([String] $filename) { return $null }
    [String] GenerateHash([System.IO.FileInfo] $file) { return $null }
    [Int] CheckFilesystemHash($hash, [String] $filename) { return $null }
    [Int] CheckFilesystemHash($hash, [System.IO.FileInfo] $file) { return $null }
    [System.Collections.Generic.List[FileMetadataProperty]] GetFileMetadataProperty([System.IO.FileInfo] $file, [Int] $propertyIndex) { return $null }
    [System.Collections.Generic.List[FileMetadataProperty]] GetFileMetadataProperties([System.IO.FileInfo] $file) { return $null }
    [Bool] UpdateFileName([String] $currentFilename, [String] $newFilename) { return $null }
    [Bool] UpdateFileName([System.IO.FileInfo] $file, [String] $newFilename) { return $null }
    [Void] Dispose () { }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "IFilesystemProvider Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [IFilesystemProvider]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockFilesystemProvider]::new()
        ([IFilesystemProvider]$interface).GetFiles() | Should -Be $null
        ([IFilesystemProvider]$interface).GetFileIfExists($null) | Should -Be $null
        ([IFilesystemProvider]$interface).FileExists($null) | Should -Be $false
        ([IFilesystemProvider]$interface).GenerateHash("") | Should -Be ""
        ([IFilesystemProvider]$interface).GenerateHash((Get-ChildItem -File)[0]) | Should -Be ""
        ([IFilesystemProvider]$interface).CheckFilesystemHash("", "") | Should -Be 0
        ([IFilesystemProvider]$interface).CheckFilesystemHash("", (Get-ChildItem -File)[0]) | Should -Be 0
        ([IFilesystemProvider]$interface).GetFileMetadataProperty($null, $null) | Should -Be $null
        ([IFilesystemProvider]$interface).GetFileMetadataProperties($null) | Should -Be $null
        ([IFilesystemProvider]$interface).UpdateFileName("", "") | Should -Be $false
        ([IFilesystemProvider]$interface).UpdateFileName((Get-ChildItem -File)[0], "") | Should -Be $false
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}