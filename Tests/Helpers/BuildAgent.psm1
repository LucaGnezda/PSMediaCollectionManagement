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
using module .\..\..\..\Shared\Using\Base\IsStatic.Class.psm1
#endregion Using



#region Class Definition
#-----------------------
class BuildAgent {

    #region Properties
    [String] Hidden $_ManifestPath
    [String] Hidden $_AppveyorYAMLPipelinePath
    [String] Hidden $_ManifestVersionLineRegex
    [String] Hidden $_ManifestVersionRegex
    [String] Hidden $_InitialVersionLineFromManifest
    [String] Hidden $_VersionLineFormatter
    [Int]    Hidden $_DotsInVersion
    #endregion Properties

    #region Constructors
    BuildAgent() {

        # Initialise State
        $this._ManifestPath =                   "$PSScriptRoot\..\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1"
        $this._AppveyorYAMLPipelinePath =       "$PSScriptRoot\..\..\appveyor.yml"
        $this._ManifestVersionLineRegex =       "ModuleVersion.+"
        $this._ManifestVersionRegex =           "(?<=ModuleVersion( )?=( )['""])(?<Build>[0-9]+)?(?=['""])"
        $this._InitialVersionLineFromManifest = ""
        $this._VersionLineFormatter =           "ModuleVersion = '{0}'"
        $this._DotsInVersion =                  $this.GetManifestDotsInVersion()

        # Derive regex for the Manifest version 
        $this._VersionManifestRegex =    "(?<=ModuleVersion( )?=( )?['""])"
        if ($this._DotsInVersion -ge 1)  { $this._VersionManifestRegex += "(?<Major>[0-9]+)(.)?" }
        if ($this._DotsInVersion -ge 2)  { $this._VersionManifestRegex += "(?<Major>[0-9]+)(.)?" }
        if ($this._DotsInVersion -ge 3)  { $this._VersionManifestRegex += "(?<Major>[0-9]+)(.)?" }
        $this._VersionManifestRegex +=   "(?<Build>[0-9]+)?(?=['""])"        
    }
    #endregion Constructors

    #region Public Methods
    [Void] StepMajorVersion () {
        if ($this._DotsInVersion -ge 1) {
            $version = $this.GetManifestVersion()
            $version.Major += 1
            if ($this._DotsInVersion -ge 2) { $version.Minor = 0 }
            if ($this._DotsInVersion -ge 3) { $version.Fix = 0 }
            SetManifestVersion ($version)
            SetBuildPipelineVersion ($version)
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
            SetManifestVersion ($version)
            SetBuildPipelineVersion ($version)
        }
        else {
            throw "Manifest version does not support minor version numbers"
        }
    }

    [Void] StepFix () {
        if ($this._DotsInVersion -ge 3) {
            $version = $this.GetManifestVersion()
            $version.Fix += 1
            SetManifestVersion ($version)
            SetBuildPipelineVersion ($version)
        }
        else {
            throw "Manifest version does not support fix version numbers"
        }
    }

    [String] VersionToString () {
        return $this.VersionToString($this.GetManifestVersion())
    }

    [Object] PesterCoverageConfiguration () {
        return $this._PesterConfig
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

        $manifestVersionLine = ($manifestContents -match $this._VersionManifestLineRegex)[0]
        $manifestVersionLine -match $this._VersionManifestRegex

        if ([String]::IsNullOrEmpty($this._InitialVersionLineFromManifest) -and -not [String]::IsNullOrEmpty($manifestVersionLine) {
            $this._InitialVersionLineFromManifest = $manifestVersionLine
        }

        $version = @{}

        if ($this._DotsInVersion -ge 1)  { $version.Add("Major", [Int]$Matches.Major) }
        if ($this._DotsInVersion -ge 2)  { $version.Add("Major", [Int]$Matches.Minor) }
        if ($this._DotsInVersion -ge 3)  { $version.Add("Major", [Int]$Matches.Fix) }
        $version.Add("Build", [Int]$Matches.Build)

        return $version 
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
        $manifestContents = $manifestContents -replace $this._VersionLineRegex, [String]::Format($this._VersionLineFormatter, $this.VersionToString($version))
        $manifestContents | Set-Content -Path $this._ManifestPath
    }

    [Void] Hidden SetBuildPipelineVersion ([Hashtable] $version) {

        $manifestContents = Get-Content $this._ManifestPath
        $manifestContents = $manifestContents -replace $this._VersionLineRegex, [String]::Format($this._VersionLineFormatter, $this.VersionToPipelineString($version))
        $manifestContents | Set-Content -Path $this._ManifestPath
    }
    #endRegion Hidden Methods

}
#endregion Class Definition