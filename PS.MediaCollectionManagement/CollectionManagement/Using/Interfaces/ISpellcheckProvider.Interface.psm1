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
#endregion Using


#region Interface Definition
#-----------------------
class ISpellcheckProvider : IBase {
    ISpellcheckProvider () {
        $this.AssertAsInterface([ISpellcheckProvider])
    }

    # Prototypes
    [Bool] Initialise () { return $null }
    [System.Nullable[Bool]] CheckSpelling ([String] $word) { return $null }
    [System.Collections.Generic.List[String]] GetSuggestions ([String] $word) { return $null }
    [Void] Dispose () { }

}
