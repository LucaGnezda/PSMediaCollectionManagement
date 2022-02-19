using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IStringSimilarityProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockStringSimilarityProvider : IStringSimilarityProvider {
    [Double] GetNormalisedDistanceBetween([String] $s1, [String] $s2) { return $null }
    [Double] GetNormalisedDistanceBetween([String] $s1, [String] $s2, [Bool] $caseSensitive) { return $null }
    [Int] GetRawDistanceBetween([String] $s1, [String] $s2) { return $null }
    [Int] GetRawDistanceBetween([String] $s1, [String] $s2, [Bool] $caseSensitive) { return $null }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "IStringSimilarityProvider Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [IStringSimilarityProvider]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockStringSimilarityProvider]::new()
        ([IStringSimilarityProvider]$interface).GetNormalisedDistanceBetween($null, $null) | Should -Be 0.0
        ([IStringSimilarityProvider]$interface).GetNormalisedDistanceBetween($null, $null, $null) | Should -Be 0.0
        ([IStringSimilarityProvider]$interface).GetRawDistanceBetween($null, $null) | Should -Be 0
        ([IStringSimilarityProvider]$interface).GetRawDistanceBetween($null, $null, $null) | Should -Be 0
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}