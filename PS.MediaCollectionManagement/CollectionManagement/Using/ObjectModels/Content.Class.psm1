#region Header
#
# About: Content class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\Actor.Class.psm1
using module .\Album.Class.psm1
using module .\Artist.Class.psm1
using module .\Series.Class.psm1
using module .\Studio.Class.psm1

#endregion Using



#region Class Definition
#-----------------------
class Content {
    
    #region Properties
    [String]                    $FileName
    [String]                    $BaseName
    [Bool]                      $AlteredBaseName
    [Bool]                      $PendingFilenameUpdate
    [String]                    $Extension
    [System.Nullable[Int]]      $FrameWidth
    [System.Nullable[Int]]      $FrameHeight
    [String]                    $FrameRate
    [String]                    $BitRate
    [System.Nullable[TimeSpan]] $TimeSpan
    [System.Collections.Generic.List[ContentWarning]] $Warnings
    [String]                    $Title
    [String]                    $Hash
    [System.Collections.Generic.List[Actor]] $Actors
    [System.Collections.Generic.List[Artist]] $Artists
    [Studio]                    $ProducedBy
    [Series]                    $FromSeries
    [Album]                     $OnAlbum            
    [System.Nullable[Int]]      $Season
    [System.Nullable[Int]]      $Episode
    [String]                    $SeasonEpisode
    [System.Nullable[Int]]      $Track
    [String]                    $TrackLabel
    [System.Nullable[Int]]      $Year

    #endregion Properties


    #region Constructors
    Content(
        [String] $fileName,
        [String] $baseName,
        [String] $extension,
        [Bool] $includeTitle,
        [Bool] $includeActors,
        [Bool] $includeAlbum,
        [Bool] $includeArtists,
        [Bool] $includeSeries,
        [Bool] $includeStudio,
        [Bool] $includeSeasonEpisode,
        [Bool] $includeTrack,
        [Bool] $includeYear
    ){
        $this.Init($fileName, $basename, $extension, $includeTitle, $includeActors, $includeAlbum, $includeArtists, $includeSeries, $includeStudio, $includeSeasonEpisode, $includeTrack, $includeYear)
    }
    
    [Void] Hidden Init(
        [String]    $fileName,
        [String]    $baseName,
        [String]    $extension,
        [Bool]      $includeTitle,
        [Bool]      $includeActors,
        [Bool]      $includeAlbum,
        [Bool]      $includeArtists,
        [Bool]      $includeSeries,
        [Bool]      $includeStudio,
        [Bool]      $includeSeasonEpisode,
        [Bool]      $includeTrack,
        [Bool]      $includeYear
    ) {
        $this.FileName = $fileName
        $this.BaseName = $baseName
        $this.AlteredBaseName = $null
        $this.PendingFilenameUpdate = $false
        $this.Extension = $extension
        $this.Warnings = [System.Collections.Generic.List[ContentWarning]]::new()
        $this.Title = ""
        $this.FrameWidth = $null
        $this.FrameHeight = $null
        $this.FrameRate = $null
        $this.TimeSpan = $null
        $this.BitRate = $null
        $this.Hash = $null
        $this.Season = $null
        $this.Episode = $null
        $this.SeasonEpisode = ""
        $this.Track = $null
        $this.TrackLabel = ""
        $this.Year = $null

        # If required, instantiate the Actors Generic List and add Members 
        if ($includeActors) {
            $this.Actors = [System.Collections.Generic.List[Actor]]::new()

            Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  return ($this | Sort-Object $property)
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

        # If required, instantiate the Artists Generic List and add Members 
        if ($includeArtists) {
            $this.Artists = [System.Collections.Generic.List[Artist]]::new()

            Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  return ($this | Sort-Object $property)
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

        # Add an accessor (getter)
        $this | Add-Member -Name "Duration" -MemberType ScriptProperty -Value {
            if ($this.TimeSpan -eq 0) {
                return $null
            }
            else {
                return $this.TimeSpan.ToString()
            }
        } -Force

        # Set the default table column order
        $DefaultProps = [System.Collections.Generic.List[String]]@("FileName", "BaseName", "Extension", "Warnings", "AlteredBaseName", "PendingFilenameUpdate", "Title", "FrameWidth", "FrameHeight", "FrameRate", "BitRate", "Duration", "TimeSpan", "Hash")
        if ($includeSeasonEpisode) {
            $DefaultProps.Add("Season")
            $DefaultProps.Add("Episode") 
            $DefaultProps.Add("SeasonEpisode")  
        }
        if ($includeTrack) { 
            $DefaultProps.Add("Track")
            $DefaultProps.Add("TrackLabel")
        }
        if ($includeYear) { $DefaultProps.Add("Year") }
        if ($includeActors) { $DefaultProps.Add("Actors") }
        if ($includeArtists) { $DefaultProps.Add("Artists") }
        if ($includeStudio) { $DefaultProps.Add("ProducedBy") }
        if ($includeSeries) { $DefaultProps.Add("FromSeries") }
        if ($includeAlbum) { $DefaultProps.Add("OnAlbum") }
        $DefaultProps = $DefaultProps.ToArray() 
        $DefaultDisplay = New-Object System.Management.Automation.PSPropertySet("DefaultDisplayPropertySet",[string[]]$DefaultProps)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($DefaultDisplay)
        $this | Add-Member MemberSet PSStandardMembers $PSStandardMembers
    }
    #endregion Constructors



    #region Public Methods
    [String] ToString() {
        return $this.Title
    }

    [Void] AddWarning([ContentWarning] $warning) {
        if ($warning -notin $this.Warnings){
            $this.Warnings.Add($warning)
        }
    }

    [Void] ClearWarning([ContentWarning] $warning) {
        if ($warning -in $this.Warnings){
            $this.Warnings.Remove($warning)
        }
    }

    [Void] ClearWarnings() {
        $this.Warnings.Clear()
    }
    #endregion Public Methods
    
}
#endregion Class Definition