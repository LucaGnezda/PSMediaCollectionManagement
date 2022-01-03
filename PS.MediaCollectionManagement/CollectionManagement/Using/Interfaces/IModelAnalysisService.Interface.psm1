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
using module .\IBase.Interface.psm1
using module .\IStringSimilarityProvider.Interface.psm1
using module .\ISpellcheckProvider.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IModelAnalysisService : IBase {
    IModelAnalysisService () {
        $this.AssertAsInterface([IModelAnalysisService])
    }

    [void] SetStringSimilarityProvider([IStringSimilarityProvider] $provider) { }
    [Void] Static ModelSummary () { }
    [void] SetSpellcheckProvider([ISpellcheckProvider] $provider) { }
    [Int[]] AnalysePossibleLabellingIssues ([System.Collections.Generic.List[Object]] $subjectList, [Bool] $returnSummary) { return $null }
    [Hashtable] SpellcheckContentTitles([System.Collections.Generic.List[Object]] $contentList, [Bool] $returnResults) { return $null }
}
