using module .\..\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\Helpers\ANSIEscapedString.Static.psm1

function Invoke-PesterTestAndGenerateCoverageReport () {

    Import-Module Pester -MinimumVersion 5.0.0
        
    Invoke-Pester $PSScriptRoot\..\*.Tests.ps1 `
                  -CodeCoverage $PSScriptRoot\..\..\PS.MediaCollectionManagement\* `
                  -CodeCoverageOutputFile $PSScriptRoot\..\coverage.xml `
                  -CodeCoverageOutputFileFormat JaCoCo

}

function Invoke-DetailedPesterTest () {

    Import-Module Pester -MinimumVersion 5.0.0
        
    Invoke-Pester -Output Detailed $PSScriptRoot\..\*.Tests.ps1

}


function Build-FriendlyCodeCoverageReport ([Switch] $UpdateMD ) {

    $maxCoverageUnits = 20
    $maxDisplayWidth = 100
    $grey = 90
    $green = 32
    $yellow = 33
    $red = 31
    $FriendlyMarkdownFile = "$PSScriptRoot\..\..\FriendlyCoverageReport.md"

    $h = Get-Host
    $screenWidth = [Math]::Min($h.UI.RawUI.WindowSize.Width, $maxDisplayWidth)
    $availablePackageWidth = $screenWidth - 2
    $availableClassWidth = $screenWidth - 4
    $availableSummaryWidth = $screenWidth - 36 - $maxCoverageUnits
    $availableCommandWidth = $screenWidth - 38 - $maxCoverageUnits
    $availableMethodWidth = $screenWidth - 40 - $maxCoverageUnits
    $classCount = 0
    $instructionCount = 0
    $totalIncludedExceptionCount = 0

    $knownExceptions = Get-KnownExceptions

    [Xml] $codeCoverageData = Get-Content $PSScriptRoot\..\Coverage.xml

    if ($UpdateMD.IsPresent) {
        "``````Friendly Coverage Report" | Out-File -FilePath $FriendlyMarkdownFile -Encoding utf8
        ("Generated on: " + (Get-Date).ToUniversalTime().ToString("dd MMMM yyyy HH:mm:ss UTC")) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8
        "" | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8
    }

    $output = ("Codebase".PadRight($availableSummaryWidth, " ") + " " + "Coverage".PadRight(22, " ") + " " + " Cov/Tot " + " " + "Exc " + " " + "Cov %  " + " " + "E Cov %")
    Write-InfoToConsole $output
    if ($UpdateMD.IsPresent) { ([ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

    $output = ("--------".PadRight($availableSummaryWidth, "-") + " " + "--------".PadRight(22, "-") + " " + "---------" + " " + "----" + " " + "-------" + " " + "-------")
    Write-InfoToConsole $output
    if ($UpdateMD.IsPresent) { ([ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

    foreach ($package in $codeCoverageData.report[1].package) {
        $output = ([ANSIEscapedString]::Colourise([ANSIEscapedString]::FixedWidth($package.name, $availablePackageWidth, $true), $grey))
        Write-InfoToConsole $output
        if ($UpdateMD.IsPresent) { ([ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }
        Add-ConsoleIndent

        foreach ($class in $package.class) {

            $classCount++
            $className = Split-Path $class.name -Leaf

            if (($class.method.GetType() -eq [System.Xml.XmlElement]) -and ($className -eq $class.method.name)) {
                
                # process results as a command

                if ($knownExceptions.ContainsKey($package.name + "|" + $class.method.name)) {
                    $includeExceptionCount = $knownExceptions[$package.name + "|" + $class.method.name]
                    $includeExceptionString = "+" + [String]$includeExceptionCount
                    $totalIncludedExceptionCount += $includeExceptionCount
                }
                else {
                    $includeExceptionCount = 0
                    $includeExceptionString = ""
                }

                $instructionCounter = $class.method.counter | Where-Object {$_.type -eq "INSTRUCTION"}
                $instructionCount += $instructionCounter.covered
                $coverage = [Math]::Round(([Int]$instructionCounter.covered) / ([Int]$instructionCounter.covered + [Int]$instructionCounter.missed),4)
                $exceptionCoverage = [Math]::Round(([Int]$instructionCounter.covered + [Int]$includeExceptionCount) / ([Int]$instructionCounter.covered + [Int]$instructionCounter.missed),4)
                [Int]$coverageUnits = [Math]::Floor([Decimal]$coverage * $maxCoverageUnits)
                [Int]$exceptionCoverageUnits = [Math]::Floor([Decimal]($exceptionCoverage - $coverage) * $maxCoverageUnits)
                $coveredPercentage = $coverage.ToString("P")
                $exceptionCoveragePercentage = $exceptionCoverage.ToString("P")

                if ( $instructionCounter.missed -eq 0 ) { $coverageColour = $green }
                elseif ( $coverage -ge 0.75 ) { $coverageColour = $yellow }
                else { $coverageColour = $red }

                if ( ($instructionCounter.missed - $includeExceptionCount) -le 0 ) { $exceptionCoverageColour = $green }
                elseif ( $exceptionCoverage -ge 0.75 ) { $exceptionCoverageColour = $yellow }
                else { $exceptionCoverageColour = $red }

                $output = ""
                $output += [ANSIEscapedString]::FixedWidth($class.method.name, $availableCommandWidth, $true)
                $output += " ["
                $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cf) * [Int]$coverageUnits, $exceptionCoverageColour)
                $output += [ANSIEscapedString]::Colourise([String]$([char]0x25b2) * [Int]$exceptionCoverageUnits, $exceptionCoverageColour)
                $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cb) * ($maxCoverageUnits - [Int]$coverageUnits - [Int]$exceptionCoverageUnits), $grey)
                $output += "]"
                $output += [ANSIEscapedString]::Colourise(" " + $instructionCounter.covered.PadLeft(4," ") + "/" + ([String]([Int]$instructionCounter.covered + [Int]$instructionCounter.missed)).PadRight(4," ") + " ", $coverageColour)
                $output += [ANSIEscapedString]::Colourise($includeExceptionString.PadRight(4," "), $exceptionCoverageColour)
                $output += [ANSIEscapedString]::Colourise($coveredPercentage.PadLeft(8," "), $coverageColour)
                $output += [ANSIEscapedString]::Colourise($exceptionCoveragePercentage.PadLeft(8," "), $exceptionCoverageColour)

                Write-InfoToConsole $output
                if ($UpdateMD.IsPresent) { ("  " + [ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

            }
            else {

                # process as a class with one or more methods
                $output = ([ANSIEscapedString]::Colourise([ANSIEscapedString]::FixedWidth($className, $availableClassWidth, $true), $grey))
                Write-InfoToConsole $output
                if ($UpdateMD.IsPresent) { ("  " + [ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8}
                Add-ConsoleIndent

                foreach ($method in $class.method) {

                    if ($knownExceptions.ContainsKey($package.name + "|" + $className + "|" + $method.name)) {
                        $includeExceptionCount = $knownExceptions[$package.name + "|" + $className + "|" + $method.name]
                        $includeExceptionString = "+" + [String]$includeExceptionCount
                        $totalIncludedExceptionCount += $includeExceptionCount
                    }
                    else {
                        $includeExceptionCount = 0
                        $includeExceptionString = ""
                    }

                    $instructionCounter = $method.counter | Where-Object {$_.type -eq "INSTRUCTION"}
                    $instructionCount += $instructionCounter.covered
                    $coverage = [Math]::Round(([Int]$instructionCounter.covered) / ([Int]$instructionCounter.covered + [Int]$instructionCounter.missed),4)
                    $exceptionCoverage = [Math]::Round(([Int]$instructionCounter.covered + [Int]$includeExceptionCount) / ([Int]$instructionCounter.covered + [Int]$instructionCounter.missed),4)
                    [Int]$coverageUnits = [Math]::Floor([Decimal]$coverage * $maxCoverageUnits)
                    [Int]$exceptionCoverageUnits = [Math]::Floor([Decimal]($exceptionCoverage - $coverage) * $maxCoverageUnits)
                    $coveredPercentage = $coverage.ToString("P")
                    $exceptionCoveragePercentage = $exceptionCoverage.ToString("P")

                    if ( $instructionCounter.missed -eq 0 ) { $coverageColour = $green }
                    elseif ( $coverage -ge 0.75 ) { $coverageColour = $yellow }
                    else { $coverageColour = $red }

                    if ( ($instructionCounter.missed - $includeExceptionCount) -le 0 ) { $exceptionCoverageColour = $green }
                    elseif ( $exceptionCoverage -ge 0.75 ) { $exceptionCoverageColour = $yellow }
                    else { $exceptionCoverageColour = $red }

                    $output = ""
                    $output += [ANSIEscapedString]::FixedWidth($method.name, $availableMethodWidth, $true)
                    $output += " ["
                    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cf) * [Int]$coverageUnits, $exceptionCoverageColour)
                    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25b2) * [Int]$exceptionCoverageUnits, $exceptionCoverageColour)
                    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cb) * ($maxCoverageUnits - [Int]$coverageUnits - [Int]$exceptionCoverageUnits), $grey)
                    $output += "]"
                    $output += [ANSIEscapedString]::Colourise(" " + $instructionCounter.covered.PadLeft(4," ") + "/" + ([String]([Int]$instructionCounter.covered + [Int]$instructionCounter.missed)).PadRight(4," ") + " ", $coverageColour)
                    $output += [ANSIEscapedString]::Colourise($includeExceptionString.PadRight(4," "), $exceptionCoverageColour)
                    $output += [ANSIEscapedString]::Colourise($coveredPercentage.PadLeft(8," "), $coverageColour)
                    $output += [ANSIEscapedString]::Colourise($exceptionCoveragePercentage.PadLeft(8," "), $exceptionCoverageColour)

                    Write-InfoToConsole $output
                    if ($UpdateMD.IsPresent) { ("    " + [ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

                }

                Remove-ConsoleIndent
                Write-InfoToConsole  
                if ($UpdateMD.IsPresent) { "" | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 } 

            }

        }

        Remove-ConsoleIndent
        Write-InfoToConsole
        if ($UpdateMD.IsPresent) { "" | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }
    }

    $instructionCounter = $codeCoverageData.report[1].counter | Where-Object {$_.type -eq "INSTRUCTION"}
    $coverage = [Math]::Round(([Int]$instructionCounter.covered) / ([Int]$instructionCounter.covered + [Int]$instructionCounter.missed),4)
    [Int]$coverageUnits = [Math]::Floor([Decimal]$coverage * $maxCoverageUnits)
    $exceptionCoverage = [Math]::Round(([Int]$instructionCounter.covered + [Int]$totalIncludedExceptionCount) / ([Int]$instructionCounter.covered + [Int]$instructionCounter.missed),4)
    [Int]$coverageUnits = [Math]::Floor([Decimal]$coverage * $maxCoverageUnits)
    [Int]$exceptionCoverageUnits = [Math]::Floor([Decimal]($exceptionCoverage - $coverage) * $maxCoverageUnits)
    $coveredPercentage = $coverage.ToString("P")
    $exceptionCoveragePercentage = $exceptionCoverage.ToString("P")

    $includeExceptionString = "+" + [String]$totalIncludedExceptionCount

    if ( $instructionCounter.missed -eq 0 ) { $coverageColour = $green }
    elseif ( $coverage -ge 0.75 ) { $coverageColour = $yellow }
    else { $coverageColour = $red }

    if ( ($instructionCounter.missed - $includeExceptionCount) -le 0 ) { $exceptionCoverageColour = $green }
    elseif ( $exceptionCoverage -ge 0.75 ) { $exceptionCoverageColour = $yellow }
    else { $exceptionCoverageColour = $red }

    $output = ""
    $output += [ANSIEscapedString]::FixedWidth("Overall coverage:", $availableSummaryWidth, $true)
    $output += " ["
    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cf) * [Int]$coverageUnits, $exceptionCoverageColour)
    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25b2) * [Int]$exceptionCoverageUnits, $exceptionCoverageColour)
    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cb) * ($maxCoverageUnits - [Int]$coverageUnits - [Int]$exceptionCoverageUnits), $grey)
    $output += "]"
    $output += [ANSIEscapedString]::Colourise(" " + $instructionCounter.covered.PadLeft(4," ") + "/" + ([String]([Int]$instructionCounter.covered + [Int]$instructionCounter.missed)).PadRight(4," ") + " ", $coverageColour)
    $output += [ANSIEscapedString]::Colourise($includeExceptionString.PadRight(4," "), $exceptionCoverageColour)
    $output += [ANSIEscapedString]::Colourise($coveredPercentage.PadLeft(8," "), $coverageColour)
    $output += [ANSIEscapedString]::Colourise($exceptionCoveragePercentage.PadLeft(8," "), $exceptionCoverageColour)

    Write-InfoToConsole
    if ($UpdateMD.IsPresent) { "" | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

    Write-InfoToConsole $output
    if ($UpdateMD.IsPresent) { ([ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

    $output = "  ($($classCount) files, $($instructionCount) instructions)"
    Write-InfoToConsole $output
    if ($UpdateMD.IsPresent) { ([ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

    if ($UpdateMD.IsPresent) {
        "``````" | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8
    }
}

function Get-KnownExceptions () {
    $exceptionsList = @{}
    
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|CopyModel", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|MergeModels", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|Compare", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|TestFilesystemHashes", 1)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|RemodelFilenameFormat", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AlterActor", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AlterAlbum", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AlterArtist", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AlterSeries", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AlterStudio", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AlterSeasonEpisodeFormat", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AlterTrackFormat", 3)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AnalyseActorsForPossibleLabellingIssues", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AnalyseAlbumsForPossibleLabellingIssues", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AnalyseArtistsForPossibleLabellingIssues", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AnalyseSeriesForPossibleLabellingIssues", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|AnalyseStudiosForPossibleLabellingIssues", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentModel.Interface|SpellcheckContentTitles", 1)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentSubjectBO.Interface|ActsOnType", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentSubjectBO.Interface|ActsOnFilenameElement", 1)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFiles", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFileIfExists", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|FileExists", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GenerateHash", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|CheckFilesystemHash", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFileMetadataProperty", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFileMetadataProperties", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|UpdateFileName", 2)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelAnalysisHandler.Interface|AnalysePossibleLabellingIssues", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelAnalysisHandler.Interface|SpellcheckContentTitles", 1)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|RemodelFilenameFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AlterSeasonEpisodeFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AlterTrackFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AlterSubject", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AddContentToModel", 1)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelPersistenceHandler.Interface|LoadConfigFromIndexFile", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelPersistenceHandler.Interface|RetrieveDataFromIndexFile", 1)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ISpellcheckProvider.Interface|Initialise", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ISpellcheckProvider.Interface|CheckSpelling", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ISpellcheckProvider.Interface|GetSuggestions", 1)

    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IStringSimilarityProvider.Interface|GetNormalisedDistanceBetween", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IStringSimilarityProvider.Interface|GetRawDistanceBetween", 2)

    $exceptionsList.Add("PS.MediaCollectionManagement/Shared/Using/Base|IsAbstract.Class|IsAbstract", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/Shared/Using/Base|IsAbstract.Class|AssertAsAbstract", 2)

    return $exceptionsList
}