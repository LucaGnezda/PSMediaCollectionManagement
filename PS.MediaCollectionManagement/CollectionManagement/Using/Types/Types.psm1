#region Header
#
# About:  Type declarations for module 'PSMediaCollectionManagement' 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using Type Declarations (Private)
#----------------------------------------

# Why are the enums duplicated?
# Implementing classes that use console enums as parameters in their public methods is problematic in PowerShell. In part this is because PowerShell is 
# really a language of two halves, an OO and a procedural implementation. If we want to export an enum from a Module in PowerShell we have two options, 
# each with their limitations. We either define them as .net enums (Add-Type), or we need to 'using' a module that contains the PowerShell enums. 
#
# Classes are more than happy to use the 'using' approach as defined by a module, because they all exist in the same scope. Because of the way using works, 
# the entire using tree is traversed first, then the script syntax is parsed, then script itself run. This means Module level Powershell can happliy use
# them. But this approach is problematic for end users who need these enums in the console. They need to know where these files live in order to to 
# reference them, meaning they need to understand the internal structure of the module. Re-'using' these enums in the console is also problematic when they 
# span several files. There are known bugs in the PowerShell definition cache which means previously used enums have a tendency to unload when new files are 
# used.
#
# The .net enums (Add-Type) approach suffers the opposite problem. They work quite happily in the console, as they can be dot-sourced into the console by 
# the module, meaning they are loaded implicitly when the module is imported. But because Add-Type enums are defined at script execution time,
# they are not available to the parser, meaning classes can't use them as part of their definitions.
# 
# So now we're in a catch 22, we need the Add-Type approach so we can export the types cleanly, and we need the using approach so classes have the defined 
# types they need.
#
# So this module, takes a dual implementation approach, where the Add-Type enums are defined for public use (the console that imports the module) and the 
# using enums are private, for use by the classes within the module. Thankfully, PowerShell is more than happy to implicitly convert between these two 
# versions of enums. 
#
# But, to ensure these two implementations remain in sync, a Pester Test has been created that Tokenises the using script file, then compares this against 
# the exported enum types.     

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
    NonCompliantFilename = 1                  # Set whenever the filename does not match the selected filename configuration, or when loading subject info results in an error
    SubjectInfoSkipped = 2                    # Set whenever subject info could not be loaded (typically the result of a non compliant filename)
    SubjectInfoNotFullyLoaded = 3             # Set whenever subject info was attempted, but could not be fully loaded (typically the result of a malformed filename element)
    PropertyInfoLoadingError = 4              # Set whenever an error prevents loading of all properties
    PropertyInfoFileNotFound = 5              # Set whenever property info could not be loaded because the file could not be found
    PropertyInfoUnsupportedFileExtension = 6  # Set whenever file propoerties are requested for a file extention that is not currently supported by MediaCollectionManagement
    HashLoadingError = 7                      # Set whenever an error occurs while generating a hash
    HashFileNotFound = 8                      # Set whenever a hash could not be generated because the file could not be found
    DuplicateDetectedInSources = 9            # Set whenever a duplicate file load is attempted
    MergeConflictsInData = 10                 # Set whenever a duplicate is found during a load or merge, but the file properties differ
}

enum SeasonEpisodePattern {
    Uppercase_S0E0 = 0
    Lowercase_S0E0 = 1
    Uppercase_0X0 = 2
    Lowercase_0X0 = 3
} 
#endregion Using Type Declarations (Private)



