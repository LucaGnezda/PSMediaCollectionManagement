#region Header
#
# About: Helper class for spellchecking words 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Interfaces\ISpellcheckProvider.Interface.psm1
#endregion Using



#region Class Definition
#-----------------------
class MSWordCOMSpellcheckProvider : ISpellcheckProvider {
    #region Properties
    [System.MarshalByRefObject] hidden $_WordInterop = $null
    #endregion Properties


    #region Constructors
    SpellcheckProvider () { } 
    #endregion Constructors


    #region Methods
    [Bool] Initialise () {

         # Attempt to initialise Microsoft Word Interop, and fail and cleanup gracefully if unable to do so.
         try {           
            Write-InfoToConsole "Instantiating COM Word Interop"
            $this._WordInterop = New-Object -COM Word.Application
            $this._WordInterop.Documents.Add([System.Reflection.Missing]::Value, [System.Reflection.Missing]::Value, [System.Reflection.Missing]::Value, [System.Reflection.Missing]::Value) > $null
            return $true
        }
        catch {
            Write-WarnToConsole "Unable to initialise Word Interop, no spellcheck results will be included in the dictionary."
            $this.Dispose()
            return $false
        }

    }

    [System.Nullable[Bool]] CheckSpelling ([String] $word) {

        # return spellcheck result if provider is available
        if ($null -ne $this._WordInterop) {
            return $this._WordInterop.CheckSpelling($word)
        }
        else {
            return $null
        }
    }

    [System.Collections.Generic.List[String]] GetSuggestions ([String] $word) {

        # Get the spellcheck suggestions
        $wordSuggestions = $this._WordInterop.GetSpellingSuggestions($word)
        
        # load it into a list
        $suggestionsList = [System.Collections.Generic.List[String]]::new()
        
        foreach ($item in $wordSuggestions){
            $suggestionsList.Add($item.Name)
        }

        return $suggestionsList

    }

    [Void] Dispose () {

        if ($null -ne $this._WordInterop) {
            try {
                Write-InfoToConsole "Disposing COM Word Interop"
                $this._WordInterop.Quit()
            }
            catch {
                # silently
            }
            finally {
                $this._WordInterop = $null
            }
        }

    }
    #endregion Methods

}
#endregion Class Definition