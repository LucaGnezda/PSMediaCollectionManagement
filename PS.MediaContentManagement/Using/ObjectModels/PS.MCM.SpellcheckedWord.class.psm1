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
using module .\PS.MCM.Content.Class.psm1
#endregion Using



#region Class Definition
#-----------------------
class SpellcheckedWord {

    #region Properties
    [String] $Word
    [Bool]   $IsCorrect
    [System.Collections.Generic.List[Content]] $FoundInTitleOfContent
    [System.Collections.Generic.List[String]] $Suggestions

    #endregion Properties


    #region Constructors
    SpellcheckedWord([String] $word, [Bool] $isCorrect) {
        $this.Word = $word
        $this.IsCorrect = $isCorrect
        $this.FoundInTitleOfContent = [System.Collections.Generic.List[Content]]::new()
        $this.Suggestions = [System.Collections.Generic.List[String]]::new()
    }
    #endregion Constructors


    #region Methods
    [Void] AddSuggestion ([String] $s) {
        $this.Suggestions.Add($s)
        $this.Suggestions.Sort()
    }

    [Void] AddRelateContent ([Content] $content) {
        $this.FoundInTitleOfContent.Add($content)
        $this.FoundInTitleOfContent.Sort()
    }
    #endregion Methods
}

#endregion Class Definition