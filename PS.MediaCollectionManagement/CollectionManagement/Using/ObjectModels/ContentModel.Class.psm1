#region Header
#
# About: ContentModel class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\Controllers\CollectionManagementController.Abstract.psm1
using module .\..\ModuleBehaviour\CollectionManagementDefaults.Abstract.psm1
using module .\ContentModelConfig.Class.psm1
using module .\Content.Class.psm1
using module .\ContentSubjectBase.Class.psm1
using module .\ContentComparer.Class.psm1
using module .\SpellcheckResult.Class.psm1
using module .\..\..\..\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1

#endregion Using


#region Class Definition
#-----------------------
class ContentModel : IContentModel {

    #region Properties
    [System.Collections.Generic.List[ContentSubjectBase]] $Actors
    [System.Collections.Generic.List[ContentSubjectBase]] $Albums
    [System.Collections.Generic.List[ContentSubjectBase]] $Artists
    [System.Collections.Generic.List[ContentSubjectBase]] $Series
    [System.Collections.Generic.List[ContentSubjectBase]] $Studios
    [System.Collections.Generic.List[Content]] $Content
    [String] $BuiltFromAbsolutePath
    [ContentModelConfig] $Config
    #endregion Properties


    #region Constructors
    ContentModel(){
        
        # Instantiate the config object
        $this.Config = [ContentModelConfig]::new()  

    }
    #endregion Constructors


    #region Initialiser
    [Void] Init() {

        # First reset
        $this.Reset()
        
        # Lock the filename format
        $this.Config.LockFilenameFormat()
        
        # If the FilenameFormat includes Actors, initialise the Actors property and methods
        if ([FilenameElement]::Actors -in $this.Config.FilenameFormat) {

            # Initialise the Actors collection
            $this.Actors = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        
            # Add Members to the Actors Generic List
            Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Actors = $null
        }

        # If the FilenameFormat includes Albums, initialise the Albums property and methods
        if ([FilenameElement]::Album -in $this.Config.FilenameFormat) {

            # Initialise the Studios collection
            $this.Albums = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        
            # Add Members to the Studios Generic List
            Add-Member -InputObject $this.Albums -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Albums -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Albums -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Albums = $null
        }

        # If the FilenameFormat includes Artists, initialise the Artists property and methods
        if ([FilenameElement]::Artists -in $this.Config.FilenameFormat) {

            # Initialise the Artists collection
            $this.Artists = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        
            # Add Members to the Content Generic List
            Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Artists = $null
        }

        # If the FilenameFormat includes Series, initialise the Series property and methods
        if ([FilenameElement]::Series -in $this.Config.FilenameFormat) {

            # Initialise the Series collection
            $this.Series = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        
            # Add Members to the Series Generic List
            Add-Member -InputObject $this.Series -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Series -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Series -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Series = $null
        }

        # If the FilenameFormat includes Studios, initialise the Studios property and methods
        if ([FilenameElement]::Studio -in $this.Config.FilenameFormat) {

            # Initialise the Studios collection
            $this.Studios = [System.Collections.Generic.List[ContentSubjectBase]]::new()
        
            # Add Members to the Studios Generic List
            Add-Member -InputObject $this.Studios -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Studios -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Studios -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Studios = $null
        }

        # Initialise the Content collection
        $this.Content = [System.Collections.Generic.List[Content]]::new()
       
        # Add Members to the Content Generic List
        Add-Member -InputObject $this.Content -MemberType ScriptMethod -Name SortedBy -Value { 
            param ([String[]] $property)  
            return ($this | Sort-Object $property)
        } -Force

        Add-Member -InputObject $this.Content -MemberType ScriptMethod -Name Matching -value {
            param ([String] $s)
            return ($this | Where-Object {$_.Title -match $s})
        } -Force

        Add-Member -InputObject $this.Content -MemberType ScriptMethod -Name GetByFileName -value {
            param ([String] $s)
            return ($this | Where-Object {$_.FileName -ceq $s})
        } -Force
    }
    #endregion Initialiser


    #region Public Methods
    [Void] Reset() {
        $this.Actors = $null
        $this.Albums = $null
        $this.Artists = $null
        $this.Series = $null
        $this.Studios = $null
        $this.Content = $null
        $this.Config._FilenameFormatLock = $false
    }

    [Void] Build() {
        [CollectionManagementController]::Build($this, $false, $false)
    }

    [Void] Build([Bool] $loadProperties, [Bool] $generateHash) {
        [CollectionManagementController]::Build($this, $loadProperties, $generateHash)
    }

    [Void] Rebuild() {
        [CollectionManagementController]::Rebuild($this, $false, $false)
    }

    [Void] Rebuild([Bool] $loadProperties, [Bool] $generateHash) {
        [CollectionManagementController]::Rebuild($this, $loadProperties, $generateHash)
    }

