#region Header
#
# About: Handlers Layer Class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\ModelManipulationHandler.Class.psm1
using module .\ModelPersistenceHandler.Class.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\Interfaces\ICommandHandler.Interface.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\ContentComparer.Class.psm1
using module .\..\BusinessObjects\ContentModelConfigBO.Class.psm1
using module .\..\BusinessObjects\ContentBO.Class.psm1
using module .\..\Interfaces\IFilesystemProvider.Interface.psm1
#endregion Using


#region Class Definition
#-----------------------
class CommandHandler : ICommandHandler {

    #region Properties
    #endregion Properties


    #region Constructors
    #endregion Constructors
    
    
    #region Implemented Methods
    [IContentModel] CopyModel ([IContentModel] $source) {
    
        # Set starting state
        $i = 0
        [ContentModelConfigBO] $configBO = [ContentModelConfigBO]::new()

        # Instantiate a new ContentModel
        [IContentModel] $copy = New-ContentModel

        # Copy the config
        $configBO.CloneCopy($source.Config, $copy.Config)

        # Initialise the ContentModel
        $copy.Init()

        [ModelManipulationHandler] $manipulationHandler = [ModelManipulationHandler]::new($copy)
        [ContentBO] $contentBO = [ContentBO]::new($copy.Config)

        # for each file
        foreach ($item in $source.Content) {    
            
            # Show a progress bar
            Write-Progress -Activity "Copying Model" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $source.Content.count)

            # Add the content to the model
            [Content] $addedContent = $manipulationHandler.AddContentToModel($item.FileName, $item.BaseName, $item.Extension, $null)

            # Add content Properties
            $contentBO.CopyPropertiesHashAndWarnings($item, $addedContent)

            # Increment the counter
            $i++
        
        }

