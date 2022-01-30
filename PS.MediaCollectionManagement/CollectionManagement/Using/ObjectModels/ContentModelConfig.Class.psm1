#region Header
#
# About: ContentModelConfig class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\ModuleBehaviour\CollectionManagementDefaults.Static.psm1
#endregion Using


#region Class Definition
#-----------------------
class ContentModelConfig {

    #region Properties
    [String[]] Hidden $_IncludedExtensions
    [String[]] Hidden $_DecorateAsTags
    [String] Hidden $_TagOpenDelimiter
    [String] Hidden $_TagCloseDelimiter
    [FilenameElement[]] Hidden $_FilenameFormat
    [String] Hidden $_FilenameSplitter
    [String] Hidden $_ListSplitter
    [ExportableAttribute[]] Hidden $_ExportFormat
    [Bool] Hidden $_FilenameFormatLock
    [Int] Hidden $_titleSplitIndex
    [Int] Hidden $_actorsSplitIndex
    [Int] Hidden $_albumSplitIndex
    [Int] Hidden $_artistsSplitIndex
    [Int] Hidden $_seasonEpisodeSplitIndex
    [Int] Hidden $_seriesSplitIndex
    [Int] Hidden $_studioSplitIndex
    [Int] Hidden $_trackSplitIndex
    [Int] Hidden $_yearSplitIndex
    #endregion Properties


    #region Constructors
    ContentModelConfig () {
            
        $this.Init()
        $this.ConfigureForUnstructuredFiles()
    }

    # Initialiser
    [Void] Init() {
        
        # Add an accessors (getters) for Hidden Properties
        Add-Member -InputObject $this -Name "IncludedExtensions" -MemberType ScriptProperty -Value {
            return $this._IncludedExtensions
        } -Force

        Add-Member -InputObject $this -Name "DecorateAsTags" -MemberType ScriptProperty -Value {
            return $this._DecorateAsTags
        } -Force

        Add-Member -InputObject $this -Name "TagOpenDelimiter" -MemberType ScriptProperty -Value {
            return $this._TagOpenDelimiter
        } -Force

        Add-Member -InputObject $this -Name "TagCloseDelimiter" -MemberType ScriptProperty -Value {
            return $this._TagCloseDelimiter
        } -Force

        Add-Member -InputObject $this -Name "FilenameFormat" -MemberType ScriptProperty -Value {
            return $this._FilenameFormat
        } -Force

        Add-Member -InputObject $this -Name "FilenameSplitter" -MemberType ScriptProperty -Value {
            return $this._FilenameSplitter
        } -Force

        Add-Member -InputObject $this -Name "ListSplitter" -MemberType ScriptProperty -Value {
            return $this._ListSplitter
        } -Force

        Add-Member -InputObject $this -Name "ExportFormat" -MemberType ScriptProperty -Value {
            return $this._ExportFormat
        } -Force

        Add-Member -InputObject $this -Name "IsFilenameFormatLocked" -MemberType ScriptProperty -Value {
            return $this._FilenameFormatLock
        } -Force

        Add-Member -InputObject $this -Name "TitleSplitIndex" -MemberType ScriptProperty -Value {
            return $this._titleSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "ActorsSplitIndex" -MemberType ScriptProperty -Value {
            return $this._actorsSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "AlbumSplitIndex" -MemberType ScriptProperty -Value {
            return $this._albumSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "ArtistsSplitIndex" -MemberType ScriptProperty -Value {
            return $this._artistsSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "SeasonEpisodeSplitIndex" -MemberType ScriptProperty -Value {
            return $this._seasonEpisodeSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "SeriesSplitIndex" -MemberType ScriptProperty -Value {
            return $this._seriesSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "StudioSplitIndex" -MemberType ScriptProperty -Value {
            return $this._studioSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "TrackSplitIndex" -MemberType ScriptProperty -Value {
            return $this._trackSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "YearSplitIndex" -MemberType ScriptProperty -Value {
            return $this._yearSplitIndex
        } -Force

        Add-Member -InputObject $this -Name "IncludeTitles" -MemberType ScriptProperty -Value {
            return $this._titleSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeActors" -MemberType ScriptProperty -Value {
            return $this._actorsSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeAlbums" -MemberType ScriptProperty -Value {
            return $this._albumSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeArtists" -MemberType ScriptProperty -Value {
            return $this._artistsSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeSeasonEpisodes" -MemberType ScriptProperty -Value {
            return $this._seasonEpisodeSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeSeries" -MemberType ScriptProperty -Value {
            return $this._seriesSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeStudios" -MemberType ScriptProperty -Value {
            return $this._studioSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeTracks" -MemberType ScriptProperty -Value {
            return $this._trackSplitIndex -ge 0
        } -Force

        Add-Member -InputObject $this -Name "IncludeYears" -MemberType ScriptProperty -Value {
            return $this._yearSplitIndex -ge 0
        } -Force
    }
    #endregion Constructors


    #region Methods
    [Void] Hidden UpdateIndexes() {
        $this._titleSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Title)
        $this._actorsSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Actors)
        $this._albumSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Album)
        $this._artistsSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Artists)
        $this._seasonEpisodeSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::SeasonEpisode)
        $this._seriesSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Series)
        $this._studioSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Studio)
        $this._trackSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Track)
        $this._yearSplitIndex = ([System.Array]$this.FilenameFormat).IndexOf([FilenameElement]::Year)
    }

