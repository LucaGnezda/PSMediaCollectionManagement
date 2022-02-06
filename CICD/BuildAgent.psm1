#region Header
#
# About: Helper class for working with ANSI escaped strings 
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
class BuildAgent {

    #region Properties
    [String] Hidden $_ManifestPath
    [String] Hidden $_AppveyorYAMLPipelinePath
    [String] Hidden $_ReadmeMarkdownPath
    [String] Hidden $_ManifestVersionLineRegex
    [String] Hidden $_ManifestVersionLineFormatter
    [String] Hidden $_ManifestVersionRegex
    [String] Hidden $_ManifestVersionElementsRegex
    [String] Hidden $_AppveyorVersionLineRegex
    [String] Hidden $_AppveyorVersionLineFormatter
    [String] Hidden $_ReadmeMarkdownRawCoverageRegex
    [String] Hidden $_ReadmeMarkdownRawCoverageFormatter
    [String] Hidden $_ReadmeMarkdownEffectiveCoverageRegex
    [String] Hidden $_ReadmeMarkdownEffectiveCoverageFormatter
    [String] Hidden $_ReadmeMarkdownAutomationCoverageRegex
    [String] Hidden $_ReadmeMarkdownAutomationCoverageFormatter
    [String[]] Hidden $_InitialStateManifest
    [String[]] Hidden $_InitialStateYAMLPipeline
    [String[]] Hidden $_InitialStateReadme
    [Int]    Hidden $_DotsInVersion
    #endregion Properties

    #region Constructors
    BuildAgent() {

        # Initialise State
        $this._ManifestPath =                              "$PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1"
        $this._AppveyorYAMLPipelinePath =                  "$PSScriptRoot\..\appveyor.yml"
        $this._ReadmeMarkdownPath =                        "$PSScriptRoot\..\README.md"
        $this._ManifestVersionLineRegex =                  "ModuleVersion.+"
        $this._ManifestVersionLineFormatter =              "ModuleVersion = '{0}'"
        $this._ManifestVersionRegex =                      "(?<=ModuleVersion( )?=( )['""])(?<Version>.+)?(?=['""])"
        $this._AppveyorVersionLineRegex =                  "version:.+"
        $this._AppveyorVersionLineFormatter =              "version: {0}"
        $this._ReadmeMarkdownRawCoverageRegex =            "!\[Raw Coverage\].+?\)"
        $this._ReadmeMarkdownRawCoverageFormatter =        "![Raw Coverage](https://img.shields.io/badge/raw%20coverage-{0}%25-{1}.svg)"
        $this._ReadmeMarkdownEffectiveCoverageRegex =      "!\[Effective Coverage\].+?\)"
        $this._ReadmeMarkdownEffectiveCoverageFormatter =  "![Effective Coverage](https://img.shields.io/badge/effective%20coverage-{0}%25-{1}.svg)"
        $this._ReadmeMarkdownAutomationCoverageRegex =     "!\[Automation Coverage\].+?\)"
        $this._ReadmeMarkdownAutomationCoverageFormatter = "![Automation Coverage](https://img.shields.io/badge/automation%20coverage-{0}%25-{1}.svg?logo=appveyor)"
        $this._InitialStateManifest =                      @()
        $this._InitialStateYAMLPipeline =                  @()
        $this._InitialStateReadme =                        @()
        $this._DotsInVersion =                             $this.GetManifestDotsInVersion()

        # Derive regex for the Manifest version 
        $this._ManifestVersionElementsRegex =              "(?<=ModuleVersion( )?=( )?['""])"
        if ($this._DotsInVersion -ge 1)  { 
            $this._ManifestVersionElementsRegex +=         "(?<Major>[0-9]+)(.)?" 
        }
        if ($this._DotsInVersion -ge 2)  { 
            $this._ManifestVersionElementsRegex +=         "(?<Minor>[0-9]+)(.)?" 
        }
        if ($this._DotsInVersion -ge 3)  { 
            $this._ManifestVersionElementsRegex +=         "(?<Fix>[0-9]+)(.)?" 
        }
        $this._ManifestVersionElementsRegex +=             "(?<Build>[0-9]+)?(?=['""])"        
    }
    #endregion Constructors

