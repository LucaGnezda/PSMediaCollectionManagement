#region Header
#
# About: ModuleSettings class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\PS.MCM.Types.psm1
#endregion Using



#region Abstract (sortof) Class Definition
#-----------------------------------------
class ModuleSettings {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    # This class is intented to be used as an abstract class. However PowerShell cannot declare abstract classes, 
    # nor can it force disposal of a class. So there is no way to prevent this class being instantiated. 
    # That said, it will still work well enough if instantiated.
    #endregion Constructors


    #region Static Methods
    [System.Array] static DEFAULT_AUDIO_EXTENSIONS() {
        return @(".mp3", ".aac", ".wav")
    }

    [System.Array] static DEFAULT_VIDEO_EXTENSIONS() {
        return @(".mp4", ".wmv", ".mkv")
    }

    [System.Array] static DEFAULT_TAGS() {
        return @("Unknown", "Various")
    }

    [Int] static DEFAULT_MAX_METADATA_PROPERTIES() {
        return 320
    }

    [String] static DEFAULT_FILENAME_SPLITTER() {
        return " - "
    }

    [String] static DEFAULT_LIST_SPLITTER() {
        return ", "
    }

    [System.Array] static DEFAULT_SHORTFILM_FILENAME_FORMAT() {
        return @([FilenameElement]::Studio, [FilenameElement]::Title)
    }

    [System.Array] static DEFAULT_FILE_FILENAME_FORMAT() {
        return @([FilenameElement]::Title)
    }
    
    [System.Array] static DEFAULT_FILM_FILENAME_FORMAT() {
        return @([FilenameElement]::Title)
    }

    [System.Array] static DEFAULT_SERIES_FILENAME_FORMAT() {
        return @([FilenameElement]::Series, [FilenameElement]::SeasonEpisode, [FilenameElement]::Title)
    }

    [System.Array] static DEFAULT_TRACK_FILENAME_FORMAT() {
        return @([FilenameElement]::Artists, [FilenameElement]::Title)
    }

    [System.Array] static DEFAULT_ALBUMANDTRACK_FILENAME_FORMAT() {
        return @([FilenameElement]::Artists, [FilenameElement]::Album, [FilenameElement]::Title)
    }

    [System.Array] static DEFAULT_AUDIO_EXPORT_FORMAT() {
        return @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Duration, [ExportableAttribute]::BitRate, [ExportableAttribute]::Hash)
    }

    [System.Array] static DEFAULT_VIDEO_EXPORT_FORMAT() {
        return @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::FrameWidth, [ExportableAttribute]::FrameHeight, [ExportableAttribute]::FrameRate, [ExportableAttribute]::Duration, [ExportableAttribute]::BitRate, [ExportableAttribute]::Hash)
    }

    [System.Array] static DEFAULT_FILES_EXPORT_FORMAT() {
        return @([ExportableAttribute]::FileName, [ExportableAttribute]::BaseName, [ExportableAttribute]::Extension, [ExportableAttribute]::Hash)
    }

    [System.Array] static DEFAULT_CONFIG_EXPORT_FORMAT() {
        return @("_IncludedExtensions","_DecorateAsTags","_FilenameFormat","_FilenameSplitter","_ListSplitter","_ExportFormat")
    }

    [String] static DEFAULT_MODULE_FILETYPE() {
        return "ContentModel.JsonIndex.V2"
    }

    [Int] static TOCONSOLE_MIN_INDENT() {
        return 1
    }

    [String] static TOCONSOLE_TAB() {
        return "  "
    }
    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition