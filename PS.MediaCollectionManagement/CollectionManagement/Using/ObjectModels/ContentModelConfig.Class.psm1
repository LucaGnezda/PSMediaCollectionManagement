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
using module .\..\ModuleBehaviour\CollectionManagementDefaults.Abstract.psm1
#endregion Using


#region Class Definition
#-----------------------
class ContentModelConfig {

    #region Properties
    [String[]] hidden $_IncludedExtensions
    [String[]] hidden $_DecorateAsTags
    [FilenameElement[]] hidden $_FilenameFormat
    [String] hidden $_FilenameSplitter
    [String] hidden $_ListSplitter
    [ExportableAttribute[]] hidden $_ExportFormat
    [Bool] hidden $_FilenameFormatLock
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
    }
    #endregion Constructors


    #region Methods
    [Void] OverrideIncludedExtensions ([System.Array] $includeExtensions) {
        if ($null -eq $includeExtensions) {
            $this._IncludedExtensions = @()
        }
        else {
            $this._IncludedExtensions = $includeExtensions
        }
    }

    [Void] OverrideTagsToDecorate ([System.Array] $decorate) {
        if ($null -eq $decorate) {
            $this._DecorateAsTags = @()
        }
        else {
            $this._DecorateAsTags = $decorate
        }
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
        $this._IncludedExtensions = @()
        $this._DecorateAsTags = @()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_FILE_FILENAME_FORMAT()
        $this._FilenameSplitter = $null
        $this._ListSplitter = $null
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_FILES_EXPORT_FORMAT()
    }
    
    [Void] ConfigureForFilm () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }
        
        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_FILM_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXPORT_FORMAT()
    }

    [Void] ConfigureForShortFilm () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }
        
        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_SHORTFILM_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXPORT_FORMAT()
    }

    [Void] ConfigureForSeries () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }
        
        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_SERIES_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_VIDEO_EXPORT_FORMAT()
    }
    
    [Void] ConfigureForTrack () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }

        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_TRACK_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXPORT_FORMAT()
    }

    [Void] ConfigureForAlbumAndTrack () {
        if ($this._FilenameFormatLock) {
            Write-WarnToConsole "Warning: FilenameFormat cannot be reconfigured once settings have been applied to a ContentModel, abandoning operation."
            return 
        }

        $this._IncludedExtensions = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXTENSIONS()
        $this._DecorateAsTags = [CollectionManagementDefaults]::DEFAULT_TAGS()
        $this._FilenameFormat = [CollectionManagementDefaults]::DEFAULT_ALBUMANDTRACK_FILENAME_FORMAT()
        $this._FilenameSplitter = [CollectionManagementDefaults]::DEFAULT_FILENAME_SPLITTER()
        $this._ListSplitter = [CollectionManagementDefaults]::DEFAULT_LIST_SPLITTER()
        $this._ExportFormat = [CollectionManagementDefaults]::DEFAULT_AUDIO_EXPORT_FORMAT()
    }

    [Void] DisplayConfig() {
        Write-InfoToConsole ("Decorate as Tags          : " + ($this.DecorateAsTags -join ", "))
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