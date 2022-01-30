#region Header
#
# About: Controller class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\..\..\Shared\Using\Base\IsStatic.Class.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\Interfaces\IModelManipulationHandler.Interface.psm1
using module .\..\Interfaces\IModelPersistenceHandler.Interface.psm1
using module .\..\Interfaces\IModelAnalysisHandler.Interface.psm1
using module .\..\Interfaces\ICommandHandler.Interface.psm1
using module .\..\Interfaces\IFilesystemProvider.Interface.psm1
using module .\..\Interfaces\IStringSimilarityProvider.Interface.psm1
using module .\..\Interfaces\ISpellcheckProvider.Interface.psm1
using module .\..\Handlers\ModelAnalysisHandler.Class.psm1
using module .\..\Handlers\ModelPersistenceHandler.Class.psm1
using module .\..\Handlers\ModelManipulationHandler.Class.psm1
using module .\..\Handlers\CommandHandler.Class.psm1
using module .\..\BusinessObjects\ActorBO.Class.psm1
using module .\..\BusinessObjects\AlbumBO.Class.psm1
using module .\..\BusinessObjects\ArtistBO.Class.psm1
using module .\..\BusinessObjects\SeriesBO.Class.psm1
using module .\..\BusinessObjects\studioBO.Class.psm1
using module .\..\Providers\FilesystemProvider.Class.psm1
using module .\..\Providers\LevenshteinStringSimilarityProvider.Class.psm1
using module .\..\Providers\MSWordCOMSpellcheckProvider.Class.psm1
#endregion Using



#region Class Definition
#-----------------------
class CollectionManagementController : IsStatic {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    #endregion Constructors