    [Void] LoadIndex () {
        [CollectionManagementController]::Load($this, ".\Index.json", $false, $false)
    }

    [Void] LoadIndex ([String] $indexFilePath) {
        [CollectionManagementController]::Load($this, $indexFilePath, $false, $false)
    }

    [Void] LoadIndex ([Bool] $collectInfoWhereMissing) {
        [CollectionManagementController]::Load($this, ".\Index.json", $collectInfoWhereMissing, $collectInfoWhereMissing)
    }

    [Void] LoadIndex ([String] $indexFilePath, [Bool] $collectInfoWhereMissing) {
        [CollectionManagementController]::Load($this, $indexFilePath, $collectInfoWhereMissing, $collectInfoWhereMissing)
    }

    [Void] SaveIndex () {
        [CollectionManagementController]::Save($this, ".\Index.json", $false, $false)
    }

    [Void] SaveIndex ([String] $indexFilePath) {
        [CollectionManagementController]::Save($this, $indexFilePath, $false, $false)
    }

    [Void] SaveIndex ([Bool] $CollectInfoWhereMissing) {
        [CollectionManagementController]::Save($this, ".\Index.json", $collectInfoWhereMissing, $collectInfoWhereMissing)
    }

    [Void] SaveIndex ([String] $indexFilePath, [Bool] $CollectInfoWhereMissing) {
        [CollectionManagementController]::Save($this, $indexFilePath, $collectInfoWhereMissing, $collectInfoWhereMissing)
    }

    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement) {
        return [CollectionManagementController]::RemodelFilenameFormat($this, $swapElement, $withElement, $false)
    }

    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::RemodelFilenameFormat($this, $swapElement, $withElement, $updateCorrespondingFilename)
    }

    [Bool] AlterActor ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::AlterActor($this, $fromName, $toName, $false)
    }

    [Bool] AlterActor ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterActor($this, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] AlterAlbum ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::AlterAlbum($this, $fromName, $toName, $false)
    }

    [Bool] AlterAlbum ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterAlbum($this, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] AlterArtist ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::AlterArtist($this, $fromName, $toName, $false)
    }

    [Bool] AlterArtist ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterArtist($this, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] AlterSeries ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::AlterSeries($this, $fromName, $toName, $false)
    }

    [Bool] AlterSeries ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterSeries($this, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] AlterStudio ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::AlterStudio($this, $fromName, $toName, $false)
    }

    [Bool] AlterStudio ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterStudio($this, $fromName, $toName, $updateCorrespondingFilename)
    }

    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern) {
        return [CollectionManagementController]::AlterSeasonEpisodeFormat($this, $padSeason, $padEpisode, $pattern, $false)
    }
    
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterSeasonEpisodeFormat($this, $padSeason, $padEpisode, $pattern, $updateCorrespondingFilename)
    } 

    [Bool] AlterTrackFormat([Int] $padTrack) {
        return [CollectionManagementController]::AlterTrackFormat($this, $padTrack, $false)
    }

    [Bool] AlterTrackFormat([Int] $padTrack, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterTrackFormat($this, $padTrack, $updateCorrespondingFilename)
    }

    [Void] ApplyAllPendingFilenameChanges() {        
        [CollectionManagementController]::ApplyAllPendingFilenameChanges($this)
    }

    [Void] Summary() {
        [CollectionManagementController]::ModelSummary($this)
    }

    [Int[]] AnalyseActorsForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Actors, $false)
    }

    [Int[]] AnalyseActorsForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Actors, $returnSummary)
    }

    [Int[]] AnalyseAlbumsForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Albums, $false)
    }

    [Int[]] AnalyseAlbumsForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Albums, $returnSummary)
    }

    [Int[]] AnalyseArtistsForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Artists, $false)
    }

    [Int[]] AnalyseArtistsForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Artists, $returnSummary)
    }

    [Int[]] AnalyseSeriesForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Series, $false)
    }

    [Int[]] AnalyseSeriesForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Series, $returnSummary)
    }

    [Int[]] AnalyseStudiosForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Studios, $false)
    }

    [Int[]] AnalyseStudiosForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Studios, $returnSummary)
    }

    [Void] SpellcheckContentTitles() {
        [CollectionManagementController]::SpellcheckContentTitles($this.Content, $false)
    }

    [Hashtable] SpellcheckContentTitles([Bool] $returnResults) {
        return [CollectionManagementController]::SpellcheckContentTitles($this.Content, $returnResults)
    }

    [Void] RemoveContentFromModel([String] $filename) {
    
        [CollectionManagementController]::RemoveContentFromModel($this, $filename)
    }
    #endregion Public Methods
}
#endregion Class Definition