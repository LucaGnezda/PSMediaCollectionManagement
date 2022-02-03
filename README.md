https://img.shields.io/badge/PowerShell-5%2B-5391FE.svg?logo=powershell
PowerShell Media Collection Management (Module)
=============
This is a filesystem media collection management module for PowerShell. Its purpose is to help manage a well defined file naming structure, as well as track file integrity for files under management. It works by capturing information about files from properties, hash and filename, then builds a object graph based on the naming structure. From there the user can identify filename inconsistencies, perform a range of bulk alters and updates, check integrity, compare models, copy and merge models, check spelling, etc. The user can also save models to a structured json file, which can then be reloaded at a later time to re-compare against the filesystem or other models.

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
    Import-Module .\PS.MediaCollectionManagement

# Get commands in the module
    Get-Command -Module PS.MediaCollectionManagement

# Get help
    Get-Help about_PS.MediaCollectionManagement
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
# Build a content model
$contentModel.Build()

# or if you want to include file matadata and generate hashes too
$contentModel.Build($true, $true)

# or with pathing
$contentModel.Build(".\..\MyMediaFolder", $true, $true)
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
# Compare a content model
Compare-ContentModels $contentModel ".\Index.json"
Compare-ContentModels ".\IndexA.json" ".\IndexB.json"
Compare-ContentModels $contentModelA $contentModelB 
Compare-ContentModels ".\..\MyMediaFolder" ".\Index.json"
Compare-ContentModels ".\..\MyMediaFolder" $contentModelA
```

Copying models
```powershell
# Create a new memory (independent) copy a content model
$contentModelCopy = Copy-ContentModel $contentModel
```

Merging models
```powershell
# Create a new memory (independent) merged copy a content model
$mergedContentModel = Merge-ConentModel $contentModel1 $contentModel2
```

Verify Filesystem
```powershell
# Validate content hashes against a content model
Test-FilesystemHashes $contentModel
```

Walking through your model
```powershell
# Try things like
$contentModel.Content
$contentModel.Series
$contentModel.Albums.Matching("Foo").ProducedBy
```

Analysing your model
```powershell
# Try things like
$contentModel.AnalyseActorsForPossibleLabellingIssues()
$contentModel.AnalyseSeriesForPossibleLabellingIssues()
$contentModel.SpellcheckContentTitles()
```

Altering your model
```powershell
# Try things like
$contentModel.AlterArtist("Foo", "Bar")
$contentModel.AlterSeasonEpisodeFormat(2, 2, [SeasonEpisodePattern]::Uppercase_S0E0, $false)
```

# Roadmap
Things still to be done, in progress, or recently completed:
| Type | Feature / Improvement | Status |
| ---- | ---------------- | ------ |
| Feature | Title analysis, generating word dictionaries and spellchecking | :heavy_check_mark: |
| Feature | Create Test Helpers to better present code coverage results | :heavy_check_mark: |
| Feature | Allow content model methods to select paths, giving greater control regardless of your current filesystem location. | :heavy_check_mark: |
| Feature | Be able to compare a model directly with the filesystem | :heavy_check_mark: |
| Feature | Custom dictionaries | :heavy_minus_sign: |

| Type | Feature / Improvement | Status |
| ---- | ---------------- | ------ |
| Codebase Improvement | Improve usability of enums for internal and console use | :heavy_check_mark: |
| Codebase Improvement | Implementation of pseudo abstract and interface classes | :heavy_check_mark: |
| Codebase Improvement | Refactoring over several iterations towards 'go well' principles | :heavy_check_mark: |
| Codebase Improvement | Figure out why Pester errors on Code Coverage when using the new v5 Syntax and Configuration (Pester fixed by v5.3.1) | :heavy_check_mark: |
| Codebase Improvement | Appveyor badge support | :heavy_minus_sign: | 

| Type | Feature / Improvement | Status |
| ---- | ---------------- | ------ |
| Bugfix | Fixed cross reference remapping when altering Studio and Album parts of an object graph | :heavy_check_mark: | 

Where:
- :heavy_minus_sign: = Not Started
- :construction: = In progress
- :heavy_check_mark: = Completed (in the last few releases)

# Notes
- This Module includes Write-Host wrappers so you can do a few cool things:
    - Manage auto output indenting 
    - Implement a mock console whose output can then be tested using Pester
    - Output colourful custom formatted tables
- Implementing classes that use console enums as parameters in their public methods is problematic in PowerShell. In part this is because PowerShell is really a language of two halves, an OO and a procedural implementation. If we want to export an enum from a Module in PowerShell we have two options, each with their limitations. We either define them as .net enums (Add-Type), or we need to 'using' a module that contains the PowerShell enums. The problems are that; 'Add-Type' isn't available at parse time, 'using' requires the end user to know the structure of the module if they need to use the types (which this module does), and 'using' types has known issues all the way to PowerShell v7 (refer to logged issues in the PowerShell repos). To avoid these limitations, this module implements enums twice, one for class definitions and the parser, and one for console users. For a full explanation, please refer to the comment block where these types are defined.
- PowerShell doesn't implement static classes (but does do properties and methods), abstract classes or interfaces. To get around this limitation, this module implements pseudo static, pseudo abstract and pseudo interfaces with ordinary classes and a little bit of reflection.
- Interfaces then allow the module to implement dependency injection (DI) with formal contracts.
- The current implementation of the SpellcheckProvider interface require a local install of Microsoft Word. This was done so spellchecking could run exclusively from the local machine, and to a very high standard. However because providers have been implemented with dependency injection, this will more easily allow alternate implementations to be substituted or added in the future. 
- I know The code is still a little messy. Like most coded messes it started out as a 'I wonder if I could' thought experiment. I wasn't sure exactly how I wanted the code to work, what I was building, or even if it was worth maintaining once I had something. But now that I'm actively using it on my various multimedia archives, and I'm happy with the core functionality, I have a sense of the architecture I want. So I'm progressively refactor the code with purpose towards 'go well' principles (thanks Uncle Bob).  

# Developer tips
- This module has been implemented using Visual Studio Code, and is known to work well with this IDE.
- If you would like to attach a Visual Studio Code debugger it is recommended you configure the debugger to run an interactive PowerShell session.
- Please note, modules with classes won't re-load correctly after being changed in PowerShell 5. If you change the code, remember to re-start your IDE before restarting your debugger.

# Code coverage
- This module implements a suite of automated pester tests, which generate JoCoCo code coverage results.
- Several helper commands have been implemented to assist with test automation and the production of friendly code coverage results. 
- To generate friendly code coverage results, the JoCoCo results are parsed, merged with a known coverage exceptions list, then converted into a more friendly and discoverable format to console and markdown.
- The latest friendly [code coverage results](./FriendlyCoverageReport.md) can be found here. 

# Credits
Would like to thank/credit a bunch of contributors and the community ...
- [unclebob](https://github.com/unclebob) and his amazing conference talks, for the inspiration I needed to start cleaning up the code and to work out how to implement pseudo interfaces. It then allowed me to implement inversion of control, DI and improved modularisation. 
- [RamblingCookieMonster](https://github.com/RamblingCookieMonster) for inspiration on structuring modules
- [gravejester](https://github.com/gravejester) for the PowerShell implementation of Levenshtein string similarity functions.
- Pretty much everyone on [StackOverflow](https://stackoverflow.com/), for pretty much having answers to every questions ever conceived (except PowerShell Interfaces :P).
- The [Pester community](https://github.com/pester/Pester), for creating an awesome PowerShell testing framework.
