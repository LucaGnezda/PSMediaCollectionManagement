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
using module .\..\Interfaces\IModelAnalysisService.Interface.psm1
using module .\..\Interfaces\IModelManipulationService.Interface.psm1
using module .\..\Interfaces\IStringSimilarityProvider.Interface.psm1
using module .\..\Interfaces\ISpellcheckProvider.Interface.psm1
using module .\..\Services\ModelAnalysisService.Class.psm1
using Module .\..\Services\ModelManipulationService.Class.psm1
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
        
        [IModelAnalysisService] $service = [ModelAnalysisService]::new()
        
        $service.ModelSummary($contentModel)
    }

    [Int[]] Static AnalysePossibleLabellingIssues ([System.Collections.Generic.List[Object]] $subjectList, [Bool] $returnSummary) {
        
        [IModelAnalysisService] $service = [ModelAnalysisService]::new()
        [IStringSimilarityProvider] $stringSimilarityProvider = [LevenshteinStringSimilarityProvider]::new()
        $service.SetStringSimilarityProvider($stringSimilarityProvider)

        return $service.AnalysePossibleLabellingIssues([System.Collections.Generic.List[Object]] $subjectList, [Bool] $returnSummary)
    }

    [Hashtable] Static SpellcheckContentTitles ([System.Collections.Generic.List[Object]] $ContentList, [Bool] $returnResults) {

        [IModelAnalysisService] $service = [ModelAnalysisService]::new()
        [ISpellcheckProvider] $spellcheckProvider = [MSWordCOMSpellcheckProvider]::new()
        $service.SetSpellcheckProvider($spellcheckProvider)

        return $service.SpellcheckContentTitles($ContentList, $returnResults)
    }

    [Bool] Static Alter ([IContentModel] $contentModel, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        [IModelManipulationService] $service = [ModelManipulationService]::new($contentModel)

        return $service.Alter($fromName, $toName, $updateCorrespondingFilename, $filenameElement)
    }

    [Bool] Static RemodelFilenameFormat ([IContentModel] $contentModel, [Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { 
        [IModelManipulationService] $service = [ModelManipulationService]::new($contentModel)

        return $service.RemodelFilenameFormat($swapElement, $withElement, $updateCorrespondingFilename)
    }

    [Bool] Static AlterSeasonEpisodeFormat ([IContentModel] $contentModel, [Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) {
        [IModelManipulationService] $service = [ModelManipulationService]::new($contentModel)

        return $service.AlterSeasonEpisodeFormat($padSeason, $padEpisode, $pattern, $updateCorrespondingFilename)
    }

    [Bool] Static AlterTrackFormat ([IContentModel] $contentModel, [Int] $padTrack, [Bool] $updateCorrespondingFilename) { 
        [IModelManipulationService] $service = [ModelManipulationService]::new($contentModel)

        return $service.AlterTrackFormat($padTrack, $updateCorrespondingFilename)
    }
    #endregion Static Methods

}
#endregion Class Definition