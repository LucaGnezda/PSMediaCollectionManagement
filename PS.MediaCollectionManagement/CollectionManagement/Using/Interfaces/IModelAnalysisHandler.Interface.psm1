#region Header
#
# About: Pseudo Interface 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\..\..\Shared\Using\Base\IsInterface.Class.psm1
using module .\IStringSimilarityProvider.Interface.psm1
using module .\ISpellcheckProvider.Interface.psm1
using module .\IContentModel.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1

#endregion Using


#region Interface Definition
#-----------------------
class IModelAnalysisHandler : IsInterface {
    
    [IStringSimilarityProvider] $StringSimilarityProvider
    [ISpellcheckProvider] $SpellcheckProvider

    IModelAnalysisHandler () {
        $this.AssertAsInterface([IModelAnalysisHandler])
    }

    [Void] SetStringSimilarityProvider([IStringSimilarityProvider] $provider) { }
    [Void] SetSpellcheckProvider([ISpellcheckProvider] $provider) { }
    [Void] Static ModelSummary() { }
    [Int[]] AnalysePossibleLabellingIssues ([System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [Bool] $returnSummary) { return $null }
    [Hashtable] SpellcheckContentTitles([System.Collections.Generic.List[Object]] $contentList, [Bool] $returnResults) { return $null }
}
