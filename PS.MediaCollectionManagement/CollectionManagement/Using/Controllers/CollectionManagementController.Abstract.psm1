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
using module .\..\..\..\Shared\Using\Base\IsAbstract.Class.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\Interfaces\IModelManipulationHandler.Interface.psm1
using module .\..\Interfaces\IModelPersistenceHandler.Interface.psm1
using module .\..\Interfaces\IModelAnalysisHandler.Interface.psm1
using module .\..\Interfaces\ICommandHandler.Interface.psm1
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
using module .\..\Providers\LevenshteinStringSimilarityProvider.Class.psm1
using module .\..\Providers\MSWordCOMSpellcheckProvider.Class.psm1
#endregion Using



#region Class Definition
#-----------------------
class CollectionManagementController : IsAbstract {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    CollectionManagementController () {
        $this.AssertAsAbstract([CollectionManagementController])
    } 
    #endregion Constructors


    #region Static Methods
    [Void] Static Build([IContentModel] $contentModel, [Bool] $loadProperties, [Bool] $generateHash) {
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        
        $handler.Build($loadProperties, $generateHash)
    }

    [Void] Static Rebuild([IContentModel] $contentModel, [Bool] $loadProperties, [Bool] $generateHash) {
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        
        $handler.Rebuild($loadProperties, $generateHash)
    }

    [Void] Static Load([IContentModel] $contentModel, [String] $indexFilePath, [Bool] $loadProperties, [Bool] $generateHash) {
        [IModelPersistenceHandler] $persistenceHandler = [ModelPersistenceHandler]::new()
        [IModelManipulationHandler] $manipulationHandler = [ModelManipulationHandler]::new($contentModel)
        
        $persistenceHandler.LoadConfigFromIndexFile($indexFilePath, $contentModel)
        $manipulationHandler.Load($persistenceHandler.RetrieveDataFromIndexFile($indexFilePath), $loadProperties, $generateHash)
    }

    [Void] Static Save([IContentModel] $contentModel, [String] $indexFilePath, [Bool] $loadProperties, [Bool] $generateHash) {
        [IModelPersistenceHandler] $persistenceHandler = [ModelPersistenceHandler]::new()
        [IModelManipulationHandler] $manipulationHandler = [ModelManipulationHandler]::new($contentModel)
        
        $manipulationHandler.FillPropertiesAndHashWhereMissing($loadProperties, $generateHash)
        $persistenceHandler.SaveToIndexFile($indexFilePath, $contentModel)
    }

    [Bool] Static AlterActor ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        
        return $handler.AlterSubject([ActorBO]::new($contentModel.Config), $contentModel.Actors, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] Static AlterAlbum ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.AlterSubject([AlbumBO]::new($contentModel.Config), $contentModel.Albums, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] Static AlterArtist ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.AlterSubject([ArtistBO]::new($contentModel.Config), $contentModel.Artists, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] Static AlterSeries ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.AlterSubject([SeriesBO]::new($contentModel.Config), $contentModel.Series, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] Static AlterStudio ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.AlterSubject([StudioBO]::new($contentModel.Config), $contentModel.Studios, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] Static RemodelFilenameFormat ([IContentModel] $contentModel, [Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { 
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.RemodelFilenameFormat($swapElement, $withElement, $updateCorrespondingFilename)
    }

    [Bool] Static AlterSeasonEpisodeFormat ([IContentModel] $contentModel, [Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) {
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.AlterSeasonEpisodeFormat($padSeason, $padEpisode, $pattern, $updateCorrespondingFilename)
    }

    [Bool] Static AlterTrackFormat ([IContentModel] $contentModel, [Int] $padTrack, [Bool] $updateCorrespondingFilename) { 
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.AlterTrackFormat($padTrack, $updateCorrespondingFilename)
    }

    [Void] ApplyAllPendingFilenameChanges([IContentModel] $contentModel) {
        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        $handler.ApplyAllPendingFilenameChanges()
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
        [ICommandHandler] $handler = [CommandHandler]::new()
        
        return $handler.Compare($baseline, $comparison, $returnSummary)
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

        return $handler.SpellcheckContentTitles($ContentList, $returnResults)
    }

    [System.Array] Static TestFilesystemHashes ([IContentModel] $contentModel, [Bool] $returnSummary) {
        
        [IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new()
        
        return $handler.TestFilesystemHashes($contentModel, $returnSummary)
    }
    #endregion Static Methods

}
#endregion Class Definition