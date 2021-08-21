using module .\..\Using\ObjectModels\PS.MCM.ContentModel.Class.psm1
using module .\..\Using\ModuleBehaviour\PS.MCM.ModuleSettings.Abstract.psm1
using module .\..\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1


<#
    .SYNOPSIS
    Compares two ContentModels and/or FileIndexes.

    .DESCRIPTION
    Allows a ContentModel or a FileIndex to be compared against a baseline. Effective when merging to sets of content, or when comparing current content against a known good FileIndex.    

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Compare-FileIndex $contentModel $contentModel2

    .EXAMPLE
    PS> Compare-FileIndex $contentModel "./Index.json"
    
    .EXAMPLE
    PS> Compare-FileIndex "./Index.json" $contentModel 

    .EXAMPLE
    PS> Compare-FileIndex "./CurrentIndex.json" "./PastIndex.json"
#>
function Compare-ContentModels (

    # FileIndex baseline of comparison  
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="F2F")]
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="F2M")]
    [String] $baselineFilePath,
    
    # ContentModel baseline of comparison  
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="M2F")]
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="M2M")]
    [ContentModel] $baselineContentModel,
    
    # FileIndex to compare  
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="F2F")]
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="M2F")]
    [String] $comparisonFilePath,
    
    # ContentModel basis of comparison  
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="F2M")]
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="M2M")]
    [ContentModel] $comparisonContentModel,

    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="F2F")]
    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="F2M")]
    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="M2F")]
    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="M2M")]
    [Switch] $ReturnSummary
){
    [Int] $match = 0
    [Int] $partialOnFileName = 0
    [Int] $partialOnHash = 0
    [Int] $notInComparison = 0
    [Int] $multiplePossibleMatches = 0
    [Int] $badDataInComparisonSet = 0 
    [System.Collections.Generic.List[Object]] $output = [System.Collections.Generic.List[Object]]::new()

    # Initialise the baseline of the comparison
    if ($PSBoundParameters.ContainsKey('baselineFilePath')) {

        # Test the path is valid
        if (-not (Test-Path $baselineFilePath)) {
            Write-ErrorToConsole "Error: Invalid baseline filepath"
            return
        }

        # Load it
        $incomingA = Get-Content -Raw -Path $baselineFilePath | ConvertFrom-Json

        # Test the file format
        if (-not (([Bool]($incomingA.PSObject.Properties.Name -match "FileType")) -and 
                  ([Bool]($incomingA.PSObject.Properties.Name -match "Config")) -and 
                  ([Bool]($incomingA.PSObject.Properties.Name -match "Content")) -and 
                  ($incomingA.FileType -eq [ModuleSettings]::DEFAULT_MODULE_FILETYPE()))) {
            Write-ErrorToConsole "Error: Baseline is not a valid" ([ModuleSettings]::DEFAULT_MODULE_FILETYPE()) "filetype."
            return
        }

        
        # Set the baseline object model
        $baseline = $incomingA.Content
    }
    elseif ($PSBoundParameters.ContainsKey('baselineContentModel')) {

        # If the baseline is a content model, set it as the source object model
        $baseline = $baselineContentModel.Content
    }
    else {
        Write-ErrorToConsole "Error: Invalid Parameters"
        return
    }

    # Initialise the comparison
    if ($PSBoundParameters.ContainsKey('comparisonFilePath')) {
        
        # Test the path is valid
        if (-not (Test-Path $comparisonFilePath)) {
            Write-ErrorToConsole "Error: Invalid baseline filepath"
            return
        }

        # Load it
        $incomingB = Get-Content -Raw -Path $comparisonFilePath | ConvertFrom-Json

        # Test the file format
        if (-not (([Bool]($incomingB.PSObject.Properties.Name -match "FileType")) -and 
                  ([Bool]($incomingB.PSObject.Properties.Name -match "Config")) -and 
                  ([Bool]($incomingB.PSObject.Properties.Name -match "Content")) -and 
                  ($incomingB.FileType -eq [ModuleSettings]::DEFAULT_MODULE_FILETYPE()))) {
            Write-ErrorToConsole "Error: Comparison is not a valid" ([ModuleSettings]::DEFAULT_MODULE_FILETYPE()) "filetype."
            return
        }
        
        # Set the comparison object model
        $comparison = $incomingB.Content
    }
    elseif ($PSBoundParameters.ContainsKey('comparisonContentModel')) {

        # If the comparison is a content model, set it as the source object model
        $comparison = $comparisonContentModel.Content
    }
    else {
        Write-ErrorToConsole "Error: Invalid Parameters"
        return
    }  

    $i = 0

    # For each item in the source
    foreach ($item in $baseline) {
        
        # Show/Update a progress bar
        Write-Progress -Activity "Comparing Items" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $baseline.count)

        # Seek a match by filename
        $matching = $comparison | Where-Object {$_.FileName -eq $item.FileName}

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

                $matching = $comparison | Where-Object {$_.Hash -eq $item.Hash}
                
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

    $screenWidth = $Host.UI.RawUI.WindowSize.Width
    $filenameWidth = [Int](($screenWidth - 18) / 2) - 2

    if ([TestAttribute]::SuppressConsoleOutput -notin [ModuleState]::Testing_States) {
        Write-FormattedTableToConsole -ColumnHeadings @("Baseline", "F  H  Res  F  H  ", "Comparison") -ColumnProperties @("Baseline", "Result", "Comparison") -ColumnWidths @($filenameWidth, 18, $filenameWidth) -ColumnColors @(0, 0, 0) -AcceptColumnColorsFromInputIfAvailable @($false, $true, $true) -Object $output
    }

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

    if ($ReturnSummary.IsPresent) {
        return @($match, $partialOnFileName, $partialOnHash, $multiplePossibleMatches, $notInComparison, $badDataInComparisonSet, $baseline.Count)
    }
    else {
        return
    }
}