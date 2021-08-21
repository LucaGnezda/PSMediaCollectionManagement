PS.MCM PowerShell Module (PowerShell Media Content Management)
=============
This is a Media Content Management Module. It's purpose is to help track, verify integrity and maintain a well defined file naming schema for media files. It achieves this by building an object graph of files within a folder. From there the user identify filename errors, bulk alter and update, check integrity, compare models, spellcheck (coming), etc. It can also save these models to a structured json, which can then be reloaded and/or compared with other files and models.

# Requirements
PowerShell 5 or later.

# Instructions
Pretty simple really:
```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)
# Import the module.
    # From the root
    Import-Module .\PS.MediaContentManagement

# Get commands in the module
    Get-Command -Module PS.MediaContentManagement

# And if you want to use the module types in your powershell session
    using module .\PS.MediaContentManagement\Using\Types\PS.MCM.Types.psm1
    using module .\PS.MediaContentManagement\Using\Helpers\PS.MCM.ElementParser.Abstract.psm1
    using module .\PS.MediaContentManagement\Using\ModuleBehaviour\PS.MCM.ModuleState.Abstract.psm1

# Get help
    Get-Help about_PS.MediaContentManagement
```

# Examples
Getting started:
```powershell
# Create a content model
$contentModel = New-ContentModel
```

Configure your content model, so it knows how to interpret your filesystem
```powershell
# Try things like ...
$contentModel.Config.ConfigureForSeries()
$contentModel.Config.ConfigureForFilm()
$contentModel.Config.ConfigureForShortFilm()
$contentModel.Config.ConfigureForAlbumAndTrack()
...

# try customisations like ...
$contentModel.Config.OverrideFilenameFormat(@([FilenameElement]::Series, [FilenameElement]::Title))
$contentModel.Config.OverrideFilenameSplitter(",")
```

Building a model from the filesystem content
```powershell
# Create a content model
$contentModel.Build()

# or if you want to include file matadata and generate hashes too
$contentModel.Build($true, $true)
```

Saving a model
```powershell
# Save a content model
$contentModel.SaveIndex(".\Index.json")
```

Loading a model
```powershell
# Load a content model
$contentModel.LoadIndex(".\Index.json")
```

Comparing models
```powershell
# Load a content model
Compare-ContentModels $contentModel ".\Index.json"
```

Verify Filesystem
```powershell
# Load a content model
Confirm-FilesystemHashes $contentModel
```

Walking through your model
```powershell
# Try things like
$contentModel.Content
$contentModel.Series
$contentModel.Albums.Matching(Foo).ProducedBy
```

Analysing your model
```powershell
# Try things like
$contentModel.AnalyseActorsForPossibleLabellingIssues()
$contentModel.AnalyseSeriesForPossibleLabellingIssues()
```

Altering your model
```powershell
# Try things like
$contentModel.AlterArtist("Foo", "Bar")
$contentModel.AlterSeasonEpisodeFormat(2, 2, [SeasonEpisodePattern]::Uppercase_S0E0, $false)
```

Doing other things with your models
```powershell
# Try things like
$contentModelCopy = Copy-ContentModel $contentModel
$mergedContentModel = Merge-ConentModel $contentModel1 $contentModel2
```

# Roadmap
Things still to be done:
| Type | Feature / Improvement | Status |
| ---- | ---------------- | ------ |
| Feature | Create Test Helpers to better present code coverage results | :heavy_minus_sign: |
| Feature | Have ContentModels remember the load/build path so they continue to work correctly when you change directories | :heavy_minus_sign: |
| Feature | Title analysis, generating word dictionaries and spellchecking | :heavy_minus_sign: |
| Feature | Readme | :heavy_check_mark: |
| Codebase Improvement | Include a module definition & get-help about | :heavy_check_mark: |
| Codebase Improvement | Credit authors where I have reused functions/code | :heavy_check_mark: |
| Codebase Improvement | Figure out why Pester errors on Code Coverage when using the new v5 Syntax and Configuration | :heavy_minus_sign: |
| Codebase Improvement | Re-organise public functions into logical groups | :heavy_check_mark: | 
| Codebase Improvement | Comment all public functions with help blocks | :heavy_minus_sign: | 
| Codebase Improvement | Appveyor badge support | :heavy_minus_sign: | 

Where:
- :heavy_minus_sign: = Not Started
- :construction: = In progress
- :heavy_check_mark: = Completed (in the last few releases)

# Notes
- This Module includes Write-Host wrappers so you can do a few cool things:
    - Manage auto output indenting 
    - Implement a mock console whose output can then be tested using Pester
    - Output colourful custom formatted tables
- Probably just a bug in this module, but PowerShell seems unable to correctly handle a situation where a class with static methods, that requires an enum, which is defined in another file. When this is attempted, while the class itself will function correctly, calling scopes only seem able to reference one of the two using statements at a time. if the second is referenced, the first is effectively unloaded. This issue has been tested and confirmed in PowerShell 5, 6 & 7.

# Credits
Would like to thank/credit a bunch of contributors and the community ...
- [RamblingCookieMonster](https://github.com/RamblingCookieMonster) for their module architecture/pattern
- [gravejester](https://github.com/gravejester) for their string approximation functions.
- Pretty much everyone on StackOverflow, for pretty much having answers to every questions ever conceived.
- The Pester community, for creating an awesome PowerShell testing framework.



 