    [Bool] RemodelFilenameFormat([Int] $swapElement, [Int] $withElement) {
        if (($swapElement -lt 0) -or ($swapElement -gt $this._FilenameFormat.Count - 1)) {
            Write-WarnToConsole "First element index is out of range, abandoning action."
            return $false
        }

        if (($withElement -lt 0) -or ($withElement -gt $this._FilenameFormat.Count - 1)) {
            Write-WarnToConsole "Second element index is out of range, abandoning action."
            return $false
        }

        [FilenameElement] $tempElement = $this._FilenameFormat[$swapElement]
        $this._FilenameFormat[$swapElement] = $this._FilenameFormat[$withElement]
        $this._FilenameFormat[$withElement] = $tempElement
        $this.UpdateIndexes()

        return $true
    }

    [Void] OverrideIncludedExtensions ([String[]] $includeExtensions) {
        if ($null -eq $includeExtensions) {
            $this._IncludedExtensions = @()
        }
        else {
            $this._IncludedExtensions = $includeExtensions
        }
    }

    [Void] OverrideTagsToDecorate ([String[]] $decorate) {
        if ($null -eq $decorate) {
            $this._DecorateAsTags = @()
        }
        else {
            $this._DecorateAsTags = $decorate
        }
    }

    [Void] OverrideTagDelimiters ([String] $openDelimiter, [String] $closeDelimiter) {
        $this._TagOpenDelimiter = $openDelimiter
        $this._TagCloseDelimiter = $closeDelimiter
    }

    [Void] OverrideFilenameFormat ([FilenameElement[]] $filenameFormat) {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }

        if ($null -eq $filenameFormat -or $filenameFormat.Count -lt 1) {
            Write-WarnToConsole "Warning: FilenameFormat must contain at least one FilenameElement, applying default behaviour instead."
            $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_FILM_FILENAME_FORMAT()
        }
        else {
            $this._FilenameFormat = $filenameFormat
        }

