using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\FilesystemProvider.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "FilesystemProvider Unit Test" -Tag UnitTest {

    It "Constructing" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)

        # Test
        $provider._DisposeShellOnDispose | Should -BeOfType "Boolean"
        $provider._ActSilently | Should -Be $false
        $provider._HasValidPath | Should -Be $true
        $provider._AbsolutePath.EndsWith("\TestData\ContentTestA\") | Should -Be $true
        $provider._IncludedExtensions | Should -Be @(".mp4", ".wav")
        $provider._fileCache | Should -Be $null

        # Do
        $provider.Dispose()
    }

    It "ChangePath" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)

        # Test
        $provider._AbsolutePath.EndsWith("\TestData\ContentTestA\") | Should -Be $true

        # Do
        $provider.ChangePath($null)

        # Test
        $provider._AbsolutePath.EndsWith("\") | Should -Be $true
        $provider._HasValidPath | Should -Be $true

        # Test
        {$provider.ChangePath("DoesNotExist")} | Should -Throw
        $provider._AbsolutePath.EndsWith("\") | Should -Be $true
        $provider._HasValidPath | Should -Be $false

        # Do
        $provider.Dispose()
    }

    It "GetFiles" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)
        $files = $provider.GetFiles()

        # Test
        $files.Count | Should -Be 2
        $files[0].Name | Should -Be "Foo - Bar.mp4"

        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", $null, $false)
        $files = $provider.GetFiles()

        # Test
        $files.Count | Should -Be 3
        $files[1].Name | Should -Be "Foo - Bar.txt"

        # Do
        $provider.Dispose()
    }

    It "GetFileIfExists" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)

        # Test
        $provider.GetFileIfExists("\Foo - Bar.mp4") | Should -Be $null

        # Test
        $provider.GetFileIfExists("Foo - Bar.mp4") | Should -BeOfType "System.IO.FileInfo"

        # Do
        $provider.Dispose()
    }

    It "FileExists" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)

        # Test
        $provider.FileExists("Foo - Bar.mp4") | Should -Be $true

        # Test
        $provider.FileExists("Doesnotexist.mp4") | Should -Be $false

        # Do
        $provider.Dispose()
    }

    It "GenerateHash" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)
        $file = $provider.GetFileIfExists("Foo - Bar.mp4")

        # Test
        $provider.GenerateHash($null) | Should -Be ""

        # Test
        $provider.GenerateHash("Foo - Bar.mp4") | Should -Be "88F292963ED23DA5F9C522CBF5075637"

        # Test
        $provider.GenerateHash($file) | Should -Be "88F292963ED23DA5F9C522CBF5075637"

        # Do
        $provider.Dispose()
    }

    It "CheckFilesystemHash" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)
        $file = $provider.GetFileIfExists("Foo - Bar.mp4")

        # Test
        $provider.CheckFilesystemHash($null, "Foo - Bar.mp4") | Should -Be -1

        # Test
        $provider.CheckFilesystemHash("88F292963ED23DA5F9C522CBF5075637", $null) | Should -Be -1

        # Test
        $provider.CheckFilesystemHash("88F292963ED23DA5F9C522CBF5075637", "Foo - Bar.mp4") | Should -Be 1
        $provider.CheckFilesystemHash("...", "Foo - Bar.mp4") | Should -Be 0

        # Test
        $provider.CheckFilesystemHash("88F292963ED23DA5F9C522CBF5075637", $file) | Should -Be 1
        $provider.CheckFilesystemHash("...", $file) | Should -Be 0

        # Do
        $provider.Dispose()
    }

    It "GetFileMetadataProperty" {
         # Do
         $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)
         $file = $provider.GetFileIfExists("Foo - Bar.mp4")

         # Do
        $property = $provider.GetFileMetadataProperty($file, 28)

        # Test
        $property.Index | Should -Be 28
        $property.Property | Should -Be "BitRate"
        $property.Value | Should -Be "96kbps"

        # Do
        $provider.Dispose()
    }

    It "GetFileMetadataProperties" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)
        $file = $provider.GetFileIfExists("Foo - Bar.mp4")

        # Do
       $properties = $provider.GetFileMetadataProperties($file)

       # Test
       $properties.Count | Should -Be 37
       $properties[12].Index | Should -Be 28
       $properties[12].Property | Should -Be "BitRate"
       $properties[12].Value | Should -Be "96kbps"

       # Do
       $provider.Dispose()
   }

   It "UpdateFileName" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)
        $file = $provider.GetFileIfExists("Foo - Bar.mp4")

        # Test
        $provider.UpdateFileName("Foo - Bar.mp4", "Rename.mp4") | Should -Be $true

        # Test
        $provider.UpdateFileName($file, "Rename.mp4") | Should -Be $true

        # Do
        $provider.Dispose()
   }

   It "Dispose" {
        # Do
        $provider = [FilesystemProvider]::new("$PSScriptRoot\TestData\ContentTestA", @(".mp4", ".wav"), $false)
        $provider._DisposeShellOnDispose = $true # force
        $provider.Dispose()
   }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}