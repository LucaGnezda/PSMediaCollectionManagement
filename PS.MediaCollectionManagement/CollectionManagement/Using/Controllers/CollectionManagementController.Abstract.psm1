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
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\Interfaces\IModelAnalysisHandler.Interface.psm1
using module .\..\Interfaces\IModelManipulationHandler.Interface.psm1
using module .\..\Interfaces\IStringSimilarityProvider.Interface.psm1
using module .\..\Interfaces\ISpellcheckProvider.Interface.psm1
using module .\..\Handlers\ModelAnalysisHandler.Class.psm1
using module .\..\Handlers\ModelManipulationHandler.Class.psm1
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
class CollectionManagementController {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    CollectionManagementController () {

        # Prevent instantiation of this class
        if ($this.GetType() -eq [CollectionManagementController]) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        }
    } 
    #endregion Constructors


    #region Static Methods
    [Void] Static ModelSummary ([IContentModel] $contentModel) {
        
        [IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new()
        
        $handler.ModelSummary($contentModel)
    }

    [Int[]] Static AnalysePossibleLabellingIssues ([System.Collections.Generic.List[Object]] $subjectList, [Bool] $returnSummary) {
        
        [IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new()
        [IStringSimilarityProvider] $stringSimilarityProvider = [LevenshteinStringSimilarityProvider]::new()
        $handler.SetStringSimilarityProvider($stringSimilarityProvider)

        return $handler.AnalysePossibleLabellingIssues([System.Collections.Generic.List[Object]] $subjectList, [Bool] $returnSummary)
    }

    [Hashtable] Static SpellcheckContentTitles ([System.Collections.Generic.List[Object]] $ContentList, [Bool] $returnResults) {

        [IModelAnalysisHandler] $handler = [ModelAnalysisHandler]::new()
        [ISpellcheckProvider] $spellcheckProvider = [MSWordCOMSpellcheckProvider]::new()
        $handler.SetSpellcheckProvider($spellcheckProvider)

        return $handler.SpellcheckContentTitles($ContentList, $returnResults)
    }

    [Bool] Static AlterActor ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        $handler.SetContentSubjectBO([ActorBO]::new())
        
        return $handler.Alter($contentModel.Actors, $fromName, $toName, $updateCorrespondingFilename, $filenameElement)
    }

    [Bool] Static AlterAlbum ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        $handler.SetContentSubjectBO([AlbumBO]::new())

        return $handler.Alter($contentModel.Albums, $fromName, $toName, $updateCorrespondingFilename, $filenameElement)
    }

    [Bool] Static AlterArtist ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        $handler.SetContentSubjectBO([ArtistBO]::new())

        return $handler.Alter($contentModel.Artists, $fromName, $toName, $updateCorrespondingFilename, $filenameElement)
    }

    [Bool] Static AlterSeries ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        $handler.SetContentSubjectBO([SeriesBO]::new())

        return $handler.Alter($contentModel.Series, $fromName, $toName, $updateCorrespondingFilename, $filenameElement)
    }

    [Bool] Static AlterStudio ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)
        $handler.SetContentSubjectBO([StudioBO]::new())

        return $handler.Alter($contentModel.Studios, $fromName, $toName, $updateCorrespondingFilename, $filenameElement)
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
    #endregion Static Methods

}
#endregion Class Definition