    #region Public Methods
    [Void] StepMajorVersion () {
        if ($this._DotsInVersion -ge 1) {
            $version = $this.GetManifestVersion()
            $version.Major += 1
            if ($this._DotsInVersion -ge 2) { $version.Minor = 0 }
            if ($this._DotsInVersion -ge 3) { $version.Fix = 0 }
            $this.SetManifestVersion($version)
            $this.SetBuildPipelineVersion($version)
        }
        else {
            throw "Manifest version does not support major version numbers"
        }
    }

    [Void] StepMinorVersion () {
        if ($this._DotsInVersion -ge 2) {
            $version = $this.GetManifestVersion()
            $version.Minor += 1
            if ($this._DotsInVersion -ge 3) { $version.Fix = 0 }
            $this.SetManifestVersion($version)
            $this.SetBuildPipelineVersion($version)
        }
        else {
            throw "Manifest version does not support minor version numbers"
        }
    }

    [Void] StepFix () {
        if ($this._DotsInVersion -ge 3) {
            $version = $this.GetManifestVersion()
            $version.Fix += 1
            $this.SetManifestVersion($version)
            $this.SetBuildPipelineVersion($version)
        }
        else {
            throw "Manifest version does not support fix version numbers"
        }
    }

    [Void] SetBuildNumber () {
        if ($null -ne $Env:APPVEYOR_BUILD_NUMBER) {
            $version = $this.GetManifestVersion()
            $version.Build = $Env:APPVEYOR_BUILD_NUMBER
            $this.SetManifestVersion($version)
        }
    }

    [Void] SetRawAndEffectiveCoverageBadges ([Object] $results, [Hashtable] $exceptions) {

        $rawCoverage = [Math]::Floor((100 * $results.CodeCoverage.CommandsExecutedCount) / $results.CodeCoverage.CommandsAnalyzedCount)
        $exceptionCount = 0
        $exceptions.Values | ForEach-Object { $exceptionCount += $_}
        $effectiveCoverage = [Math]::Floor((100 * ($results.CodeCoverage.CommandsExecutedCount + $exceptionCount)) / $results.CodeCoverage.CommandsAnalyzedCount)

        $rawCoverageColour = $this.GetBadgeColourFromPercentage($rawCoverage)
        $effectiveCoverageColour = $this.GetBadgeColourFromPercentage($effectiveCoverage)

        $markdownContents = Get-Content $this._ReadmeMarkdownPath

        if ($this._InitialStateReadme.Count -eq 0) { $this._InitialStateReadme = $markdownContents }

        $markdownContents = $markdownContents -replace $this._ReadmeMarkdownRawCoverageRegex, [String]::Format($this._ReadmeMarkdownRawCoverageFormatter, $rawCoverage, $rawCoverageColour)
        $markdownContents = $markdownContents -replace $this._ReadmeMarkdownEffectiveCoverageRegex, [String]::Format($this._ReadmeMarkdownEffectiveCoverageFormatter, $effectiveCoverage, $effectiveCoverageColour)
        $markdownContents | Set-Content -Path $this._ReadmeMarkdownPath -Encoding UTF8
    }

    [Void] SetAutomationCoverageBadge ([Object] $results) {

        $automationCoverage = [Math]::Floor((100 * $results.CodeCoverage.CommandsExecutedCount) / $results.CodeCoverage.CommandsAnalyzedCount)

        $automationCoverageColour = $this.GetBadgeColourFromPercentage($automationCoverage)

        $markdownContents = Get-Content $this._ReadmeMarkdownPath

        if ($this._InitialStateReadme.Count -eq 0) { $this._InitialStateReadme = $markdownContents }

        $markdownContents = $markdownContents -replace $this._ReadmeMarkdownAutomationCoverageRegex, [String]::Format($this._ReadmeMarkdownAutomationCoverageFormatter, $automationCoverage, $automationCoverageColour)
        $markdownContents | Set-Content -Path $this._ReadmeMarkdownPath -Encoding UTF8
    }

    [String] VersionToString () {
        return $this.VersionToString($this.GetManifestVersion())
    }

