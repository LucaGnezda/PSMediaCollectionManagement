PS.MCM PowerShell Module (PowerShell Media Content Management)
=============
This is a filesystem media content management module. Its purpose is to help manage a well defined file naming structure, as well as track file integrity for files under management. It works by capturing information about files from properties, hash and filename, then builds a object graph based on the naming structure. From there the user can identify filename inconsistencies, perform a range of bulk alters and updates, check integrity, compare models, copy and merge models, check spelling (coming soon), etc. The user can also save models to a structured json file, which can then be reloaded at a later time to re-compare against the filesystem or other models.

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
| Codebase Improvement | Improve usability of enums for internal and console use | :heavy_check_mark: |
| Codebase Improvement | Include a module definition & get-help about | :heavy_check_mark: |
| Codebase Improvement | Credit authors where I have reused functions/code | :heavy_check_mark: |
| Codebase Improvement | Figure out why Pester errors on Code Coverage when using the new v5 Syntax and Configuration | :heavy_minus_sign: |
| Codebase Improvement | Re-organise public functions into logical groups | :heavy_check_mark: | 
| Codebase Improvement | Comment all public functions with help blocks | :heavy_check_mark: | 
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
- 'Using' is flaky when a class uses another module to define enums which are then used a parameters in public methods. While the class itself behaves fine, the console gets a problematic experience where you can only refence one of the two definitions at a time. I believe this is due to the two different scopes (inner and console usings) resetting the scope for each other. 
- Enums are also difficult when used as class method parameters in modules. To properly export enums from a module you need them to be defined with Add-Type, but classes need them defines in module files referenced by using. These two needs are incompatible, so instead this code defines them twice, once for the class definitions and once for console ease of use. These are then sync checked by parsing the enum type module file and comparing it with the exportable enums with Pester.

# Credits
Would like to thank/credit a bunch of contributors and the community ...
- [RamblingCookieMonster](https://github.com/RamblingCookieMonster) for inspiration on structuring modules
- [gravejester](https://github.com/gravejester) for their string approximation functions.
- Pretty much everyone on StackOverflow, for pretty much having answers to every questions ever conceived.
- The Pester community, for creating an awesome PowerShell testing framework.



 