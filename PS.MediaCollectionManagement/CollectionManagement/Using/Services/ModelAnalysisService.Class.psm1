#region Header
#
# About: Services Layer Class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Interfaces\IStringSimilarityProvider.Interface.psm1
using module .\..\Interfaces\ISpellcheckProvider.Interface.psm1
using module .\..\Interfaces\IModelAnalysisService.Interface.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\SpellcheckResult.Class.psm1
#endregion Using


#region Class Definition
#-----------------------
class ModelAnalysisService : IModelAnalysisService {

    #region Properties
    [IStringSimilarityProvider] $StringSimilarityProvider
    [ISpellcheckProvider] $SpellcheckProvider
    #endregion Properties


    #region Constructors
    #endregion Constructors
    
    
    #region Methods
    [void] SetStringSimilarityProvider([IStringSimilarityProvider] $provider) {
        $this.StringSimilarityProvider = $provider
    }

    [void] SetSpellcheckProvider([ISpellcheckProvider] $provider) {
        $this.SpellcheckProvider = $provider
    }

    [Void] ModelSummary([IContentModel] $contentModel) {
        [Timespan]$totalTimeSpan = 0

        foreach ($content in $contentModel.Content) {
            $totalTimeSpan += $content.TimeSpan
        }

        if ($null -ne $contentModel.Actors) {
            Write-InfoToConsole ([String]$contentModel.Actors.Count).PadLeft(13," ") " Content Items"
        }
        if ($null -ne $contentModel.Actors) {
            Write-InfoToConsole ([String]$contentModel.Artists.Count).PadLeft(13," ") " Content Items"
        }
        if ($null -ne $contentModel.Actors) {
            Write-InfoToConsole ([String]$contentModel.Albums.Count).PadLeft(13," ") " Content Items"
        }
        if ($null -ne $contentModel.Actors) {
            Write-InfoToConsole ([String]$contentModel.Series.Count).PadLeft(13," ") " Content Items"
        }
        if ($null -ne $contentModel.Actors) {
            Write-InfoToConsole ([String]$contentModel.Studios.Count).PadLeft(13," ") " Content Items"
        }
        Write-InfoToConsole ([String]$contentModel.Content.Count).PadLeft(13," ") " Content Items"
        Write-InfoToConsole ([String]([String]$totalTimeSpan.Days + "d " + $totalTimeSpan.ToString("hh\:mm\:ss") )).PadLeft(13," ") " Total Duration" 
    }


    [Int[]] AnalysePossibleLabellingIssues ([System.Collections.Generic.List[Object]] $subjectList, [Bool] $returnSummary) {
        
        # Initialise
        [Int] $itemCount = $subjectList.Count
        [System.Collections.Generic.List[Object]] $sortedSubjectList = $subjectList.SortedBy("Name")
        [Double[,]] $differenceMap = [Double[,]]::new($itemCount, $itemCount)   # A 2D array to hold a SimilaritiesMap
        [Int] $i = 0
        [Int] $dissimilarCount = 0
        [Int] $similarCount = 0
        [Int] $verySimilarCount = 0
        [Int] $matchCount = 0
        [Int] $superStringCount = 0

        # for each item
        for ($i = 0; $i -lt $itemCount; $i++) {

            # Initialise current iteration
            [Object] $itemBeingChecked = $sortedSubjectList[$i]
            [Double] $minDifference = 1.0
            [Double] $maxDifference = 0.0
            [Bool] $superstringFound = $false
            [Bool] $matchingstringFound = $false
            [String] $resemblesString =""
            [String] $subString = ""
            [String] $matchedString = ""

            # for each item 
            for ($j = 0; $j -lt $itemCount; $j++) {
                
                [Object] $comparedItem = $sortedSubjectList[$j]

                if ($i -lt $j) {

                    # If i<j then calculate the distance (forming a half triangle within the 2D array)   
                    $differenceMap[$i,$j] = $this.StringSimilarityProvider.GetNormalisedDistanceBetween($itemBeingChecked.Name, $comparedItem.Name)

                    if (($differenceMap[$i,$j]) -lt $minDifference) {
                        $minDifference = $differenceMap[$i,$j]
                        $resemblesString = $comparedItem.Name
                    }

                    if (($differenceMap[$i,$j]) -gt $maxDifference) {
                        $maxDifference = $differenceMap[$i,$j]
                    }

                    if ($itemBeingChecked.Name -eq $comparedItem.Name) {
                        $matchingstringFound = $true
                        $matchedString = $comparedItem.Name
                    }
                    elseif ($itemBeingChecked.Name -match $comparedItem.Name) {
                        $superstringFound = $true
                        $subString = $comparedItem.Name
                    }
                }
                elseif ($i -eq $j) {
                    # If i=j then do nothing (the diagonal of the 2D array)
                }
                elseif ($i -gt $j) {
                    # If i>j then copy prior calculation (the reflected half triangle within the 2D array)
                    
                    $differenceMap[$i,$j] = $differenceMap[$j,$i] 

                    if (($differenceMap[$i,$j]) -lt $minDifference) {
                        $minDifference = $differenceMap[$i,$j]
                        $resemblesString = $comparedItem.Name
                    }

                    if (($differenceMap[$i,$j]) -gt $maxDifference) {
                        $maxDifference = $differenceMap[$i,$j]
                    }

                    if ($itemBeingChecked.Name -eq $comparedItem.Name) {
                        $matchingstringFound = $true
                        $matchedString = $comparedItem.Name
                    }
                    elseif ($itemBeingChecked.Name -match $comparedItem.Name) {
                        $superstringFound = $true
                        $subString = $comparedItem.Name
                    }
                }
            }


            if ($minDifference -gt 0.5) {
                Write-ToConsole -ForegroundColor Green ([char]0x221a + " " + $minDifference.ToString("0.00") + " to " + $maxDifference.ToString("0.00") + " " + $itemBeingChecked.Name + " ( ~ " + $resemblesString + ")")
                $dissimilarCount++
            }
            elseif ($minDifference -gt 0.25) {
                Write-ToConsole -ForegroundColor Yellow ("? " + $minDifference.ToString("0.00") + " to " + $maxDifference.ToString("0.00") + " " + $itemBeingChecked.Name + " ( ~ " + $resemblesString + ")")
                $similarCount++
            }
            else {
                Write-ToConsole -ForegroundColor Magenta ("! " + $minDifference.ToString("0.00") + " to " + $maxDifference.ToString("0.00") + " " + $itemBeingChecked.Name + " ( ~ " + $resemblesString + ")")
                $verySimilarCount++
            }

            if ($matchingstringFound) {
                Write-ToConsole -ForegroundColor Magenta ("! " + $itemBeingChecked.Name + " matches " + $matchedString)
                $matchCount++
            }

            if ($superstringFound) {
                Write-ToConsole -ForegroundColor Magenta ("! " + $itemBeingChecked.Name + " is a superstring of " + $subString)
                $superStringCount++
            }
        }

        if ($returnSummary) {
            return @($dissimilarCount, $similarCount, $verySimilarCount, $superStringCount, $matchCount, ($dissimilarCount + $similarCount + $verySimilarCount))
        }
        else {
            return $null
        }
    }

