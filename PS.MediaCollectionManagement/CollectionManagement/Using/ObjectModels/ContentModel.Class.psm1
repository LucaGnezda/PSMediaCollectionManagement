#region Header
#
# About: ContentModel class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\Controllers\CollectionManagementController.Abstract.psm1
using module .\..\Helpers\ContentSubjectParser.Abstract.psm1
using module .\..\ModuleBehaviour\CollectionManagementDefaults.Abstract.psm1
using module .\ContentModelConfig.Class.psm1
using module .\Actor.Class.psm1
using module .\Album.Class.psm1
using module .\Artist.Class.psm1
using module .\Series.Class.psm1
using module .\Studio.Class.psm1
using module .\Content.Class.psm1
using module .\ContentComparer.Class.psm1
using module .\SpellcheckResult.Class.psm1
using module .\..\..\..\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1

#endregion Using


#region Class Definition
#-----------------------
class ContentModel : IContentModel {

    #region Properties
    [System.Collections.Generic.List[Object]] $Actors
    [System.Collections.Generic.List[Object]] $Albums
    [System.Collections.Generic.List[Object]] $Artists
    [System.Collections.Generic.List[Object]] $Series
    [System.Collections.Generic.List[Object]] $Studios
    [System.Collections.Generic.List[Object]] $Content
    [ContentModelConfig] $Config
    #endregion Properties


    #region Constructors
    ContentModel(){
        
        # Instantiate the config object
        $this.Config = [ContentModelConfig]::new()  

    }
    #endregion Constructors


