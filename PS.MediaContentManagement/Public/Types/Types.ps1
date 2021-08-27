#region Exported Type Declarations (Public)
#----------------------------------------

# Why are the enums duplicated?
# Implementing Classes that use enums as parameters in their public methods is tricky in PowerShell. In part this is because PowerShell is really a 
# language of two halves, OO and procedural. If we want to export an enum from a Module in PowerShell we need to either define it as .net enum 
# (Add-Type), or we need to 'using' the module that contains the types. The second approach is problematic when implementing modules because the end 
# user then needs to know about the inner file structure of the module to expose the enums. Ideally these would be implicitly exposed when the module 
# is imported into the console session. Another issue is that using is flaky when 'using' a type and a class that uses it, when each exist in separate 
# files. When you do this, only one of the two definitions is available to the console at a time, due to the two different scopes of the inner and console
# usings. 
#
# Conversely, classes are more than happy to use the 'using' approach as defined by a module, because they all exist in the same scope. But because of 
# the way using works, the entire using tree is traversed first, then the script syntax is parsed, then script itself run. This means the Add-Type enums are 
# not known to the parser when the script syntax is parsed. This meams Add-Type enums and classes can't work together in the same module. The only way 
# around this would be to define the .net types in a dependency module which is then required by the module you're writing. This creates other deployment 
# complexities.
#
# So now we're in a catch 22, we need the Add-Type approach so we can export the types cleanly, and we need the using approach so classes have the defined 
# types they need.
#
# So this module, takes a dual implementation approach, where the Add-Type enums are defined for public use (the console that imports the module) and the 
# using enums are private, for use by the classes within the module. Thankfully, PowerShell is more than happy to implicitly convert between these two types. 
#
# But, to ensure these two implementations remain in sync, a Pester Test has been created that Tokenises the using script file, then compares this against 
# the exported enum types.     



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