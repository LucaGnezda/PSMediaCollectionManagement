using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IContentSubjectBO.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\Content.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1


class MockContentSubjectBO : IContentSubjectBO {
    [Type] ActsOnType() { return $null }
    [FilenameElement] ActsOnFilenameElement() { return $null }
    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) { }
}


BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "IContentSubjectBO Unit Test" -Tag UnitTest {

    It "Interface definition" {
        # Test
        { $interface = [IContentSubjectBO]::new(); $interface } | Should -Throw

        # Test - Unfortunately a consiquence of pseudo interfaces, need to test their null implementations
        $interface = [MockContentSubjectBO]::new()
        ([IContentSubjectBO]$interface).ActsOnType() | Should -Be $null
        { ([IContentSubjectBO]$interface).ActsOnFilenameElement() } | Should -Throw
        ([IContentSubjectBO]$interface).ReplaceSubjectLinkedToContent($null, $null, $null) | Should -Be $null
    }

}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}