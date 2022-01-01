#region Header
#
# About: Helper class for holding spellcheck results 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\Content.Class.psm1
#endregion Using



#region Class Definition
#-----------------------
class SpellcheckResult {

    #region Properties
    [String] $Word
    [System.Nullable[Bool]] $IsCorrect
    [System.Collections.Generic.List[Content]] $FoundInTitleOfContent
    [System.Collections.Generic.List[String]] $Suggestions

    #endregion Properties


    #region Constructors
    SpellcheckResult([String] $word, [System.Nullable[Bool]] $isCorrect) {
        $this.Word = $word
        $this.IsCorrect = $isCorrect
        $this.FoundInTitleOfContent = [System.Collections.Generic.List[Content]]::new()
        $this.Suggestions = [System.Collections.Generic.List[String]]::new()
    }
    #endregion Constructors


    #region Methods
    [Void] AddSuggestion ([String] $s) {

        $existing = $this.Suggestions | Where-Object {$_ -eq $s}
        
        if ($null -eq $existing) {
            $this.Suggestions.Add($s)
        }
    }

    [Void] AddRelatedContent ([Content] $content) {
       
        $existing = $this.FoundInTitleOfContent | Where-Object {$_ -eq $content}

        if ($null -eq $existing) {
            $this.FoundInTitleOfContent.Add($content)
        }
    }
    #endregion Methods
}

#endregion Class Definition