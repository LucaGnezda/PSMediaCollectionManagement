#region Header
#
# About: ModuleDefaults class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
#endregion Using



#region Abstract (sortof) Class Definition
#-----------------------------------------
class CollectionManagementDefaults {
    
    #region Static Properties
    #endregion Static Properties


    #region Constructors
    CollectionManagementDefaults () {

        # Prevent instantiation of this class
        if ($this.GetType() -eq [CollectionManagementDefaults]) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        }
    } 
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

    #endregion Static Methods

}
#endregion Abstract (sortof) Class Definition