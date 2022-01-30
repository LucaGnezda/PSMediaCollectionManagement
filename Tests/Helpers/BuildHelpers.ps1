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
    $maxDisplayWidth = 115
    $grey = 90
    $green = 32
    $yellow = 33
    $red = 31
    $FriendlyMarkdownFile = "$PSScriptRoot\..\..\FriendlyCoverageReport.md"

    $h = Get-Host
    $screenWidth = [Math]::Min($h.UI.RawUI.WindowSize.Width, $maxDisplayWidth)
    $availablePackageWidth = $screenWidth - 2
    $availableClassWidth = $screenWidth - 4
    $availableSummaryWidth = $screenWidth - 42 - $maxCoverageUnits
    $availableCommandWidth = $screenWidth - 44 - $maxCoverageUnits
    $availableMethodWidth = $screenWidth - 46 - $maxCoverageUnits
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

    $output = ("Codebase".PadRight($availableSummaryWidth, " ") + " " + "Coverage".PadRight(22, " ") + " " + " Cov/Tot " + " " + "Exc " + " " + "Coverage %" + " " + "E Coverage %")
    Write-InfoToConsole $output
    if ($UpdateMD.IsPresent) { ([ANSIEscapedString]::Strip($output)) | Out-File -FilePath $FriendlyMarkdownFile -Append -Encoding utf8 }

    $output = ("--------".PadRight($availableSummaryWidth, "-") + " " + "--------".PadRight(22, "-") + " " + "---------" + " " + "----" + " " + "-----------" + " " + "-----------")
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
                [Int]$exceptionCoverageUnits = [Math]::Floor([Decimal]$exceptionCoverage * $maxCoverageUnits)
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
                $output += [ANSIEscapedString]::Colourise([String]$([char]0x25b2) * ([Int]$exceptionCoverageUnits - [Int]$coverageUnits), $exceptionCoverageColour)
                $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cb) * ($maxCoverageUnits - [Int]$exceptionCoverageUnits), $grey)
                $output += "]"
                $output += [ANSIEscapedString]::Colourise(" " + $instructionCounter.covered.PadLeft(4," ") + "/" + ([String]([Int]$instructionCounter.covered + [Int]$instructionCounter.missed)).PadRight(4," ") + " ", $coverageColour)
                $output += [ANSIEscapedString]::Colourise($includeExceptionString.PadRight(4," "), $exceptionCoverageColour)
                $output += [ANSIEscapedString]::Colourise($coveredPercentage.PadLeft(10," "), $coverageColour)
                $output += [ANSIEscapedString]::Colourise($exceptionCoveragePercentage.PadLeft(12," "), $exceptionCoverageColour)

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
                    [Int]$exceptionCoverageUnits = [Math]::Floor([Decimal]$exceptionCoverage * $maxCoverageUnits)
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
                    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25b2) * ([Int]$exceptionCoverageUnits - [Int]$coverageUnits), $exceptionCoverageColour)
                    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cb) * ($maxCoverageUnits - [Int]$exceptionCoverageUnits), $grey)
                    $output += "]"
                    $output += [ANSIEscapedString]::Colourise(" " + $instructionCounter.covered.PadLeft(4," ") + "/" + ([String]([Int]$instructionCounter.covered + [Int]$instructionCounter.missed)).PadRight(4," ") + " ", $coverageColour)
                    $output += [ANSIEscapedString]::Colourise($includeExceptionString.PadRight(4," "), $exceptionCoverageColour)
                    $output += [ANSIEscapedString]::Colourise($coveredPercentage.PadLeft(10," "), $coverageColour)
                    $output += [ANSIEscapedString]::Colourise($exceptionCoveragePercentage.PadLeft(12," "), $exceptionCoverageColour)

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
    $exceptionCoverage = [Math]::Round(([Int]$instructionCounter.covered + [Int]$totalIncludedExceptionCount) / ([Int]$instructionCounter.covered + [Int]$instructionCounter.missed),4)
    [Int]$coverageUnits = [Math]::Floor([Decimal]$coverage * $maxCoverageUnits)
    [Int]$exceptionCoverageUnits = [Math]::Floor([Decimal]($exceptionCoverage) * $maxCoverageUnits)
    $coveredPercentage = $coverage.ToString("P")
    $exceptionCoveragePercentage = $exceptionCoverage.ToString("P")

    $includeExceptionString = "+" + [String]$totalIncludedExceptionCount

    if ( $instructionCounter.missed -eq 0 ) { $coverageColour = $green }
    elseif ( $coverage -ge 0.75 ) { $coverageColour = $yellow }
    else { $coverageColour = $red }

    if ( ([Int]$instructionCounter.missed - [Int]$totalIncludedExceptionCount) -le 0 ) { $exceptionCoverageColour = $green }
    elseif ( $exceptionCoverage -ge 0.75 ) { $exceptionCoverageColour = $yellow }
    else { $exceptionCoverageColour = $red }

    $output = ""
    $output += [ANSIEscapedString]::FixedWidth("Overall coverage:", $availableSummaryWidth, $true)
    $output += " ["
    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cf) * [Int]$coverageUnits, $exceptionCoverageColour)
    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25b2) * ([Int]$exceptionCoverageUnits - [Int]$coverageUnits), $exceptionCoverageColour)
    $output += [ANSIEscapedString]::Colourise([String]$([char]0x25cb) * ($maxCoverageUnits - [Int]$exceptionCoverageUnits), $grey)
    $output += "]"
    $output += [ANSIEscapedString]::Colourise(" " + $instructionCounter.covered.PadLeft(4," ") + "/" + ([String]([Int]$instructionCounter.covered + [Int]$instructionCounter.missed)).PadRight(4," ") + " ", $coverageColour)
    $output += [ANSIEscapedString]::Colourise($includeExceptionString.PadRight(4," "), $exceptionCoverageColour)
    $output += [ANSIEscapedString]::Colourise($coveredPercentage.PadLeft(10," "), $coverageColour)
    $output += [ANSIEscapedString]::Colourise($exceptionCoveragePercentage.PadLeft(12," "), $exceptionCoverageColour)

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
    
    # False instruction defining regex array variable, Unreachable return needed to pass semantic validation, Unable to fully test error handling without being able to mock a System.IO.FileInfo
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|<script>", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|SeasonEpisodeToString", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|FillPropertiesWhereMissing", 5)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|GenerateHashIfMissing", 8)

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|CopyModel", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|MergeModels", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|Compare", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ICommandHandler.Interface|TestFilesystemHashes", 1)

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
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

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentSubjectBO.Interface|ActsOnType", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IContentSubjectBO.Interface|ActsOnFilenameElement", 1)

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFiles", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFileIfExists", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|FileExists", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GenerateHash", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|CheckFilesystemHash", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFileMetadataProperty", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|GetFileMetadataProperties", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IFilesystemProvider.Interface|UpdateFileName", 2)

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelAnalysisHandler.Interface|AnalysePossibleLabellingIssues", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelAnalysisHandler.Interface|SpellcheckContentTitles", 1)
 
    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|RemodelFilenameFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AlterSeasonEpisodeFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AlterTrackFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AlterSubject", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelManipulationHandler.Interface|AddContentToModel", 1)

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelPersistenceHandler.Interface|LoadConfigFromIndexFile", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IModelPersistenceHandler.Interface|RetrieveDataFromIndexFile", 1)

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ISpellcheckProvider.Interface|Initialise", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ISpellcheckProvider.Interface|CheckSpelling", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|ISpellcheckProvider.Interface|GetSuggestions", 1)

    # Doesn't make sense to test execution of prototypes (caused by the pseudo nature of the interface implementation)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IStringSimilarityProvider.Interface|GetNormalisedDistanceBetween", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Interfaces|IStringSimilarityProvider.Interface|GetRawDistanceBetween", 2)

    # Unreachable code
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|CommandHandler.Class|TestFilesystemHashes", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|CommandHandler.Class|ValidateComparisonInputAndRetrieveAsContent", 6)

    # Unreachable code
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|ApplyAllPendingFilenameChanges", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|AlterSeasonEpisodeFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|AlterTrackFormat", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|AddContentToModel", 5)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|Build", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|Rebuild", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|Load", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|FillPropertiesAndHashWhereMissing", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelManipulationHandler.Class|IsValidForAlter", 6)

    # Unable to mock convert-fromJSON, cannot test exception handling, Unreachable code
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelPersistenceHandler.Class|LoadConfigFromIndexFile", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelPersistenceHandler.Class|RetrieveDataFromIndexFile", 5)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Handlers|ModelPersistenceHandler.Class|ReadFromIndexFile", 3)

    # Included in tests but constructor throws are not being counted for some reason
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/ModuleBehaviour|CollectionManagementDefaults.Static|CollectionManagementDefaults", 1)

    # Included in tests but constructor throws are not being counted for some reason
    $exceptionsList.Add("PS.MediaCollectionManagement/ConsoleExtensions/Using/ModuleBehaviour|ConsoleExtensionsSettings.Static|ConsoleExtensionsSettings", 1)

    # False instruction defining regex array variable, Included in tests but constructor throws are not being counted for some reason
    $exceptionsList.Add("PS.MediaCollectionManagement/ConsoleExtensions/Using/ModuleBehaviour|ConsoleExtensionsState.Singleton|<script>", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/ConsoleExtensions/Using/ModuleBehaviour|ConsoleExtensionsState.Singleton|ConsoleExtensionsState", 1)

    # Included in tests but constructor throws are not being counted for some reason
    $exceptionsList.Add("PS.MediaCollectionManagement/FilesystemExtensions/Using/ModuleBehaviour|FilesystemExtensionsSettings.Static|FilesystemExtensionsSettings", 1)

    # Included in tests but constructor throws are not being counted for some reason
    $exceptionsList.Add("PS.MediaCollectionManagement/FilesystemExtensions/Using/ModuleBehaviour|FilesystemExtensionsState.Singleton|FilesystemExtensionsState", 1)

    # Not currently used in this project
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/ModuleBehaviour|CollectionManagementDefaults.Static|LEGACY_FILEINDEX_FILEFORMAT", 1)

    # Unreachable code
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/ObjectModels|Content.Class|Init", 1)
    
    # Unable to mock MS Word COM Interop to test exception block
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/Providers|MSWordCOMSpellcheckProvider.Class|Initialise", 3)

    # Unreachable code
    $exceptionsList.Add("PS.MediaCollectionManagement/ConsoleExtensions/Using/ModuleBehaviour|ConsoleExtensionsState.Singleton|MockConsoleReceiver", 1)

    # Unable to mock bottom level of filesystem abstraction without affecting files
    $exceptionsList.Add("PS.MediaCollectionManagement/FilesystemExtensions/Public|Rename-File", 2)
    $exceptionsList.Add("PS.MediaCollectionManagement/FilesystemExtensions/Public|Save-File", 2)

    # Unable to test interface exceptions without implementing a broken class
    $exceptionsList.Add("PS.MediaCollectionManagement/Shared/Using/Base|IsInterface.Class|AssertAsInterface", 4)

    # Unable to test exception in the root level module (or nothing will work :S)
    $exceptionsList.Add("PS.MediaCollectionManagement|PS.MediaCollectionManagement|<script>", 2)

    return $exceptionsList
}