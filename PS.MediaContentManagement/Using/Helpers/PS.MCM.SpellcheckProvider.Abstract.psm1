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
#endregion Using



#region Class Definition
#-----------------------
class SpellcheckProvider
{
    #region Properties
    [System.MarshalByRefObject] static $WordInterop = $null
    #endregion Properties


    #region Constructors
    # This class is intented to be used as an abstract class. However PowerShell cannot declare abstract classes, 
    # nor can it force disposal of a class. So there is no way to prevent this class being instantiated. 
    # That said, it will still work well enough if instantiated.
    #endregion Constructors


    #region Methods
    [Bool] Static Initialise () {

         # Attempt to initialise Microsoft Word Interop, and fail and cleanup gracefully if unable to do so.
         try {           
            Write-InfoToConsole "Instantiating COM Word Interop"
            [SpellcheckProvider]::WordInterop = New-Object -COM Word.Application
            [SpellcheckProvider]::WordInterop.Documents.Add([System.Reflection.Missing]::Value, [System.Reflection.Missing]::Value, [System.Reflection.Missing]::Value, [System.Reflection.Missing]::Value) > $null
            return $true
        }
        catch {
            Write-WarnToConsole "Unable to initialise Word Interop, no spellcheck results will be included in the dictionary."
            
            try {
                Write-InfoToConsole "Disposing COM Word Interop"
                [SpellcheckProvider]::WordInterop.Quit()
            }
            catch {
                # silently
            }
            finally {
                [SpellcheckProvider]::WordInterop = $null
            }
            return $false
        }

    }

    [System.Nullable[Bool]] Static CheckSpelling ([String] $word) {

        # return spellcheck result if provider is available
        if ($null -ne [SpellcheckProvider]::WordInterop) {
            return [SpellcheckProvider]::WordInterop.CheckSpelling($word)
        }
        else {
            return $null
        }
    }

    [Object] Static GetSuggestions ([String] $word) {

        # Get the spellcheck suggestions
        $wordSuggestions = [SpellcheckProvider]::WordInterop.GetSpellingSuggestions($word)
        
        # load it into a list
        $suggestionsList = [System.Collections.Generic.List[String]]::new()
        
        foreach ($item in $wordSuggestions){
            $suggestionsList.Add($item.Name)
        }

        return $suggestionsList

    }

    [Void] Static Dispose () {

        if ($null -ne [SpellcheckProvider]::WordInterop) {
            try {
                Write-InfoToConsole "Disposing COM Word Interop"
                [SpellcheckProvider]::WordInterop.Quit()
            }
            catch {
                # silently
            }
        }

    }
    #endregion Methods

}
#endregion Class Definition