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
using Module .\..\Handlers\ModelManipulationHandler.Class.psm1
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

    [Bool] Static Alter ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        [IModelManipulationHandler] $handler = [ModelManipulationHandler]::new($contentModel)

        return $handler.Alter($fromName, $toName, $updateCorrespondingFilename, $filenameElement)
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