    [Hashtable] SpellcheckContentTitles([System.Collections.Generic.List[Object]] $contentList, [Bool] $returnResults) {

        [System.Collections.Hashtable] $spellcheckResults = [System.Collections.Hashtable]::new()

        # Initialise the spellcheck provider
        $this.SpellcheckProvider.Initialise()

        Write-InfoToConsole "Scanning ..."

        # Scan through all the titles building a word dictionary
        foreach ($contentItem in $contentList) {

            $splitTitle = ($contentItem.Title.Trim() -split " ") -replace "[^a-zA-Z0-9'-]", ""

            foreach ($word in $splitTitle) {

                if ($word.Length -gt 0) {

                    # try to find the word in the dictionary
                    $result = $spellcheckResults[$word]

                    # if not there
                    if ($null -eq $result) {
                        
                        # spellcheck if available
                        $result = [SpellcheckResult]::New($word, $this.SpellcheckProvider.CheckSpelling($word))
                        $result.AddRelatedContent($contentItem)

                        # if not correct, get suggestions
                        if ($result.IsCorrect -eq $false) {

                            # Add each suggestion
                            foreach ($suggestion in $this.SpellcheckProvider.GetSuggestions($word)) {
                                $result.AddSuggestion($suggestion)
                            }
                        }

                        $spellcheckResults.Add($word, $result)
                    }
                    else {
                        #otherwise, just add the content relationship to the existing item
                        $result.AddRelatedContent($contentItem)
                    }
                }
            }
        }

        # Dispose the provider
        $this.SpellcheckProvider.Dispose()

        # Output the results
        $this.DisplaySpellcheckSuggestions($spellcheckResults)

        # Return results if requested
        if ($returnResults) {
            return $spellcheckResults
        }
        else {
            return $null
        }
    }

    [Void] Hidden DisplaySpellcheckSuggestions([System.Collections.Hashtable] $spellcheckResults) {

        [Int] $maxWordLength = 0
        
        # Get the maximum length of an incorrect word for formatting purposes
        foreach ($word in $spellcheckResults.GetEnumerator()) {
            if (($word.Name.Length -gt $maxWordLength) -and (-not $word.Value.IsCorrect)) {
                $maxWordLength = $word.Key.Length
            }
        }

        # output a table header
        Write-ToConsole ""
        Write-ToConsole ("Word").PadRight($maxWordLength) "Suggestions"
        Write-ToConsole ("-" * $maxWordLength) ("-" * "Suggestions".Length)

        # output each incorrect word
        foreach ($word in $spellcheckResults.GetEnumerator()) {
            if (-not $word.Value.IsCorrect) {
                Write-WarnToConsole $word.Name.PadRight($maxWordLength + 1) -NoNewLine
                Write-ToConsole ($word.Value.Suggestions -join ", ")

                Add-ConsoleIndent
                Write-InfoToConsole "Found in:"
                Add-ConsoleIndent

                foreach ($content in $word.Value.FoundInTitleOfContent){
                    Write-InfoToConsole $content.Basename
                }

                Remove-ConsoleIndent
                Remove-ConsoleIndent
            }
        }
    }
    #endregion Methods
}
#endregion Class Definition