    [Void] UndoAllChanges () {
        
        if ($this._InitialStateManifest.Count -gt 0) { $this._InitialStateManifest | Set-Content -Path $this._ManifestPath -Encoding UTF8 }
        if ($this._InitialStateYAMLPipeline.Count -gt 0) { $this._InitialStateYAMLPipeline | Set-Content -Path $this._AppveyorYAMLPipelinePath -Encoding UTF8 }
        if ($this._InitialStateReadme.Count -gt 0) { $this._InitialStateReadme | Set-Content -Path $this._ReadmeMarkdownPath -Encoding UTF8 }
    }
    #endregion Public Methods

    #region Hidden Methods
    [Int] Hidden GetManifestDotsInVersion () {
        $manifestContents = Get-Content $this._ManifestPath

        $manifestVersionLine = ($manifestContents -match $this._ManifestVersionLineRegex)[0]
        $manifestVersionLine -match $this._ManifestVersionRegex

        return ($Matches[0].ToCharArray() | Where-Object {$_ -eq "."} | Measure-Object).Count
    }

    [Hashtable] Hidden GetManifestVersion () {
        $manifestContents = Get-Content $this._ManifestPath

        $manifestVersionLine = ($manifestContents -match $this._ManifestVersionLineRegex)[0]
        $manifestVersionLine -match $this._ManifestVersionElementsRegex

        if ([String]::IsNullOrEmpty($this._InitialStateManifest) -and -not [String]::IsNullOrEmpty($manifestVersionLine)) {
            $this._InitialStateManifest = $manifestVersionLine
        }

        $version = @{}

        if ($this._DotsInVersion -ge 1)  { $version.Add("Major", [Int]$Matches.Major) }
        if ($this._DotsInVersion -ge 2)  { $version.Add("Minor", [Int]$Matches.Minor) }
        if ($this._DotsInVersion -ge 3)  { $version.Add("Fix", [Int]$Matches.Fix) }
        $version.Add("Build", [Int]$Matches.Build)

        return $version 
    }

    [String] Hidden GetBadgeColourFromPercentage ([Int] $percentage) {
        $colour = switch ($percentage) {
            {$_ -eq 100} { "brightgreen" }
            {$_ -in 90..99} { "green" }
            {$_ -in 83..89} { "yellowgreen" }
            {$_ -in 75..82} { "yellow" }
            {$_ -in 60..74} { "orange" }
            {$_ -in 0..59}  { "red" }
            Default { "lightgrey" }
        }
        return $colour
    }

    [String] Hidden VersionToString ([Hashtable] $version) {

        $s = ""
        if ($this._DotsInVersion -ge 1)  { $s += [String]$version.Major + "." }
        if ($this._DotsInVersion -ge 2)  { $s += [String]$version.Minor + "." }
        if ($this._DotsInVersion -ge 3)  { $s += [String]$version.Fix + "." }
        $s += [String]$version.Build

        return $s
    }

    [String] Hidden VersionToPipelineString ([Hashtable] $version) {

        $s = ""
        if ($this._DotsInVersion -ge 1)  { $s += [String]$version.Major + "." }
        if ($this._DotsInVersion -ge 2)  { $s += [String]$version.Minor + "." }
        if ($this._DotsInVersion -ge 3)  { $s += [String]$version.Fix + "." }
        $s += "{build}"

        return $s
    }

    [Void] Hidden SetManifestVersion ([Hashtable] $version) {

        $manifestContents = Get-Content $this._ManifestPath

        if ($this._InitialStateManifest.Count -eq 0) { $this._InitialStateManifest = $manifestContents }

        $manifestContents = $manifestContents -replace $this._ManifestVersionLineRegex, [String]::Format($this._ManifestVersionLineFormatter, $this.VersionToString($version))
        $manifestContents | Set-Content -Path $this._ManifestPath -Encoding UTF8
    }

    [Void] Hidden SetBuildPipelineVersion ([Hashtable] $version) {

        $yamlContents = Get-Content $this._AppveyorYAMLPipelinePath

        if ($this._InitialStateYAMLPipeline.Count -eq 0) { $this._InitialStateYAMLPipeline = $yamlContents }

        $yamlContents = $yamlContents -replace $this._AppveyorVersionLineRegex, [String]::Format($this._AppveyorVersionLineFormatter, $this.VersionToPipelineString($version))
        $yamlContents | Set-Content -Path $this._AppveyorYAMLPipelinePath -Encoding UTF8
    }
    #endRegion Hidden Methods

}
#endregion Class Definition