        $this.UpdateIndexes()
    }

    [Void] OverrideFilenameSplitter ([String] $filenameSplitter) {
        if ($null -eq $filenameSplitter -or $filenameSplitter.Length -lt 1) {
            Write-WarnToConsole "Warning: Filename splitter must contain at least one character, applying default behaviour instead."
            $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        }
        else {
            $this._FilenameSplitter = $filenameSplitter
        }
    }

    [Void] OverrideListSplitter ([String] $listSplitter) {
        if ($null -eq $listSplitter -or [String]::IsNullOrEmpty($listSplitter)) {
            Write-WarnToConsole "Warning: List splitter must contain at least one character, applying default behaviour instead."
            $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        }
        else {
            $this._ListSplitter = $listSplitter
        }
    }

    [Void] OverrideExportFormat ([ExportableAttribute[]] $exportFormat) {
        if ($null -eq $exportFormat -or $exportFormat.Count -lt 1) {
            Write-WarnToConsole "Warning: Export format must contain at least one ExportableAttribute, applying default behaviour instead."
            $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXPORT_FORMAT()
        }
        else {
            $this._ExportFormat = $exportFormat
        }
    }

    [Void] ConfigureForUnstructuredFiles () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }        
        $this._IncludedExtensions = @()
        $this._DecorateAsTags = @()
        $this._TagOpenDelimiter = ""
        $this._TagCloseDelimiter = ""
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_FILE_FILENAME_FORMAT()
        $this._FilenameSplitter = $null
        $this._ListSplitter = $null
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_FILES_EXPORT_FORMAT()

        $this.UpdateIndexes()
    }

    [Void] ConfigureForStructuredFiles ([FilenameElement[]] $filenameFormat) {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }
        $this._IncludedExtensions = @()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._TagOpenDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_OPEN_DELIMITER()
        $this._TagCloseDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_CLOSE_DELIMITER()
        $this._FilenameFormat = $filenameFormat
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_FILES_EXPORT_FORMAT()

        $this.UpdateIndexes()
    }
    
    [Void] ConfigureForFilm () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }
        
        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._TagOpenDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_OPEN_DELIMITER()
        $this._TagCloseDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_CLOSE_DELIMITER()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_FILM_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXPORT_FORMAT()

        $this.UpdateIndexes()
    }

    [Void] ConfigureForShortFilm () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }
        
        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._TagOpenDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_OPEN_DELIMITER()
        $this._TagCloseDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_CLOSE_DELIMITER()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_SHORTFILM_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXPORT_FORMAT()

        $this.UpdateIndexes()
    }

    [Void] ConfigureForSeries () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }
        
        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._TagOpenDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_OPEN_DELIMITER()
        $this._TagCloseDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_CLOSE_DELIMITER()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_SERIES_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXPORT_FORMAT()

        $this.UpdateIndexes()
    }
    
    [Void] ConfigureForTrack () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }

        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._TagOpenDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_OPEN_DELIMITER()
        $this._TagCloseDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_CLOSE_DELIMITER()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_TRACK_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXPORT_FORMAT()

        $this.UpdateIndexes()
    }

    [Void] ConfigureForAlbumAndTrack () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }

        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._TagOpenDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_OPEN_DELIMITER()
        $this._TagCloseDelimiter = [CollectionManagementDefaults]::DEFAULT_TAG_CLOSE_DELIMITER()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_ALBUMANDTRACK_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXPORT_FORMAT()

        $this.UpdateIndexes()
    }

    [Void] DisplayConfig() {
        Write-InfoToConsole ("Decorate as Tags          : " + ($this.DecorateAsTags -join ", "))
        Write-InfoToConsole ("Tag Delimiters            : """ + $this.TagOpenDelimiter + """ and  """ + $this.TagCloseDelimiter + """")
        Write-InfoToConsole ("Included Extensions       : " + ($this.IncludedExtensions -join ", "))
        Write-InfoToConsole ("Filename Format           : " + "[" + (([String[]]$this.FilenameFormat) -join ("]" + $this.FilenameSplitter + "[")) + "]")
        Write-InfoToConsole ("Filename Splitter         : """ + $this.FilenameSplitter + """")
        Write-InfoToConsole ("List Splitter             : """ + $this.ListSplitter + """")
        Write-InfoToConsole ("Export Format             : " + (([String[]]$this.ExportFormat) -join ", "))
        Write-InfoToConsole ("Is Filename Format Locked : " + (([String[]]$this.IsFilenameFormatLocked) -join ", "))
    }

    [Void] LockFilenameFormat() {
        $this._FilenameFormatLock = $true
    }
    #endregion Methods
}
#endregion Class Definition