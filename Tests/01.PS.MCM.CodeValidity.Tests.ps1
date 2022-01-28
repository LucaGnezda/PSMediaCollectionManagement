using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\ICommandHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IModelAnalysisHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IModelManipulationHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IModelPersistenceHandler.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IContentSubjectBO.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IFilesystemProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\IStringSimilarityProvider.Interface.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Interfaces\ISpellcheckProvider.Interface.psm1

using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Controllers\CollectionManagementController.Static.psm1

using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Handlers\CommandHandler.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Handlers\ModelAnalysisHandler.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Handlers\ModelManipulationHandler.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Handlers\ModelPersistenceHandler.Class.psm1

using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ActorBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\AlbumBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\ArtistBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\SeriesBO.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\BusinessObjects\StudioBO.Class.psm1

using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\ObjectModels\ContentModelConfig.Class.psm1

using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\FilesystemProvider.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\LevenshteinStringSimilarityProvider.Class.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Providers\MSWordCOMSpellcheckProvider.Class.psm1

using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsSettings.Static.psm1
using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsSettings.Static.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
}

Describe "Code Validity Unit Test" -Tag UnitTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Semantic Checks - Interface Implementations" {
        # Do
        $config = [ContentModelConfig]::new()
        $config.ConfigureForStructuredFiles(@([FilenameElement]::Actors, [FilenameElement]::Album, [FilenameElement]::Artists, [FilenameElement]::Series, [FilenameElement]::Studio))
        $config.LockFilenameFormat()

        # Test
        {[ICommandHandler] $handler = [CommandHandler]::new(); $handler } | Should -Not -Throw 
        {[IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new(); $handler } | Should -Not -Throw
        {[IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel); $handler } | Should -Not -Throw  
        {[IModelPersistenceHandler] $handler = [ModelPersistenceHandler]::new(); $handler } | Should -Not -Throw
        
        # Test
        {[IContentSubjectBO] $BO = [ActorBO]::new($config); $BO } | Should -Not -Throw
        {[IContentSubjectBO] $BO = [AlbumBO]::new($config); $BO } | Should -Not -Throw 
        {[IContentSubjectBO] $BO = [ArtistBO]::new($config); $BO } | Should -Not -Throw 
        {[IContentSubjectBO] $BO = [SeriesBO]::new($config); $BO } | Should -Not -Throw 
        {[IContentSubjectBO] $BO = [StudioBO]::new($config); $BO } | Should -Not -Throw 
        
        # Test
        {[IFilesystemProvider] $provider = [FileSystemProvider]::new($null, $null, $true); $provider } | Should -Not -Throw 
        {[ISpellcheckProvider] $provider = [MSWordCOMSpellcheckProvider]::new(); $provider } | Should -Not -Throw 
        {[IStringSimilarityProvider] $provider = [LevenshteinStringSimilarityProvider]::new(); $provider } | Should -Not -Throw 
    }

    It "Semantic Checks - Static Implementations" {
        # Test
        {[CollectionManagementController] $controller = [CollectionManagementController]::new(); $controller } | Should -Throw
        {[CollectionManagementDefaults] $defaults = [CollectionManagementDefaults]::new(); $defaults } | Should -Throw 

        # Test
        {[ConsoleExtensionsSettings] $settings = [ConsoleExtensionsSettings]::new(); $settings } | Should -Throw
        {[ConsoleExtensionsState] $state = [ConsoleExtensionsState]::new(); $state } | Should -Throw

        # Test
        {[FilesystemExtensionsSettings] $settings = [FilesystemExtensionsSettings]::new(); $settings } | Should -Throw
        {[FilesystemExtensionsState] $state = [FilesystemExtensionsState]::new(); $state } | Should -Throw 
    }
    
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}