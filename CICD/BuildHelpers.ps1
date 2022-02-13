using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\Helpers\ANSIEscapedString.Static.psm1
using module .\CoverageAgent.psm1
using module .\BuildAgent.psm1


function New-BuildAgent() {
    return [BuildAgent]::new()
}

function New-CoverageAgent() {
    $ca = [CoverageAgent]::new(".\coverage.xml", (Get-KnownExceptions))
    $ca.IncludeFileOutput(115, ".\FriendlyCoverageReport.md")
    return $ca
}

function New-PesterCIConfiguration ([Switch] $IgnoreRemoteFilesystem, [Switch] $MSWordNotAvailable, [Switch] $IncludeCoverage, [Switch] $IncludeResults, [Switch] $IncludeDetail) {
    
    Import-Module Pester -MinimumVersion 5.0.0

    [System.Collections.Generic.List[String]] $exclusions = [System.Collections.Generic.List[String]]::new()
    
    if ($IgnoreRemoteFilesystem.IsPresent) {
        $exclusions.Add("RemoteFilesystem")
    }

    if ($MSWordNotAvailable.IsPresent) {
        $exclusions.Add("MSWordPresent")
    }

    $config = New-PesterConfiguration
    $config.Run.PassThru = $true
    $config.Run.Path = "$PSScriptRoot\..\Tests\*.Tests.ps1"
    $config.Filter.ExcludeTag = $exclusions.ToArray()
    $config.Should.ErrorAction = "Continue"

    if ($IncludeCoverage.IsPresent) {
        $config.CodeCoverage.Enabled = $true
        $config.CodeCoverage.Path = "$PSScriptRoot\..\PS.MediaCollectionManagement\*"
        $config.CodeCoverage.OutputPath = "$PSScriptRoot\..\coverage.xml"
        $config.CodeCoverage.OutputFormat = "JaCoCo"
    }

    if ($IncludeDetail.IsPresent) {
        $config.Output.Verbosity = "Detailed"
    }

    if ($IncludeResults.IsPresent) {
        $config.TestResult.Enabled = $true
        $config.TestResult.OutputPath = "$PSScriptRoot\..\testresults.xml"
        $config.TestResult.OutputFormat = "NUnitXml"
    }

    return $config
}

function Get-KnownExceptions () {
    $exceptionsList = @{}
    
    # False instruction defining regex array variable, Unreachable return needed to pass semantic validation, Unable to fully test error handling without being able to mock a System.IO.FileInfo
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|<script>", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|SeasonEpisodeToString", 1)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|FillPropertiesWhereMissing", 5)
    $exceptionsList.Add("PS.MediaCollectionManagement/CollectionManagement/Using/BusinessObjects|ContentBO.Class|GenerateHashIfMissing", 8)

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

    # Untestable with test automation
    #$exceptionsList.Add("PS.MediaCollectionManagement/ConsoleExtensions/Private|Set-ConsoleState", 3)
    
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