using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ObjectModels\FileMetadataProperty.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Abstract.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1

BeforeAll { 
    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psm1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true

    Set-Location $PSScriptRoot\TestData\ContentTestA
}

Describe "Get-AvailableFileMetadataKeys" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Get All Keys" {
        # Do
        $metadata = Get-AvailableFileMetadataKeys
        
        # Test
        $metadata.Count | Should -Be 309
    }
}

Describe "Get-FileMetadata" -Tag IntegrationTest {
    BeforeAll {
        $file = Get-ChildItem ".\Foo - Bar.mp4"
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

Describe "Call Function - Rename-File" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Rename File - Rename conflict" {
        # Do
        Set-Location $PSScriptRoot\TestData\ContentTestD

        # Test
        Rename-File ".\Foo - Cherry, Apple, Banana, Pear - Delta.mp4" "Foo2 - Cherry, Apple, Banana, Pear - Delta.mp4" | Should -Be $false
        Rename-File ".\Foo - Cherry, Apple, Banana, Pear - Delta.mp4" "Foo - Cherry2, Apple, Banana, Pear - Delta.mp4" | Should -Be $false
    }

    It "Rename File - Mocked Rename" {
        # Do
        Set-Location $PSScriptRoot\TestData\ContentTestD

        # Test
        Rename-File ".\Foo - Cherry, Apple, Banana, Pear - Delta.mp4" "Foo - Cherry3, Apple, Banana, Pear - Delta.mp4" | Should -Be $true
    }
}

Describe "Call Function - Copy-Model" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)
    }

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Copy Model" {
        # Test
        $contentModelC.Content.Count | Should -Be 3
        $contentModelC.Content[0].Basename | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"

        # Do
        $copy = Copy-ContentModel $contentModelC
        
        # Test
        $copy.Content[0].Basename | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        
        # Do
        $copy.Content[0].Basename = "Foo"

        # Test
        $contentModelC.Content[0].Basename | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $copy.Content[0].Basename | Should -Be "Foo"
    }
}

Describe "Call Function - Merge-Model" -Tag IntegrationTest {
    BeforeAll {
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)
        $contentModelD = New-ContentModel
        $contentModelD.LoadIndex(".\index.test.inputB.json", $true)
    }

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Merge Model" {
        # Do
        $merge = Merge-ContentModel $contentModelC $contentModelD
        
        # Test
        $merge.Content.Count | Should -Be 6
        ($merge.Content | Where-Object {$_.Warnings -contains [ContentWarning]::DuplicateDetectedInSources}).Count | Should -Be 2
        ($merge.Content | Where-Object {$_.Warnings -contains [ContentWarning]::MergeConflictsInData}).Count | Should -Be 1
    }
}

Describe "Call Function - Compare-Model" -Tag IntegrationTest {
    BeforeAll {
        $contentModelC = New-ContentModel
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)

        $contentModelD = New-ContentModel
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelD.LoadIndex(".\index.test.inputB.json", $true)
    }

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Compare Content Model - Model Model" {
        Compare-ContentModels $contentModelC $contentModelC -ReturnSummary | Should -Be @(3, 0, 0, 0, 0, 0, 3)
    }

    It "Compare Content Model - File Model" {
        Compare-ContentModels ".\index.test.inputA.json" $contentModelC -ReturnSummary | Should -Be @(3, 0, 0, 0, 0, 0, 3)
    }

    It "Compare Content Model - Model File" {
        Compare-ContentModels $contentModelC ".\index.test.inputA.json" -ReturnSummary | Should -Be @(3, 0, 0, 0, 0, 0, 3)
    }

    It "Compare Content Model - File File" {
        Compare-ContentModels ".\index.test.inputA.json" ".\index.test.inputA.json" -ReturnSummary | Should -Be @(3, 0, 0, 0, 0, 0, 3)
    }

    It "Compare Content Model - Unmatched Forward" {
        Compare-ContentModels $contentModelC $contentModelD -ReturnSummary | Should -Be @(1, 1, 1, 0, 0, 0, 3)
    }

    It "Compare Content Model - Unmatched Reverse" {
        Compare-ContentModels $contentModelD $contentModelC -ReturnSummary | Should -Be @(1, 1, 0, 1, 2, 0, 5)
    }
}

Describe "Call Function - Compare-Model - Missing baseline hashes" -Tag IntegrationTest {
    BeforeAll {
        $contentModelC = New-ContentModel
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)

        $contentModelD = New-ContentModel
        Set-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelD.LoadIndex(".\index.test.inputA.json", $true)
    }

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Compare Content Model - Unmatched without hashes" {
        # Do
        $contentModelC.Content[0].Filename = "Foo2 - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModelC.Content[0].Hash = ""
        $contentModelC.Content[1].Hash = ""

        # Test
        Compare-ContentModels $contentModelC $contentModelD -ReturnSummary | Should -Be @(1, 1, 0, 0, 1, 0, 3)
    }
}

Describe "Call Function - Confirm-FilesystemHashes" -Tag IntegrationTest {
    BeforeAll {
        $contentModelB = New-ContentModel
        $contentModelB.Config.ConfigureForShortFilm()
        $contentModelB.Config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
        Set-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
        $contentModelB.Content[1].Hash = "-"
    }

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Validate Hashes" {
        Test-FilesystemHashes $contentModelB -ReturnSummary | Should -Be @(2, 1, 3)
    }
}

AfterAll {
    Set-Location $PSScriptRoot
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}