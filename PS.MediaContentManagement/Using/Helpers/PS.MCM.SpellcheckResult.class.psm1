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
#endregion Using



#region Class Definition
#-----------------------
class SpellcheckResult {

    #region Properties
    [Bool]   $Correct
    [System.Collections.Generic.List[String]] $Suggestions

    #endregion Properties


    #region Constructors
    SpellcheckResult([Bool] $correct) {
        $this.Correct = $correct
        $this.Suggestions = [System.Collections.Generic.List[String]]::new()
    }
    #endregion Constructors


    #region Methods
    [Void] AddSuggestion ([String] $s) {
        $this.Suggestions.Add($s)
        $this.Suggestions.Sort()
    }
    #endregion Methods
}

#endregion Class Definition
}