    #region Static Methods
    [Void] Static Build([IContentModel] $contentModel, [String] $contentPath, [Bool] $loadProperties, [Bool] $generateHash) {
        
        [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        
        $handler.Build($loadProperties, $generateHash, $filesystemProvider)
        $handler.IfRequiredProvideConsoleTipsForLoadWarnings()
        $filesystemProvider.Dispose()
    }

    [Void] Static Rebuild([IContentModel] $contentModel, [String] $contentPath, [Bool] $loadProperties, [Bool] $generateHash) {
        
        [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        
        $handler.Rebuild($loadProperties, $generateHash, $filesystemProvider)
        $handler.IfRequiredProvideConsoleTipsForLoadWarnings()
        $filesystemProvider.Dispose()
    }

    [Void] Static Load([IContentModel] $contentModel, [String] $indexFilePath, [Bool] $loadProperties, [Bool] $generateHash, [String] $contentPath) {
        
        [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
        [IModelPersistenceHandler] $persistenceHandler = [ModelPersistenceHandler]::new()
        [IModelManipulationHandler] $manipulationHandler = [ModelManipulationHandler]::new($contentModel)
        
        if (-not $persistenceHandler.LoadConfigFromIndexFile($indexFilePath, $contentModel)) { return }
        $manipulationHandler.Load($persistenceHandler.RetrieveDataFromIndexFile($indexFilePath), $loadProperties, $generateHash, $filesystemProvider)
        $manipulationHandler.IfRequiredProvideConsoleTipsForLoadWarnings()
        $filesystemProvider.Dispose()
    }

    [Void] Static Save([IContentModel] $contentModel, [String] $indexFilePath, [Bool] $loadProperties, [Bool] $generateHash, [String] $contentPath) {
        
        [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
        [IModelPersistenceHandler] $persistenceHandler = [ModelPersistenceHandler]::new()
        [IModelManipulationHandler] $manipulationHandler = [ModelManipulationHandler]::new($contentModel)
        
        $manipulationHandler.FillPropertiesAndHashWhereMissing($loadProperties, $generateHash, $filesystemProvider)
        $persistenceHandler.SaveToIndexFile($indexFilePath, $contentModel)
        $filesystemProvider.Dispose()
    }

    [Bool] Static AlterActor ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [String] $contentPath) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        
        [Bool] $alterations = $handler.AlterSubject([ActorBO]::new($contentModel.Config), $contentModel.Actors, $fromName, $toName)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Bool] Static AlterAlbum ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [String] $contentPath) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        [Bool] $alterations = $handler.AlterSubject([AlbumBO]::new($contentModel.Config), $contentModel.Albums, $fromName, $toName)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Bool] Static AlterArtist ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [String] $contentPath) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        [Bool] $alterations = $handler.AlterSubject([ArtistBO]::new($contentModel.Config), $contentModel.Artists, $fromName, $toName)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Bool] Static AlterSeries ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [String] $contentPath) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        [Bool] $alterations = $handler.AlterSubject([SeriesBO]::new($contentModel.Config), $contentModel.Series, $fromName, $toName)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Bool] Static AlterStudio ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [String] $contentPath) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        [Bool] $alterations = $handler.AlterSubject([StudioBO]::new($contentModel.Config), $contentModel.Studios, $fromName, $toName)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Bool] Static RemodelFilenameFormat ([IContentModel] $contentModel, [Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename, [String] $contentPath) { 
        
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        [Bool] $alterations = $handler.RemodelFilenameFormat($swapElement, $withElement)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Bool] Static AlterSeasonEpisodeFormat ([IContentModel] $contentModel, [Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename, [String] $contentPath) {
        
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        [Bool] $alterations = $handler.AlterSeasonEpisodeFormat($padSeason, $padEpisode, $pattern)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Bool] Static AlterTrackFormat ([IContentModel] $contentModel, [Int] $padTrack, [Bool] $updateCorrespondingFilename, [String] $contentPath) { 
        
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        [Bool] $alterations = $handler.AlterTrackFormat($padTrack)
        if ($updateCorrespondingFilename) {
            [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
            $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
        }
        $handler.IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename)
        return $alterations
    }

    [Void] Static ApplyAllPendingFilenameChanges([IContentModel] $contentModel, [String] $contentPath) {
        
        [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($contentPath, $contentModel.Config.IncludedExtensions, $true)
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        $handler.ApplyAllPendingFilenameChanges($filesystemProvider)
    }

    [Void] Static RemoveContentFromModel([IContentModel] $contentModel, $filename) {
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        
        $handler.RemoveContentFromModel($filename)
    }

    [IContentModel] Static CopyModel([IContentModel] $contentModel) {
        [ICommandHandler] $handler = [CommandHandler]::new()

        return $handler.CopyModel($contentModel)
    }

    [IContentModel] Static MergeModel([IContentModel] $contentModelA, [IContentModel] $contentModelB) {
        [ICommandHandler] $handler = [CommandHandler]::new()

        return $handler.MergeModels($contentModelA, $contentModelB)
    }

    [System.Array] Static Compare([Object] $baseline, [Object] $comparison, [Bool] $returnSummary) {
        
        [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($null, $null, $true)
        [ICommandHandler] $handler = [CommandHandler]::new()
        
        return $handler.Compare($baseline, $comparison, $filesystemProvider, $returnSummary)
    }

    [System.Array] Static TestFilesystemHashes ([String] $filePath, [IContentModel] $contentModel, [Bool] $returnSummary) {
        
        [IFilesystemProvider] $filesystemProvider = [FilesystemProvider]::new($filePath, $contentModel.Config.IncludedExtensions, $true)
        [ICommandHandler] $handler = [CommandHandler]::new()
        
        [System.Array] $summary = $handler.TestFilesystemHashes($contentModel, $filesystemProvider, $returnSummary)
        $filesystemProvider.Dispose()
        return $summary
    }

    [Void] Static ModelSummary ([IContentModel] $contentModel) {
        
        [IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new()
        
        $handler.ModelSummary($contentModel)
    }

    [Int[]] Static AnalysePossibleLabellingIssues ([System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [Bool] $returnSummary) {
        
        [IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new()
        [IStringSimilarityProvider] $stringSimilarityProvider = [LevenshteinStringSimilarityProvider]::new()
        $handler.SetStringSimilarityProvider($stringSimilarityProvider)

        return $handler.AnalysePossibleLabellingIssues([System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [Bool] $returnSummary)
    }

    [Hashtable] Static SpellcheckContentTitles ([System.Collections.Generic.List[Object]] $ContentList, [Bool] $returnResults) {

        [IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new()
        [ISpellcheckProvider] $spellcheckProvider = [MSWordCOMSpellcheckProvider]::new()
        $handler.SetSpellcheckProvider($spellcheckProvider)

        $results = $handler.SpellcheckContentTitles($ContentList, $returnResults)
        $spellcheckProvider.Dispose()

        return $results
    }

    #endregion Static Methods

}
#endregion Class Definition