    #region Initialiser
    [Void] Init() {
        
        # Lock the filename format
        $this.Config.LockFilenameFormat()
        
        # If the FilenameFormat includes Actors, initialise the Actors property and methods
        if ([FilenameElement]::Actors -in $this.Config.FilenameFormat) {

            # Initialise the Actors collection
            $this.Actors = [System.Collections.Generic.List[Actor]]::new()
        
            # Add Members to the Actors Generic List
            Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Actors = $null
        }

        # If the FilenameFormat includes Albums, initialise the Albums property and methods
        if ([FilenameElement]::Album -in $this.Config.FilenameFormat) {

            # Initialise the Studios collection
            $this.Albums = [System.Collections.Generic.List[Album]]::new()
        
            # Add Members to the Studios Generic List
            Add-Member -InputObject $this.Albums -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Albums -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Albums -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Albums = $null
        }

        # If the FilenameFormat includes Artists, initialise the Artists property and methods
        if ([FilenameElement]::Artists -in $this.Config.FilenameFormat) {

            # Initialise the Artists collection
            $this.Artists = [System.Collections.Generic.List[Artist]]::new()
        
            # Add Members to the Content Generic List
            Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Artists = $null
        }

        # If the FilenameFormat includes Series, initialise the Series property and methods
        if ([FilenameElement]::Series -in $this.Config.FilenameFormat) {

            # Initialise the Series collection
            $this.Series = [System.Collections.Generic.List[Series]]::new()
        
            # Add Members to the Series Generic List
            Add-Member -InputObject $this.Series -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Series -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Series -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Series = $null
        }

        # If the FilenameFormat includes Studios, initialise the Studios property and methods
        if ([FilenameElement]::Studio -in $this.Config.FilenameFormat) {

            # Initialise the Studios collection
            $this.Studios = [System.Collections.Generic.List[Studio]]::new()
        
            # Add Members to the Studios Generic List
            Add-Member -InputObject $this.Studios -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property)  
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.Studios -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force

            Add-Member -InputObject $this.Studios -MemberType ScriptMethod -Name GetByName -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -ceq $s})
            } -Force
        }
        else {
            $this.Studios = $null
        }

        # Initialise the Content collection
        $this.Content = [System.Collections.Generic.List[Content]]::new()
       
        # Add Members to the Content Generic List
        Add-Member -InputObject $this.Content -MemberType ScriptMethod -Name SortedBy -Value { 
            param ([String[]] $property)  
            return ($this | Sort-Object $property)
        } -Force

        Add-Member -InputObject $this.Content -MemberType ScriptMethod -Name Matching -value {
            param ([String] $s)
            return ($this | Where-Object {$_.Title -match $s})
        } -Force

        Add-Member -InputObject $this.Content -MemberType ScriptMethod -Name GetByFileName -value {
            param ([String] $s)
            return ($this | Where-Object {$_.FileName -ceq $s})
        } -Force
    }
    #endregion Initialiser


    #region Resetter
    [Void] Reset() {
        $this.Actors = $null
        $this.Albums = $null
        $this.Artists = $null
        $this.Series = $null
        $this.Studios = $null
        $this.Content = $null
        $this.Config._FilenameFormatLock = $false
    }
    #endregion Resetter


    #region Public Methods
    [Void] Build() {
        $this.Build($false, $false)
    }

    [Void] Build([Bool] $loadProperties, [Bool] $generateHash) {

        # Start starting state
        $i = 0
        $loadWarnings = 0
        $disposeWhenDone = $null
        
        # Initialise the ContentModel
        $this.Init()
        
        # Instantiate Shell now so it is retained for the life of the method.
        if ($loadProperties) {
            $disposeWhenDone = [FilesystemExtensionsState]::InstantiateShell()
        }

        # read the filesystem
        if ($this.Config.IncludedExtensions.Count -eq 0) {
            [Object[]] $files = Get-ChildItem -File
        }
        else {
            [Object[]] $files = Get-ChildItem -File | Where-Object {$_.Extension -in $this.Config.IncludedExtensions} 
        }

        # for each file
        foreach ($file in $files) {    
        
            # Show a progress bar
            Write-Progress -Activity "Generating Model" -Status ("Processing Item: " + ($i + 1) + " | " + $file.Name) -PercentComplete (($i * 100) / $files.count)

            # Add the file
            $addedContent = $this.AddContentToModel($file)

            # If requested, load properties
            if ($loadProperties) {
                $addedContent.FillPropertiesWhereMissing($file, $true)
            }

            # If requested, generate a hash
            if ($generateHash) {
                $addedContent.GenerateHashIfMissing($file, $true)
            }

            # track any warnings
            if ($addedContent.Warnings.Count -gt 0) {
                $loadWarnings++
            }

            # Increment the counter
            $i++
        
        }

        # Dispose non GC objects
        if ($disposeWhenDone) {
            [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
        }

        # Hide the progress bar
        Write-Progress -Activity "Generating Model" -Completed

        # Provide tips to console
        if ($loadWarnings) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Not all content loaded successfully. To identify problematic content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::PartialLoad}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::NonCompliantFilename}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::FileNotFound}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::UnsupportedFileExtension}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::ErrorLoadingProperties}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings.Count -gt 0}"
            Remove-ConsoleIndent
        }
    }

    [Void] Rebuild() {
        $this.Rebuild($false, $false) 
    }

    [Void] Rebuild([Bool] $loadProperties, [Bool] $generateHash) {

        [System.Collections.Generic.List[String]] $ToProcess = [System.Collections.Generic.List[String]]::new()
        [System.Collections.Generic.List[String]] $ToAdd  = [System.Collections.Generic.List[String]]::new()
        [System.Collections.Generic.List[String]] $ToRemove  = [System.Collections.Generic.List[String]]::new()

        # Set starting state
        $loadWarnings = 0
        $disposeWhenDone = $null

        # Get the current list of files
        [Object[]] $files = Get-ChildItem -File | Where-Object {$_.Extension -in $this.Config.IncludedExtensions}

        # Instantiate Shell now so it is retained for the life of the method.
        if ($loadProperties) {
            $disposeWhenDone = [FilesystemExtensionsState]::InstantiateShell()
        }

        # Pre-process
        Write-InfoToConsole "Indexing changes ..."
        foreach ($item in $this.Content) {
            $ToProcess.Add($item.FileName)
        }

        foreach ($file in $files) {
            if ($ToProcess.Contains($file.Name)) {
                $ToProcess.Remove($file.Name) > $null
            }
            else {
                $ToAdd.Add($file.Name)
            }
        }

        foreach ($item in $ToProcess) {
            $ToRemove.Add($item)
        }
        $ToProcess.Clear()

        # Process removals
        foreach ($item in $ToRemove) {

            Write-ToConsole -ForegroundColor Magenta "Removing: " $item
            $this.RemoveContentFromModel($item)

        }

        # Process the additions
        foreach ($item in $ToAdd) {
        
            Write-ToConsole -ForegroundColor Cyan "Adding:   " $item
            $file = Get-ChildItem -File $item

            $addedContent = $this.AddContentToModel($file)

            # track any warnings
            if ($addedContent.Warnings.Count -gt 0) {
                $loadWarnings++
            }
        }

        # If requested, populate missing properties 
        if ($loadProperties -or $generateHash) {

            # initialise progress
            Write-InfoToConsole "Populating missing properties on existing ..."
            $i = 0

            foreach ($item in $this.Content) {

                Write-Progress -Activity "Populating missing properties" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $this.Content.count)

                # If requested, load properties
                if ($loadProperties) {
                    $item.FillPropertiesWhereMissing()
                }

                # If requested, generate a hash
                if ($generateHash) {
                    $item.GenerateHashIfMissing()
                }
           
                # track any warnings
                if ($item.Warnings.Count -gt 0) {
                    $loadWarnings++
                }

                # Increment the counter
                $i++
            }

            Write-Progress -Activity "Populating missing properties" -Completed
        }

        # Dispose non GC objects
        if ($disposeWhenDone) {
            [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
        }

        # Resort the list
        Write-InfoToConsole "Resorting the list"
        $comp = [ContentComparer]::new("FileName")
        $this.Content.Sort($comp)

        # Provide tips to console
        if ($loadWarnings) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Not all content loaded successfully. To identify problematic content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::PartialLoad}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::NonCompliantFilename}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::FileNotFound}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::UnsupportedFileExtension}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::ErrorLoadingProperties}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings.Count -gt 0}"
            Remove-ConsoleIndent
        }

    }

    [Void] LoadIndex () {
        $this.LoadIndex(".\Index.json", $false)
    }

    [Void] LoadIndex ([String] $indexFilePath) {
        $this.LoadIndex($indexFilePath, $false)
    }

    [Void] LoadIndex ([Bool] $collectInfoWhereMissing) {
        $this.LoadIndex(".\Index.json", $collectInfoWhereMissing)
    }

    [Void] LoadIndex ([String] $indexFilePath, [Bool] $collectInfoWhereMissing) {

        # First validate the index filepath
        if (-not (Test-Path $indexFilePath)) {
            Write-ErrorToConsole "Error: Invalid filepath"
            return
        }

        # Set starting state
        $i = 0
        $loadWarnings = 0
        $disposeWhenDone = $null
        
        # Initialise the ContentModel
        $this.Init()

        # Instantiate Shell now so it is retained for the life of the method.
        if ($collectInfoWhereMissing) {
            $disposeWhenDone = [FilesystemExtensionsState]::InstantiateShell()
        }

        # Read in the json
        try {
            [PSCustomObject] $incoming = (Get-Content -Raw -Path $IndexFilePath | ConvertFrom-Json)    
        }
        catch {
            Write-ErrorToConsole "Error parsing file, abandoning action"
            Write-ErrorToConsole $_
            return
        }

        # Determine file format
        if (([Bool]($incoming.PSObject.Properties.Name -match "FileType")) -and 
            ([Bool]($incoming.PSObject.Properties.Name -match "Config")) -and 
            ([Bool]($incoming.PSObject.Properties.Name -match "Content")) -and 
            ($incoming.FileType -eq [CollectionManagementDefaults]::DEFAULT_MODULE_FILETYPE())) {
        
            # v2 format
            Write-InfoToConsole "V2 FileType detected, processing ..."

            $this.Config._IncludedExtensions = $incoming.Config._IncludedExtensions
            $this.Config._DecorateAsTags = $incoming.Config._DecorateAsTags
            $this.Config._FilenameFormat = $incoming.Config._FilenameFormat
            $this.Config._FilenameSplitter = $incoming.Config._FilenameSplitter
            $this.Config._ListSplitter = $incoming.Config._ListSplitter
            $this.Config._ExportFormat = $incoming.Config._ExportFormat

            # Initialise the ContentModel
            $this.Init()

            # set location of the content source
            $contentSource = $incoming.Content
        }
        else {

            # v1 format
            Write-InfoToConsole "V2 FileType not detected, attempting legacy load using current config ..."

            # Initialise the ContentModel
            $this.Init()

            # set location of the content source
            $contentSource = $incoming

        }

        # For each json object
        foreach ($item in $contentSource) {     
        
            # Show/Update a progress bar
            Write-Progress -Activity "Importing File Index" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $contentSource.count)

            # Call the specific overload of this method
            $addedContent = $this.AddContentToModel($item.FileName, $item.BaseName, $item.Extension)

            # Load properties, where available
            $addedContent.FrameWidth = $item.FrameWidth
            $addedContent.FrameHeight = $item.FrameHeight
            $addedContent.FrameRate = $item.FrameRate
            $addedContent.TimeSpan = [TimeSpan]$item.Duration
            $addedContent.BitRate = $item.BitRate
            $addedContent.Hash = $item.Hash

            # If requested, load properties and generate hash
            if ($collectInfoWhereMissing) {
                $addedContent.FillPropertiesWhereMissing($true)
                $addedContent.GenerateHashIfMissing($true)
            }           

            # track any warnings
            if ($addedContent.Warnings.Count -gt 0) {
                $loadWarnings++
            }

            # Increment the counter
            $i++
        
        }

        # Dispose non GC objects
        if ($disposeWhenDone) {
            [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
        }

        # Remove the progress bar
        Write-Progress -Activity "Importing File Index" -Completed

        # Provide tips to console
        if ($loadWarnings) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Not all content loaded successfully. To identify problematic content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::PartialLoad}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::NonCompliantFilename}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::FileNotFound}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::UnsupportedFileExtension}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::ErrorLoadingProperties}"
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings.Count -gt 0}"
            Remove-ConsoleIndent
        }
    }

    [Void] SaveIndex () {
        $this.SaveIndex(".\Index.json", $false)
    }

    [Void] SaveIndex ([String] $indexFilePath) {
        $this.SaveIndex($indexFilePath, $false)
    }

    [Void] SaveIndex ([Bool] $CollectInfoWhereMissing) {
        $this.SaveIndex(".\Index.json", $CollectInfoWhereMissing)
    }

    [Void] SaveIndex ([String] $indexFilePath, [Bool] $CollectInfoWhereMissing) {
    
        $disposeWhenDone = $null

        Write-InfoToConsole "Validating path" $indexFilePath "..."

        # Instantiate Shell now so it is retained for the life of the method.
        if ($collectInfoWhereMissing) {
            $disposeWhenDone = [FilesystemExtensionsState]::InstantiateShell()
        }

        # First validate the path portion of the filepath
        if (-not(((Split-Path $indexFilePath) -ne "") -and (Split-Path $indexFilePath | Test-Path))) {
            Write-ErrorToConsole "Error: Invalid filepath"
            return
        }

        # if requested, collect any missing information for each content item
        if ($CollectInfoWhereMissing) {

            Write-InfoToConsole "Collecting additional information..."

            for ($i = 0; $i -lt $this.Content.count; $i++) {
            
                Write-Progress -Activity "Collecting additional information" -Status ("Processing Item: " + ($i + 1) + " | " + $this.Content[$i].FileName) -PercentComplete (($i * 100) / $this.Content.count)
            
                $this.Content[$i].FillPropertiesWhereMissing()
                $this.Content[$i].GenerateHashIfMissing()

            }
            Write-Progress -Activity "Collecting additional information" -Completed
        }

        # Dispose non GC objects
        if ($disposeWhenDone) {
            [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
        }
        
        Write-InfoToConsole "Generating json output..."

        # Start building the output format by export a core structure and the config info
        $output = [PSCustomObject]::new()
        $output | Add-Member NoteProperty "FileType" ([CollectionManagementDefaults]::DEFAULT_MODULE_FILETYPE())
        $output | Add-Member NoteProperty "Config" $null 
        $output | Add-Member NoteProperty "Content" $null
        $output.Config = $this.Config | Select-Object ([CollectionManagementDefaults]::DEFAULT_CONFIG_EXPORT_FORMAT())

        # Next recast the content model into an object format more suitable for export
        $output.Content = $this.Content | Select-Object $this.Config.ExportFormat.ForEach([String])

        # convert the object to json and return the result
        $json = $output | ConvertTo-Json

        Write-InfoToConsole "Writing file..."

        # Write the file
        $json | Save-File $indexFilePath
    }

    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement) {
        return [CollectionManagementController]::RemodelFilenameFormat($this, $swapElement, $withElement, $false)
    }

    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::RemodelFilenameFormat($this, $swapElement, $withElement, $updateCorrespondingFilename)
    }

    [Bool] AlterActor ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $false, [FilenameElement]::Actors)
    }

    [Bool] AlterActor ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $updateCorrespondingFilename, [FilenameElement]::Actors)
    }

    [Bool] AlterAlbum ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $false, [FilenameElement]::Album)
    }

    [Bool] AlterAlbum ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $updateCorrespondingFilename, [FilenameElement]::Album)
    }

    [Bool] AlterArtist ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $false, [FilenameElement]::Artists)
    }

    [Bool] AlterArtist ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $updateCorrespondingFilename, [FilenameElement]::Artists)
    }

    [Bool] AlterSeries ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $false, [FilenameElement]::Series)
    }

    [Bool] AlterSeries ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $updateCorrespondingFilename, [FilenameElement]::Series)
    }

    [Bool] AlterStudio ([String] $fromName, [String] $toName) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $false, [FilenameElement]::Studio)
    }

    [Bool] AlterStudio ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::Alter($this, $fromName, $toName, $updateCorrespondingFilename, [FilenameElement]::Studio)
    }

    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern) {
        return [CollectionManagementController]::AlterSeasonEpisodeFormat($this, $padSeason, $padEpisode, $pattern, $false)
    }
    
    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterSeasonEpisodeFormat($this, $padSeason, $padEpisode, $pattern, $updateCorrespondingFilename)
    } 

    [Bool] AlterTrackFormat([Int] $padTrack) {
        return [CollectionManagementController]::AlterTrackFormat($this, $padTrack, $false)
    }

    [Bool] AlterTrackFormat([Int] $padTrack, [Bool] $updateCorrespondingFilename) {
        return [CollectionManagementController]::AlterTrackFormat($this, $padTrack, $updateCorrespondingFilename)
    }

    [Void] ApplyAllPendingFilenameChanges() {
        
        # Get all pending filename Updates
        [System.Collections.Generic.List[Content]] $pendingContent = $this.Content | Where-Object {$_.PendingFilenameUpdate -eq $true}
        
        foreach ($item in $pendingContent) {
            if ($item.UpdateFileName()) {
                Write-InfoToConsole "Filename updated to" $item.FileName
            }
        }
    }

    [Void] Summary() {
        [CollectionManagementController]::ModelSummary($this)
    }

    [Int[]] AnalyseActorsForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Actors, $false)
    }

    [Int[]] AnalyseActorsForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Actors, $returnSummary)
    }

    [Int[]] AnalyseAlbumsForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Albums, $false)
    }

    [Int[]] AnalyseAlbumsForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Albums, $returnSummary)
    }

    [Int[]] AnalyseArtistsForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Artists, $false)
    }

    [Int[]] AnalyseArtistsForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Artists, $returnSummary)
    }

    [Int[]] AnalyseSeriesForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Series, $false)
    }

    [Int[]] AnalyseSeriesForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Series, $returnSummary)
    }

    [Int[]] AnalyseStudiosForPossibleLabellingIssues () {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Studios, $false)
    }

    [Int[]] AnalyseStudiosForPossibleLabellingIssues ([Bool] $returnSummary) {
        return [CollectionManagementController]::AnalysePossibleLabellingIssues($this.Studios, $returnSummary)
    }

    [Void] SpellcheckContentTitles() {
        [CollectionManagementController]::SpellcheckContentTitles($this.Content, $false)
    }

    [Hashtable] SpellcheckContentTitles([Bool] $returnResults) {
        return [CollectionManagementController]::SpellcheckContentTitles($this.Content, $returnResults)
    }

    [Content] AddContentToModel([System.IO.FileInfo] $file) {

        # Call the specific overload of this method
        return $this.AddContentToModel($file.Name, $file.BaseName, $file.Extension)
    }

    [Content] AddContentToModel([String] $filename, [String] $basename, [String] $extension) {

        # if we have a duplicate, just return that
        $duplicate = ($this.Content | Where-Object {$_.Filename -eq $fileName})
        if ($null -ne $duplicate) {
            Write-WarnToConsole "Duplicate detected, returning existing content instead"
            $duplicate.AddWarning([ContentWarning]::DuplicateDetectedInSources)
            return $duplicate[0]
        }
        
        # Otherwise, instantiate a content object
        $newContent = [Content]::new($fileName, $baseName, $extension, $this.Config)
        
        # If there were no errors, load the surrounding model as required
        if ($newContent.Warnings.Count -eq 0) {

            # Split apart the basename                                                                                              
            $splitBaseName = ($baseName -split $this.Config.FilenameSplitter).Trim()
            $actorsSplitIndex = $this.Config.FilenameFormat.IndexOf([FilenameElement]::Actors)
            $artistsSplitIndex = $this.Config.FilenameFormat.IndexOf([FilenameElement]::Artists)
            $studioSplitIndex = $this.Config.FilenameFormat.IndexOf([FilenameElement]::Studio)
            $seriesSplitIndex = $this.Config.FilenameFormat.IndexOf([FilenameElement]::Series)
            $albumSplitIndex = $this.Config.FilenameFormat.IndexOf([FilenameElement]::Album)

            # Create object references
            [Actor]  $actor = $null
            [Album]  $album = $null
            [Artist] $artist = $null
            [Series] $seriesObj = $null
            [Studio] $studio = $null

            # Process Actor information, if part of filename
            if ($actorsSplitIndex -ge 0) {
                $actorNames = ($splitBaseName[$actorsSplitIndex] -split $this.Config.ListSplitter).Trim()

                # for each Actor
                foreach ($actorName in $actorNames) {

                    # Decorate Actors that are actually tags
                    if ($actorName -in $this.Config.DecorateAsTags){
                        $actorName = "<" + $actorName + ">"
                    } 
            
                    # If the Actor name already exists, grab that one, otherwise create a new Actor
                    if ($this.Actors.Count -eq 0) {
                        $isNewActor = $true
                        $actor = [Actor]::new($actorName)
                    }
                    elseif ($actorName -cin $this.Actors.Name) {
                        $isNewActor = $false
                        $actor = $this.Actors.Find({$args[0].Name -ceq $actorName})
                    }
                    else {
                        $isNewActor = $true
                        $actor = [Actor]::new($actorName)
                    }
            
                    # two way link the Actor and content objects
                    $newContent.Actors.Add($actor)
                    $actor.PerformedIn.Add($newContent)
            
                    # add the Actor if new
                    if ($isNewActor) {
                        $this.Actors.Add($actor)
                    }
                }
            }

            # Process Album information, if part of filename
            if ($albumSplitIndex -ge 0) {
                $albumName = $splitBaseName[$albumSplitIndex]

                # Decorate Album that are actually tags
                if ($albumName -in $this.Config.DecorateAsTags){
                    $albumName = "<" + $albumName + ">"
                }
                
                # If the Album name already exists, grab that one, otherwise create a new Album
                if ($this.Albums.Count -eq 0) {
                    $isNewAlbum = $true
                    $album = [Album]::new($albumName, ($studioSplitIndex -ge 0))
                }
                elseif ($albumName -cin $this.Albums.Name) {
                    $isNewAlbum = $false
                    $album = $this.Albums.Find({$args[0].Name -ceq $albumName})
                }
                else {
                    $isNewAlbum = $true
                    $album = [Album]::new($albumName, ($studioSplitIndex -ge 0))
                } 

                # two way link the Album and content objects
                $newContent.OnAlbum = $album
                $album.Tracks.Add($newContent)

                # add the Album if new
                if ($isNewAlbum) {
                    $this.Albums.Add($album)
                }
            }

            # Process Artist information, if part of filename
            if ($artistsSplitIndex -ge 0) {
                $artistNames = ($splitBaseName[$artistsSplitIndex] -split $this.Config.ListSplitter).Trim()

                 # for each Artist
                foreach ($artistName in $artistNames) {

                    # Decorate Artists that are actually tags
                    if ($artistName -in $this.Config.DecorateAsTags){
                        $artistName = "<" + $artistName + ">"
                    } 
            
                    # If the Artist name already exists, grab that one, otherwise create a new Artist
                    if ($this.Artists.Count -eq 0) {
                        $isNewArtist = $true
                        $artist = [Artist]::new($artistName)
                    }
                    elseif ($artistName -cin $this.Artists.Name) {
                        $isNewArtist = $false
                        $artist = $this.Artists.Find({$args[0].Name -ceq $artistName})
                    }
                    else {
                        $isNewArtist = $true
                        $artist = [Artist]::new($artistName)
                    }
            
                    # two way link the Artist and content objects
                    $newContent.Artists.Add($artist)
                    $artist.Performed.Add($newContent)
            
                    # add the Artist if new
                    if ($isNewArtist) {
                        $this.Artists.Add($artist)
                    }
                }
            }

            # Process Series information, if part of filename
            if ($seriesSplitIndex -ge 0) {
                
                $seriesName = $splitBaseName[$seriesSplitIndex]

                # Decorate Series that are actually tags
                if ($seriesName -in $this.Config.DecorateAsTags){
                    $seriesName = "<" + $seriesName + ">"
                }
                
                # If the Series name already exists, grab that one, otherwise create a new Series
                if ($this.Series.Count -eq 0) {
                    $isNewSeries = $true
                    $seriesObj = [Series]::new($seriesName, ($studioSplitIndex -ge 0))
                }
                elseif ($seriesName -cin $this.Series.Name) {
                    $isNewSeries = $false
                    $seriesObj = $this.Series.Find({$args[0].Name -ceq $seriesName})
                }
                else {
                    $isNewSeries = $true
                    $seriesObj = [Series]::new($seriesName, ($studioSplitIndex -ge 0))
                } 

                # two way link the Series and content objects
                $newContent.FromSeries = $seriesObj
                $seriesObj.Episodes.Add($newContent)

                # add the Series if new
                if ($isNewSeries) {
                    $this.Series.Add($seriesObj)
                }
            }

            # Process Studio information, if part of filename
            if ($studioSplitIndex -ge 0) {
                $studioName = $splitBaseName[$studioSplitIndex]

                # Decorate Studios that are actually tags
                if ($studioName -in $this.Config.DecorateAsTags){
                    $studioName = "<" + $studioName + ">"
                }
                
                # If the Studio name already exists, grab that one, otherwise create a new Studio
                if ($this.Studios.Count -eq 0) {
                    $isNewStudio = $true
                    $studio = [Studio]::new($studioName, ($albumSplitIndex -ge 0), ($seriesSplitIndex -ge 0))
                }
                elseif ($studioName -cin $this.Studios.Name) {
                    $isNewStudio = $false
                    $studio = $this.Studios.Find({$args[0].Name -ceq $studioName})
                }
                else {
                    $isNewStudio = $true
                    $studio = [Studio]::new($studioName, ($albumSplitIndex -ge 0), ($seriesSplitIndex -ge 0))
                } 

                # two way link the Studio and content objects
                $newContent.ProducedBy = $studio
                $studio.Produced.Add($newContent)

                # add the Studio if new
                if ($isNewStudio) {
                    $this.Studios.Add($studio)
                }
            }

            # Process Album-Studio cross relationship, if both are part of filename, and both have been identified
            if (($albumSplitIndex -ge 0) -and ($studioSplitIndex -ge 0) -and ($null -ne $album) -and ($null -ne $studio)) {
                
                # two way link the Album and studio if not already known
                if ($studio.Name -cnotin $album.ProducedBy.Name) {
                    $album.ProducedBy.Add($studio)
                }

                if ($album.Name -cnotin $studio.ProducedAlbums.Name) {
                    $studio.ProducedAlbums.Add($album)
                }

                # If the series ever gets a second producers
                if ($album.ProducedBy.Count -eq 2) {
                    Write-WarnToConsole "Duplicate Producers detected for album $($album.Name)."
                } 
            }

            # Process Series-Studio cross relationship, if bot hare part of filename
            if (($seriesSplitIndex -ge 0) -and ($studioSplitIndex -ge 0) -and ($null -ne $seriesObj) -and ($null -ne $studio)) {
                
                # two way link the Album and studio if not already known
                if ($studio.Name -cnotin $seriesObj.ProducedBy.Name) {
                    $seriesObj.ProducedBy.Add($studio)
                }

                if ($seriesObj.Name -cnotin $studio.ProducedSeries.Name) {
                    $studio.ProducedSeries.Add($seriesObj)
                }

                 # If the series ever gets a second producers
                 if ($seriesObj.ProducedBy.Count -eq 2) {
                    Write-WarnToConsole "Duplicate Producers detected for series $($seriesObj.Name)."
                } 
            }
        }

        # add the content
        $this.Content.Add($newContent)

        # Return
        return $newContent
    }

    [Void] RemoveContentFromModel([String] $filename) {
    
        # Get the item to be deleted
        $oldContent = ($this.Content | Where-Object {$_.FileName -eq $filename})

        # If actors are part of the model
        if ($null -ne $oldContent.Actors) {

            # For each actor linked to the content
            foreach ($actor in $oldContent.Actors) {

                # Delete the reference back to the content to be deleted
                $actor.PerformedIn.Remove($oldContent)

                # If no references remain, delete the actor too
                if ($actor.PerformedIn.Count -eq 0) {
                    $this.Actors.Remove($actor)
                }
            }
        }

        # If album is part of the model
        if ($null -ne $oldContent.OnAlbum) {

            # For the album linked to the content
            $album = $oldContent.OnAlbum

            # Delete the reference back to the content to be deleted
            $album.Track.Remove($oldContent)

            # If no references remain, delete the album too
            if ($album.Track.Count -eq 0) {
                $this.Album.Remove($album)

                # And if part of the model, remove the cross reference from the studio
                if ($null -ne $oldContent.ProducedBy) {
                    $oldContent.ProducedBy.ProducedAlbum.Remove($album)
                }
            }
        }

         # If artists are part of the model
         if ($null -ne $oldContent.Artists) {

            # For each artist linked to the content
            foreach ($artist in $oldContent.Artists) {

                # Delete the reference back to the content to be deleted
                $artist.PerformedIn.Remove($oldContent)

                # If no references remain, delete the artist too
                if ($artist.Performed.Count -eq 0) {
                    $this.Artists.Remove($artist)
                }
            }
        }

        # If series is part of the model
        if ($null -ne $oldContent.FromSeries) {

            # For the series linked to the content
            $seriesObj = $oldContent.FromSeries

            # Delete the reference back to the content to be deleted
            $seriesObj.Episodes.Remove($oldContent)

            # If no references remain, delete the series too
            if ($seriesObj.Track.Count -eq 0) {
                $this.Series.Remove($seriesObj)

                # And if part of the model, remove the cross reference from the studio
                if ($null -ne $oldContent.ProducedBy) {
                    $oldContent.ProducedBy.ProducedSeries.Remove($seriesObj)
                }
            }
        }

        # If studio is part of the model
        if ($null -ne $oldContent.ProducedBy) {

            # For the studio linked to the content
            $studio = $oldContent.ProducedBy

            # Delete the reference back to the content to be deleted
            $studio.Produced.Remove($oldContent)

            # If no references remain, delete the studio too
            if ($studio.Produced.Count -eq 0) {
                $this.Studios.Remove($studio)

                # And if part of the model, remove the cross reference from the album
                if ($null -ne $oldContent.OnAlbum) {
                    $oldContent.OnAlbum.ProducedBy.Remove($studio)
                }

                # And if part of the model, remove the cross reference from the series
                if ($null -ne $oldContent.FromSeries) {
                    $oldContent.FromSeries.ProducedBy.Remove($studio)
                }
            }
        }

        # Delete the content item itself
        $this.Content.Remove($oldContent)

    }
    #endregion Public Methods
}
#endregion Class Definition