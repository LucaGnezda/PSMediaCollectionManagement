#region Header
#
# About:  Type declarations for module 'PSMediaCollectionManagement' 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Type Declarations
#------------------------

enum FilenameElement {
    Studio = 1
    Actors = 2
    Artists = 3
    Series = 4
    Album = 5
    SeasonEpisode = 6
    Track = 7
    Title = 8
    Year = 9
}

enum ExportableAttribute {
    Filename = 1
    BaseName = 2
    Extension = 3
    FrameWidth = 4
    FrameHeight = 5
    FrameRate = 6
    Duration = 7
    BitRate = 8
    Hash = 9
}

enum ContentWarning {
    PartialLoad = 1
    NonCompliantFilename = 2
    ErrorLoadingProperties = 3
    FileNotFound = 4
    UnsupportedFileExtension = 5
    DuplicateDetectedInSources = 6
    MergeConflictsInData = 7
}

# Please note, the commented enums below are defined in the class files that implement them. Powershell 
# Seems unable to correctly handle a situation where a class with static methods, that requires an enum, 
# which is defined in another file. When this is attempted, while the class itself will function correctly, 
# but calling scopes only seem able to reference one of the two using statements at a time. if the second is 
# referenced, the first is effectively unloaded. This issue has been tested and confirmed in PowerShell 5, 
# 6 & 7.

# enum TestAttribute { ... } - implemented in PS.MCM.ModuleState.Abstract.psm1
# enum SeasonEpisodePattern { .. } - implemented in PS.MCM.SeasonEpisodeParser.Abstract.psm1

#endregion Type Declarations