        # Hide the progress bar
        Write-Progress -Activity "Copying Model" -Completed
        #>
        return $copy
    }

    [IContentModel] MergeModels ([IContentModel] $contentModelA, [IContentModel] $contentModelB) {

        # Set starting state
        $i = 0
        $totalItems = $contentModelA.Content.count + $contentModelB.Content.count
        [ContentModelConfigBO] $configBO = [ContentModelConfigBO]::new()

        # Confirm the two configs match
        if ( -not ( $configBO.IsMatch($contentModelA.Config, $contentModelB.Config) ) ) {
            Write-WarnToConsole "Cannot Merge. Source configurations do not match, abandoning action."
            return $null
        }

        # Instantiate a new ContentModel
        [IContentModel] $merge = New-ContentModel

        # Copy the config
        $configBO.CloneCopy($contentModelA.Config, $merge.Config)

        # Initialise the ContentModel
        $merge.Init()

        [ModelManipulationHandler] $manipulationHandler = [ModelManipulationHandler]::new($merge)
        [ContentBO] $contentBO = [ContentBO]::new($merge.Config)

        # for each file
        foreach ($item in $contentModelA.Content) {    
            
            # Show a progress bar
            Write-Progress -Activity "Cloning Source A" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $totalItems)

            # Add the content to the model
            $addedContent = $manipulationHandler.AddContentToModel($item.FileName, $item.BaseName, $item.Extension, $null)

            # Add content Properties
            $contentBO.CopyPropertiesHashAndWarnings($item, $addedContent)

            # Increment the counter
            $i++
        
        }

        # Hide the progress bar
        Write-Progress -Activity "Cloning Source A" -Completed
        #>

        # for each file
        foreach ($item in $contentModelB.Content) {    
            
            # Show a progress bar
            Write-Progress -Activity "Merging B Into Clone" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $totalItems)

            # Add the content to the model
            $addedContent = $manipulationHandler.AddContentToModel($item.FileName, $item.BaseName, $item.Extension, $null)

            # Add content Properties if not duplicate
            if ([ContentWarning]::DuplicateDetectedInSources -in $addedContent.Warnings) {
                if ($addedContent.AlteredBaseName -ne $item.AlteredBaseName -or
                    $addedContent.PendingFilenameUpdate -ne $item.PendingFilenameUpdate -or
                    $addedContent.FrameWidth -ne $item.FrameWidth -or
                    $addedContent.FrameHeight -ne $item.FrameHeight -or
                    $addedContent.FrameRate -ne $item.FrameRate -or
                    $addedContent.BitRate -ne $item.BitRate -or
                    $addedContent.TimeSpan -ne $item.TimeSpan -or
                    $addedContent.Hash -ne $item.Hash) {
                    
                    $addedContent.AddWarning([ContentWarning]::MergeConflictsInData)
                }
            }
            else {
                # Add content Properties
                $contentBO.CopyPropertiesHashAndWarnings($item, $addedContent)
            }

            # Increment the counter
            $i++
        
        }

        # Hide the progress bar
        Write-Progress -Activity "Merging B Into Clone" -Completed
        #>

        # Resort the list
        Write-InfoToConsole "Resorting the list"
        $comp = [ContentComparer]::new("FileName")
        $merge.Content.Sort($comp)

        if ($merge.Content.Warnings.Count -gt 0) {
            $this.ProvideConsoleTipsForMergeWarnings()
        }

        return $merge
    }

    [System.Array] Compare ([Object] $baseline, [Object] $comparison, [IFilesystemProvider] $filesystemProvider, [Bool] $returnSummary) { 

        [Int] $match = 0
        [Int] $partialOnFileName = 0
        [Int] $partialOnHash = 0
        [Int] $notInComparison = 0
        [Int] $multiplePossibleMatches = 0
        [Int] $badDataInComparisonSet = 0 
        
        [System.Collections.Generic.List[Object]] $output = [System.Collections.Generic.List[Object]]::new()

        [System.Array] $baselineContentList = $this.ValidateComparisonInputAndRetrieveAsContent($baseline, $filesystemProvider)
        [System.Array] $comparisonContentList = $this.ValidateComparisonInputAndRetrieveAsContent($comparison, $filesystemProvider)

        if (($null -eq $baselineContentList) -or ($null -eq $comparisonContentList)) {
            return $null
        }

        $i = 0

        # For each item in the source
        foreach ($item in $baselineContentList) {
            
            # Show/Update a progress bar
            Write-Progress -Activity "Comparing Items" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $baselineContentList.count)

            # Seek a match by filename
            $matching = $comparisonContentList | Where-Object {$_.FileName -eq $item.FileName}

            if ($matching -is [Array]) {
                
                # If the match is an array, flag multiple matches in the output
                $outputRow = [PSCustomObject]::new()
                $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                $outputRow | Add-Member NoteProperty "Result" "[X][X] A{B [!][ ]"
                $outputRow | Add-Member NoteProperty "Comparison" " -- Bad data: Duplicate filenames detected --" 
                $outputRow | Add-Member NoteProperty "Color" 91 # Red

                $output.Add($outputRow)

                $badDataInComparisonSet++

            }
            elseif ($null -eq $matching) {

                if ([String]::IsNullOrEmpty($item.Hash)) {

                    # If the baseline hash is not set, then flag no match
                    $outputRow = [PSCustomObject]::new()
                    $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                    $outputRow | Add-Member NoteProperty "Result" "[X][ ] A$([char]0x2260)  [ ][ ]"
                    $outputRow | Add-Member NoteProperty "Comparison" " -- No match on filename, baseline hash not known --" 
                    $outputRow | Add-Member NoteProperty "Color" 95 # Magenta

                    $output.Add($outputRow)

                    $notInComparison++

                }
                else { # Otherwise try to match on Hash

                    $matching = $comparisonContentList | Where-Object {$_.Hash -eq $item.Hash}
                    
                    if ($matching -is [Array]) {
                        
                        # If the match is an array, flag multiple matches in the output                
                        $outputRow = [PSCustomObject]::new()
                        $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                        $outputRow | Add-Member NoteProperty "Result" "[X][X] A{B [ ][?]"
                        $outputRow | Add-Member NoteProperty "Comparison" " -- Multiple possible matches on hash --" 
                        $outputRow | Add-Member NoteProperty "Color" 93 # Yellow

                        $output.Add($outputRow)

                        $multiplePossibleMatches++
                    }
                    elseif ($null -eq $matching) {
                        
                        # If no hash match was found either, flag no matches in the output
                        $outputRow = [PSCustomObject]::new()
                        $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                        $outputRow | Add-Member NoteProperty "Result" "[X][X] A$([char]0x2260)  [ ][ ]"
                        $outputRow | Add-Member NoteProperty "Comparison" " -- No match on filename or hash --" 
                        $outputRow | Add-Member NoteProperty "Color" 95 # Magenta

                        $output.Add($outputRow)

                        $notInComparison++
                    }
                    else {
                        
                        # otherwise, flag a partial match in the output
                        $outputRow = [PSCustomObject]::new()
                        $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                        $outputRow | Add-Member NoteProperty "Result" "[X][X] A$([char]0x2248)B [ ][X]"
                        $outputRow | Add-Member NoteProperty "Comparison" $matching.Filename 
                        $outputRow | Add-Member NoteProperty "Color" 96 # Cyan

                        $output.Add($outputRow)

                        $partialOnHash++
                    }
                }
                
            }
            else {   # If a single filename match was found ...
                
                if ([String]::IsNullOrEmpty($item.Hash)) {
                    # And the baseline hash is not set, then flag a partial match
                    $outputRow = [PSCustomObject]::new()
                    $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                    $outputRow | Add-Member NoteProperty "Result" "[X][ ] A$([char]0x2248)B [X][ ]"
                    $outputRow | Add-Member NoteProperty "Comparison" $matching.Filename
                    $outputRow | Add-Member NoteProperty "Color" 96 # Cyan

                    $output.Add($outputRow)

                    $partialOnFileName++

                }
                elseif ($item.Hash -eq $matching.Hash) {
                    
                    # And the hashes also match, then flag a match in the output 
                    $outputRow = [PSCustomObject]::new()
                    $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                    $outputRow | Add-Member NoteProperty "Result" "[X][X] A=B [X][X]"
                    $outputRow | Add-Member NoteProperty "Comparison" $matching.Filename
                    $outputRow | Add-Member NoteProperty "Color" 92 # Green

                    $output.Add($outputRow)

                    $match++
                }
                else {

                    # otherwise, flag a partial match in the output
                    $outputRow = [PSCustomObject]::new()
                    $outputRow | Add-Member NoteProperty "Baseline" $item.FileName
                    $outputRow | Add-Member NoteProperty "Result" "[X][X] A$([char]0x2248)B [X][ ]"
                    $outputRow | Add-Member NoteProperty "Comparison" $matching.Filename
                    $outputRow | Add-Member NoteProperty "Color" 96 # Cyan

                    $output.Add($outputRow)

                    $partialOnFileName++
                }
            }

            $i++
        }

        # Remove the progress bar
        Write-Progress -Activity "Comparing Items" -Completed

        $h = Get-Host
        $screenWidth = $h.UI.RawUI.WindowSize.Width
        $filenameWidth = [Int](($screenWidth - 18) / 2) - 2

        Write-FormattedTableToConsole -ColumnHeadings @("Baseline", "F  H  Res  F  H  ", "Comparison") -ColumnProperties @("Baseline", "Result", "Comparison") -ColumnWidths @($filenameWidth, 18, $filenameWidth) -ColumnColors @(0, 0, 0) -AcceptColumnColorsFromInputIfAvailable @($false, $true, $true) -Object $output

        # Then output the summary
        Write-InfoToConsole ""
        Write-ToConsole -ForegroundColor Green ([String]$match).PadLeft(5," ") -NoNewLine 
        Write-InfoToConsole " Matches" 
        Write-ToConsole -ForegroundColor Cyan ([String]$partialOnFileName).PadLeft(5," ") -NoNewLine 
        Write-InfoToConsole " Partial match on filename" 
        Write-ToConsole -ForegroundColor Cyan ([String]$partialOnHash).PadLeft(5," ") -NoNewLine 
        Write-InfoToConsole " Partial match on hash" 
        Write-ToConsole -ForegroundColor Yellow ([String]$multiplePossibleMatches).PadLeft(5," ") -NoNewLine 
        Write-InfoToConsole " Multiple possible matches" 
        Write-ToConsole -ForegroundColor Magenta ([String]$notInComparison).PadLeft(5," ") -NoNewLine 
        Write-InfoToConsole " Not in comparison"
        Write-ToConsole -ForegroundColor Red ([String]$badDataInComparisonSet).PadLeft(5," ") -NoNewLine 
        Write-InfoToConsole " Duplicate filenames in comparison set"
        Write-ToConsole -ForegroundColor White ([String]$baseline.Count).PadLeft(5," ") -NoNewLine 
        Write-InfoToConsole " Total"

        if ($returnSummary) {
            return @($match, $partialOnFileName, $partialOnHash, $multiplePossibleMatches, $notInComparison, $badDataInComparisonSet, $baselineContentList.Count)
        }
        else {
            return $null
        }
    }

    [System.Array] TestFilesystemHashes ([IContentModel] $contentModel, [IFilesystemProvider] $filesystemProvider, [Bool] $ReturnSummary) {

        [System.Collections.Generic.List[Object]] $output = [System.Collections.Generic.List[Object]]::new()
        [Int] $verified = 0
        [Int] $discrepancy = 0
        [Int] $i = 0

        if (-not $filesystemProvider.HasValidPath) {
            Write-ErrorToConsole "Error: Invalid path provided. Unable to test, abandoning action."
            return $null
        }

        # for each file
        foreach ($item in $contentModel.Content) {    
            
            # Show a progress bar
            Write-Progress -Activity "Verifying Filesystem Hashes" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $contentModel.Content.count)

            if ($filesystemProvider.CheckFilesystemHash($item.Hash, $item.FileName)) {
                $outputRow = [PSCustomObject]::new()
                $outputRow | Add-Member NoteProperty "Content" $item.FileName
                $outputRow | Add-Member NoteProperty "Verified" "[X]"
                $outputRow | Add-Member NoteProperty "Color" 92 # Green

                $verified++
            }
            else {
                $outputRow = [PSCustomObject]::new()
                $outputRow | Add-Member NoteProperty "Content" $item.FileName
                $outputRow | Add-Member NoteProperty "Verified" "[X]"
                $outputRow | Add-Member NoteProperty "Color" 95 # Magenta

                $discrepancy++
            }

            $output.Add($outputRow)

            # Increment the counter
            $i++
        
        }

        # Hide the progress bar
        Write-Progress -Activity "Verifying Filesystem Hashes" -Completed

        $h = Get-Host
        $screenWidth = $h.UI.RawUI.WindowSize.Width
        $filenameWidth = [Int]($screenWidth - 9) - 2

        if ($ReturnSummary) {
            return @($verified, $discrepancy, $contentModel.Content.Count)
        }
        else {
            Write-FormattedTableToConsole -ColumnHeadings @("Verified", "Content") -ColumnProperties @("Verified", "Content") -ColumnWidths @(9, $filenameWidth) -ColumnColors @(0, 0) -AcceptColumnColorsFromInputIfAvailable @($true, $true) -Object $output
            return $null
        }
    }
    #endregion Implemented Methods

    #region Internal Methods
    [System.Array] ValidateComparisonInputAndRetrieveAsContent ([Object] $inputToCompare, [IFilesystemProvider] $filesystemProvider) {
        
        [Bool] $inputIsAPath = $false
        [Bool] $inputIsAFile = $false
        [Bool] $inputIsAModel = $false

        # decide if the input is valid and if so how to interpret it
        if ($inputToCompare -is [String]) {
            if (Test-Path -PathType Leaf $inputToCompare) {
                $inputIsAFile = $true
            }
            elseif (Test-Path -PathType Container $inputToCompare) {
                $inputIsAPath = $true
            }
            else {
                Write-ErrorToConsole "Error: Invalid filepath string for an input. Strings must be a valid file or path."
                return $null
            }
        }
        elseif ($inputToCompare -is [IContentModel]) {
            $inputIsAModel = $true
        }
        else {
            Write-ErrorToConsole "Error: Inputs of type $($inputToCompare.GetType()) are not supported."
            return $null
        }

        # if input is a path then return a minimal build, with hashes but no model subjects or properties
        if ($inputIsAPath) {

            if (-not $filesystemProvider.HasValidPath) {
                Write-ErrorToConsole "Error: Invalid path provided. Unable to compare, abandoning action."
                return $null
            }

            [ModelManipulationHandler] $handler = [ModelManipulationHandler]::new((New-ContentModel))
            $filesystemProvider.ChangePath($inputToCompare)
            $handler.Build($false, $true, $filesystemProvider)

            return $handler.ContentModel.Content
        }

        # if the input is a file then return a minimial load, which gives us the dataset sufficiently close to a model to be compared.
        if ($inputIsAFile) {

            [ModelPersistenceHandler] $handler = [ModelPersistenceHandler]::new()
            return $handler.RetrieveDataFromIndexFile($inputToCompare)

        }

        # if already a model, then the just return the content.
        if ($inputIsAModel) {
            return $inputToCompare.Content
        }

        return $null
    }

    [Void] Hidden ProvideConsoleTipsForMergeWarnings() {

        Write-InfoToConsole ""
        Write-InfoToConsole "Duplicates detected. To identify problematic content, try:"
        Add-ConsoleIndent
        Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::DuplicateDetectedInSources}"
        Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::MergeConflictsInData}"
        Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings.Count -gt 0}"
        Remove-ConsoleIndent
    }
    #endregion Internal Methods
}
#endregion Class Definition