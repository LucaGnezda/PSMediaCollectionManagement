#region Exported Type Declarations (Public)
#----------------------------------------
Add-Type @'
public enum FilenameElement {
    Studio = 1,
    Actors = 2,
    Artists = 3,
    Series = 4,
    Album = 5,
    SeasonEpisode = 6,
    Track = 7,
    Title = 8,
    Year = 9
}
'@

Add-Type @'
public enum ExportableAttribute {
    Filename = 1,
    BaseName = 2,
    Extension = 3,
    FrameWidth = 4,
    FrameHeight = 5,
    FrameRate = 6,
    Duration = 7,
    BitRate = 8,
    Hash = 9
}
'@

Add-Type @'
public enum ContentWarning {
    PartialLoad = 1,
    NonCompliantFilename = 2,
    ErrorLoadingProperties = 3,
    FileNotFound = 4,
    UnsupportedFileExtension = 5,
    DuplicateDetectedInSources = 6,
    MergeConflictsInData = 7
}
'@

Add-Type @'
public enum TestAttribute {
    MockDestructiveActions = 1,
    SuppressConsoleOutput = 2
}
'@ 

Add-Type @'
public enum SeasonEpisodePattern {
    Uppercase_S0E0 = 0,
    Lowercase_S0E0 = 1,
    Uppercase_0X0 = 2,
    Lowercase_0X0 = 3
}
'@ 
#endregion Exported Type Declarations (Public)