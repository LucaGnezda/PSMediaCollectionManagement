using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ObjectModels\FileMetadataProperty.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "New-ContentModel Integration Test" -Tag IntegrationTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "New Model" {
        # Do
        $contentModelC = New-ContentModel
        
        # Test
        $contentModelC | Should -Not -Be $null
    }
}

Describe "Copy-ContentModel Integration Test" -Tag IntegrationTest {
 
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Copy Model" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)

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

        # Do
        Pop-Location
    }
}

Describe "Merge-ContentModel Integration Test" -Tag IntegrationTest {

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Merge Model" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)
        $contentModelD = New-ContentModel
        $contentModelD.LoadIndex(".\index.test.inputB.json", $true)

        # Do
        $merge = Merge-ContentModel $contentModelC $contentModelD
        
        # Test
        $merge.Content.Count | Should -Be 6
        ($merge.Content | Where-Object {$_.Warnings -contains [ContentWarning]::DuplicateDetectedInSources}).Count | Should -Be 2
        ($merge.Content | Where-Object {$_.Warnings -contains [ContentWarning]::MergeConflictsInData}).Count | Should -Be 1

        # Do
        Pop-Location
    }

    It "Merge Model - mismatching config" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestC
        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)
        $contentModelD = New-ContentModel
        $contentModelD.LoadIndex(".\index.test.inputC.json", $true)

        # Do
        $merge = Merge-ContentModel $contentModelC $contentModelD
        
        # Test
        $merge | Should -Be $null

        # Do
        Pop-Location
    }
}

Describe "Compare-ContentModel Integration Test" -Tag IntegrationTest {
    BeforeAll {

        Push-Location $PSScriptRoot\TestData\ContentTestC

        $contentModelC = New-ContentModel
        $contentModelC.LoadIndex(".\index.test.inputA.json", $true)

        $contentModelD = New-ContentModel
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

    It "Compare Content Model - File Directory" {
        Compare-ContentModels ".\index.test.inputA.json" ".\..\ContentTestB" -ReturnSummary | Should -Be @(3, 0, 0, 0, 0, 0, 3)
    }

    It "Compare Content Model - Directory File" {
        Compare-ContentModels ".\..\ContentTestB" ".\index.test.inputA.json" -ReturnSummary | Should -Be @(3, 0, 0, 0, 1, 0, 4)
    }

    It "Compare Content Model - Unmatched Forward" {
        Compare-ContentModels $contentModelC $contentModelD -ReturnSummary | Should -Be @(1, 1, 1, 0, 0, 0, 3)
    }

    It "Compare Content Model - Unmatched Reverse" {
        Compare-ContentModels $contentModelD $contentModelC -ReturnSummary | Should -Be @(1, 1, 0, 1, 2, 0, 5)
    }

    It "Compare Content Model - Unmatched without hashes" {
        # Do
        $contentModelC.Content[0].Filename = "Foo2 - Cherry, Apple, Banana, Pear - Delta.mp4"
        $contentModelC.Content[0].Hash = ""
        $contentModelC.Content[1].Hash = ""

        # Test
        Compare-ContentModels $contentModelC $contentModelD -ReturnSummary | Should -Be @(0, 2, 0, 0, 1, 0, 3)
    }

    It "Compare Content Model - Invalid input" {
        Compare-ContentModels "Doesnotexist" $contentModelC -ReturnSummary | Should -Be $null
        {Compare-ContentModels $contentModelD.Config $contentModelC -ReturnSummary} | Should -Throw
    }

    It "Compare Content Model - duplicates in file" {
        Compare-ContentModels ".\index.test.inputG.json" ".\index.test.inputG.json" -ReturnSummary | Should -Be @(2, 0, 0, 0, 0, 2, 4)
    }

    It "Compare Content Model - no summary" {
        Compare-ContentModels ".\index.test.inputG.json" ".\index.test.inputG.json"
    }

    AfterAll {
        Pop-Location
    }
}

Describe "Test-FilesystemHashes Integration Test" -Tag IntegrationTest {
    BeforeAll {
        $contentModelB = New-ContentModel
        $contentModelB.Config.ConfigureForShortFilm()
        $contentModelB.Config.OverrideFilenameFormat(@([FileNameElement]::Studio, [FilenameElement]::Actors, [FilenameElement]::Title))
    }

    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }

    It "Test - Validate Hashes" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
        $contentModelB.Content[1].Hash = "-"

        # Test
        Test-FilesystemHashes $contentModelB -ReturnSummary | Should -Be @(2, 1, 3)

        # Do
        Pop-Location
    }

    It "Test - non existance path" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
        $contentModelB.Content[1].Hash = "-"

        # Test
        {Test-FilesystemHashes "doesnotexist" $contentModelB -ReturnSummary} | Should -Throw

        # Do
        Pop-Location
    }

    It "Test - no summary" {
        # Do
        Push-Location $PSScriptRoot\TestData\ContentTestB
        $contentModelB.Build($true, $true)
        $contentModelB.Content[1].Hash = "-"

        # Test
        Test-FilesystemHashes $contentModelB

        # Do
        Pop-Location
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}