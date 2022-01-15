#region Header
#
# About: Handlers Layer Class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\Interfaces\IModelManipulationHandler.Interface.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\Interfaces\IContentSubjectBO.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\Album.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\Series.Class.psm1
using module .\..\ObjectModels\Studio.Class.psm1
using module .\..\ObjectModels\ContentComparer.Class.psm1
using module .\..\BusinessObjects\ContentBO.Class.psm1
using module .\..\BusinessObjects\ActorBO.Class.psm1
using module .\..\BusinessObjects\AlbumBO.Class.psm1
using module .\..\BusinessObjects\ArtistBO.Class.psm1
using module .\..\BusinessObjects\SeriesBO.Class.psm1
using module .\..\BusinessObjects\StudioBO.Class.psm1
#endregion Using


#region Class Definition
#-----------------------
class ModelManipulationHandler : IModelManipulationHandler {

    #region Properties
    [IContentModel] $ContentModel
    #endregion Properties


    #region Constructors
    ModelManipulationHandler () {
        $this.ContentModel = $null
    }
    
    ModelManipulationHandler ([IContentModel] $contentModel) {
        $this.ContentModel = $contentModel
    }
    #endregion Constructors
    
    
    #region Implemented Methods
    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { 
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)
        
        if (-not $this.ContentModel.Config.RemodelFilenameFormat($swapElement, $withElement)) {
            return $false
        }

        foreach ($content in $this.ContentModel.Content) {
            $contentBO.UpdateContentBaseName($content)
        }

        if ($updateCorrespondingFilename) {
            $this.ApplyAllPendingFilenameChanges() 
        }

        return $true
    }

    [Void] ApplyAllPendingFilenameChanges() {
    
        # Get all pending filename Updates
        [System.Collections.Generic.List[Content]] $pendingContent = $this.ContentModel.Content | Where-Object {$_.PendingFilenameUpdate -eq $true}
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)

        foreach ($item in $pendingContent) {
            if ($ContentBO.UpdateFileName($item)) {
                Write-InfoToConsole "Filename updated to" $item.FileName
            }
        }
    }

    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) {

        # Set starting state
        [Int] $alterations = 0
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)

        # For each content item
        foreach ($contentItem in $this.ContentModel.Content) {

            # Generate what the format should look like
            [String] $generatedElement = $contentBO.SeasonEpisodeToString($contentItem.season, $contentItem.episode, $padSeason, $padEpisode, $pattern)
            
            # If not null and the generated is different, update the SeasonEpisode and Basename
            if ($null -eq $generatedElement) {
                Write-WarnToConsole "Unexpected result while generating SeasonEpisode, skipping element."
            }
            elseif (($generatedElement -cne $contentItem.SeasonEpisode) -and ($null -ne $contentItem.Season) -and ($null -ne $contentItem.Episode)) {
                
                Write-InfoToConsole "Altering BaseName" $contentItem.BaseName

                $contentItem.SeasonEpisode = $generatedElement
                $contentBO.UpdateContentBaseName($contentItem)
                $alterations++

                Write-InfoToConsole "               to" $contentItem.BaseName
            }
            else {
                # Do nothing
            }

            # if the switch is set, also update the filename on the filesystem
            if ($updateCorrespondingFilename.IsPresent) {
                if ($contentItem.UpdateFileName()) {
                    Write-InfoToConsole "Filename updated to" $contentItem.FileName
                }
            }
        }

        # Provide tips to console
        if ($alterations) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Some content has changed BaseName since it was first loaded. To identify this content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.AlteredBaseName -eq `$true}"
            Remove-ConsoleIndent
        }
        if ($alterations -and -not $updateCorrespondingFilename) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Some content has pending Filename updates. To identify this content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.PendingFilenameUpdate -eq `$true}"
            Remove-ConsoleIndent
        }

        return $true
    } 

    [Bool] AlterTrackFormat([Int] $padtrack, [Bool] $updateCorrespondingFilename) { 
         
        # Set starting state
        [Int] $alterations = 0
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)

        # For each content item
        foreach ($contentItem in $this.ContentModel.Content) {
 
            # Generate what the format should look like
            [String] $generatedElement = $contentBO.TrackToString($contentItem.track, $padtrack)
            
            # If not null and the generated is different, update the Track and Basename
            if ($null -eq $generatedElement) {
                Write-WarnToConsole "Unexpected result while generating SeasonEpisode, skipping element."
            }
            elseif (($generatedElement -ne $contentItem.TrackLabel) -and ($null -ne $contentItem.Track)) {
                
                Write-InfoToConsole "Altering BaseName" $contentItem.BaseName

                $contentItem.TrackLabel = $generatedElement
                $contentBO.UpdateContentBaseName($contentItem)
                $alterations++

                Write-InfoToConsole "               to" $contentItem.BaseName
            }
            else {
                # Do nothing
            }

            # if the switch is set, also update the filename on the filesystem
            if ($updateCorrespondingFilename.IsPresent) {
                if ($contentItem.UpdateFileName()) {
                    Write-InfoToConsole "Filename updated to" $contentItem.FileName
                }
            }
        }

        # Provide tips to console
        if ($alterations) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Some content has changed BaseName since it was first loaded. To identify this content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.AlteredBaseName -eq `$true}"
            Remove-ConsoleIndent
        }
        if ($alterations -and -not $updateCorrespondingFilename) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Some content has pending Filename updates. To identify this content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.PendingFilenameUpdate -eq `$true}"
            Remove-ConsoleIndent
        }

        return $true
    }

    [Bool] AlterSubject ([IContentSubjectBO] $contentSubjectBO, [System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename) {

        if (-not $this.IsValidForAlter($contentSubjectBO, $subjectList, $fromName, $toName)) {
            return $false
        }

        # Set starting state
        [Int]    $alterations = 0
        [Object] $fromObject = $subjectList.GetByName($fromName)
        [Object] $toObject = $subjectList.GetByName($toName)
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)

        # if there is no toObject, then we can just renamne the fromObject
        if ($null -eq $toObject) { 
            Write-InfoToConsole "Altering" $fromObject.Name "to" $toName
            $fromObject.Name = $toName
        }
        else {
            Write-InfoToConsole "Migrating content from" $fromObject.Name "to" $toObject.Name
        }

        # process each content item connected to the fromObject
        foreach ($fromObjectContentItem in $fromObject.GetRelatedContent()) {
        
            Write-InfoToConsole "  Altering BaseName" $fromObjectContentItem.BaseName

            # if there is a toObject, then migrate content and relationships 
            if ($null -ne $toObject) {
                $contentSubjectBO.ReplaceSubjectLinkedToContent($fromObjectContentItem, $fromObject, $toObject) 
            }

            # Update the basename and filename in the model
            $contentBO.UpdateContentBaseName($fromObjectContentItem)
            Write-InfoToConsole "                 to" $fromObjectContentItem.BaseName

            # if the switch is set, also update the filename on the filesystem
            if ($updateCorrespondingFilename) {
                if ($fromObjectContentItem.UpdateFileName()) {
                    Write-InfoToConsole "Filename updated to" $fromObjectContentItem.FileName
                }
            }

            $alterations++
        }

        # if there is a toObject, then we delete the fromObject
        if ($null -ne $toObject) {
            Write-InfoToConsole "Deleting" $fromObject.Name
            $subjectList.Remove($fromObject)
        }

        $this.IfRequiredProvideConsoleTipsForAlter($alterations, $updateCorrespondingFilename)
        
        return $true
    }

    [Content] AddContentToModel([String] $filename, [String] $basename, [String] $extension, [Object] $indexInfoIfAvailable) {

        # if we have a duplicate, just return that
        $duplicate = ($this.ContentModel.Content | Where-Object {$_.Filename -eq $fileName})
        if ($null -ne $duplicate) {
            Write-WarnToConsole "Duplicate detected, returning existing content instead"
            $duplicate.AddWarning([ContentWarning]::DuplicateDetectedInSources)
            return $duplicate[0]
        }
        
        # Otherwise, instantiate a content object        
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)
        $newContent = $contentBO.CreateContentObject($filename, $basename, $extension)

        # If there were no errors, load the surrounding model as required
        if ($newContent.Warnings.Count -eq 0) {

            # Split apart the basename                                                                                              
            $splitBaseName = ($baseName -split $this.ContentModel.Config.FilenameSplitter).Trim()

            # Pre-define object references, so we can generate cross links if they are created
            [Album]  $album = $null
            [Series] $seriesObj = $null
            [Studio] $studio = $null

            # Process Actor information, if part of filename
            if ($contentBO.Config.IncludeActors) {

                $actorNames = ($splitBaseName[$contentBO.Config.ActorsSplitIndex] -split $contentBO.Config.ListSplitter).Trim()
                [ActorBO] $actorBO = [ActorBO]::new($contentBO.Config)
                $actorBO.AddActorRelationshipsWithContent($newContent, $this.ContentModel.Actors, $actorNames)
            }

            # Process Album information, if part of filename
            if ($contentBO.Config.IncludeAlbums) {

                $albumName = $splitBaseName[$contentBO.Config.AlbumSplitIndex]
                [AlbumBO] $albumBO = [AlbumBO]::new($contentBO.Config)
                $album = $albumBO.AddAlbumRelationshipsWithContent($newContent, $this.ContentModel.Albums, $albumName)

            }

            # Process Artist information, if part of filename
            if ($contentBO.Config.IncludeArtists) {
                
                $artistNames = ($splitBaseName[$contentBO.Config.ArtistsSplitIndex] -split $contentBO.Config.ListSplitter).Trim()
                [ArtistBO] $artistBO = [ArtistBO]::new($contentBO.Config)
                $artistBO.AddArtistRelationshipsWithContent($newContent, $this.ContentModel.Artists, $artistNames)

            }

            # Process Series information, if part of filename
            if ($contentBO.Config.IncludeSeries) {     

                $seriesName = $splitBaseName[$contentBO.Config.SeriesSplitIndex]
                [SeriesBO] $seriesBO = [SeriesBO]::new($contentBO.Config)
                $seriesObj = $seriesBO.AddSeriesRelationshipsWithContent($newContent, $this.ContentModel.Series, $seriesName)

            }

            # Process Studio information, if part of filename
            if ($contentBO.Config.IncludeStudios) {

                $studioName = $splitBaseName[$contentBO.Config.StudioSplitIndex]
                [StudioBO] $studioBO = [StudioBO]::new($contentBO.Config)
                $studio = $studioBO.AddStudioRelationshipsWithContent($newContent, $this.ContentModel.Studios, $studioName)

            }

            # Process Album-Studio cross relationship, if both are part of filename
            if ($contentBO.Config.IncludeAlbums -and $contentBO.Config.IncludeStudios -and ($null -ne $album) -and ($null -ne $studio)) {
                
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

            # Process Series-Studio cross relationship, if both hare part of filename
            if ($contentBO.Config.IncludeSeries -and $contentBO.Config.IncludeStudios-and ($null -ne $seriesObj) -and ($null -ne $studio)) {
                
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

        if ($null -ne $indexInfoIfAvailable) {

            # Load properties, where available
            $newContent.FrameWidth = $indexInfoIfAvailable.FrameWidth
            $newContent.FrameHeight = $indexInfoIfAvailable.FrameHeight
            $newContent.FrameRate = $indexInfoIfAvailable.FrameRate
            try { $newContent.TimeSpan = [TimeSpan]$indexInfoIfAvailable.Duration } catch { $newContent = $null }
            $newContent.BitRate = $indexInfoIfAvailable.BitRate
            $newContent.Hash = $indexInfoIfAvailable.Hash
        }

        # add the content
        $contentBO.AddContentToModel($this.ContentModel.Content, $newContent)

        return $newContent
    }

    [Void] Build([Bool] $loadProperties, [Bool] $generateHash) {

        # Initialise
        $i = 0
        $disposeWhenDone = $false
        
        # Initialise the ContentModel then the BO
        $this.ContentModel.Init()
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)

        # read the filesystem
        [Object[]] $files = $contentBO.GetFilesForModel()

        # Instantiate Shell now so it is retained for the life of the method.
        if ($loadProperties) {
            $disposeWhenDone = $contentBO.InstantiatePersistantFilesystemShellIfNotPresent()
        }

        # for each file
        foreach ($file in $files) {    
        
            # Show a progress bar
            Write-Progress -Activity "Generating Model" -Status ("Processing Item: " + ($i + 1) + " | " + $file.Name) -PercentComplete (($i * 100) / $files.count)

            # Add the file
            [Content] $content = $this.AddContentToModel($file.Name, $file.Basename, $file.Extension, $null)

            # If requested, load properties
            if ($loadProperties) {
                $contentBO.FillPropertiesWhereMissing($content, $file, $true)
            }

            # If requested, generate a hash
            if ($generateHash) {
                $contentBO.GenerateHashIfMissing($content, $file, $true)
            }

            # Increment the counter
            $i++  
        }

        Write-Progress -Activity "Generating Model" -Completed

        # Dispose non GC objects
        if ($disposeWhenDone) {
            $contentBO.DisposePersistantFilesystemShellIfPresent()
        }

        $this.IfRequiredProvideConsoleTipsForLoadWarnings()

    }

    [Void] Rebuild([Bool] $loadProperties, [Bool] $generateHash) {

        # Initialise
        $i = 0
        $disposeWhenDone = $false
        [System.Collections.Generic.List[Object]] $ToAdd  = [System.Collections.Generic.List[Object]]::new()
        [System.Collections.Generic.List[Object]] $ToRemove  = [System.Collections.Generic.List[Object]]::new()
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)

        # Get the current list of files
        [Object[]] $files = $contentBO.GetFilesForModel()

        # Instantiate Shell now so it is retained for the life of the method.
        if ($loadProperties) {
            $disposeWhenDone = $contentBO.InstantiatePersistantFilesystemShellIfNotPresent()
        }

        # Pre-process
        Write-InfoToConsole "Indexing changes ..."
        foreach ($file in $files) {
            if (-not $this.ContentModel.Content.FileName.Contains($file.Name)) {
                $ToAdd.Add($file)
            }
        }

        foreach ($content in $this.ContentModel.Content) {
            if (-not $files.Name.Contains($content.FileName)) {
                $ToRemove.Add($content)
            }
        }

        # Calc total iterations
        $totalProcessingIterationCount = $ToRemove.Count + (($this.ContentModel.Content.Count - $ToRemove.Count) * ($loadProperties -or $generateHash)) + $ToAdd.Count

        # Process removals
        foreach ($content in $ToRemove) {

            Write-Progress -Activity "Rebuilding model" -Status ("Removing Item: " + ($i + 1) + " | " + $content.FileName) -PercentComplete (($i * 100) / $totalProcessingIterationCount)

            Write-ToConsole -ForegroundColor Magenta "Removing: " $content.FileName
            $this.RemoveContentFromModel($content.FileName)

            $i++
        }

        # If requested, populate missing properties 
        if ($loadProperties -or $generateHash) {

            # initialise progress
            Write-InfoToConsole "Populating missing properties on existing ..."
            $i = 0

            foreach ($content in $this.ContentModel.Content) {

                Write-Progress -Activity "Rebuilding model" -Status ("Re-processing Item: " + ($i + 1) + " | " + $content.FileName) -PercentComplete (($i * 100) / $totalProcessingIterationCount)

                $file = $files | Where-Object {$_.Name -eq $content.FileName}

                # If requested, load properties
                if ($loadProperties) {
                    $contentBO.FillPropertiesWhereMissing($content, $file, $true)
                }

                # If requested, generate a hash
                if ($generateHash) {
                    $contentBO.GenerateHashIfMissing($content, $file, $true)
                }

                # Increment the counter
                $i++
            }
        }

        # Process the additions
        foreach ($file in $ToAdd) {
        
            Write-Progress -Activity "Rebuilding model" -Status ("Adding Item: " + ($i + 1) + " | " + $file.Name) -PercentComplete (($i * 100) / $totalProcessingIterationCount)
            
            Write-ToConsole -ForegroundColor Cyan "Adding:   " $file.Name
            [Content] $content = $this.AddContentToModel($file.Name, $file.Basename, $file.Extension, $null)

            # If requested, load properties
            if ($loadProperties) {
                $contentBO.FillPropertiesWhereMissing($content, $file, $true)
            }

            # If requested, generate a hash
            if ($generateHash) {
                $contentBO.GenerateHashIfMissing($content, $file, $true)
            }

            $i++
        }

        Write-Progress -Activity "Rebuilding model" -Completed

        # Dispose non GC objects
        if ($disposeWhenDone) {
            $contentBO.DisposePersistantFilesystemShellIfPresent()
        }

        # Resort the list
        Write-InfoToConsole "Resorting the list"
        $comp = [ContentComparer]::new("FileName")
        $this.ContentModel.Content.Sort($comp)

        $this.IfRequiredProvideConsoleTipsForLoadWarnings()

    }

    [Void] Load([System.Array] $infoFromIndexFile, [Bool] $loadProperties, [Bool] $generateHash) {

        # Initialise
        $i = 0
        $disposeWhenDone = $null
        $this.ContentModel.Init()
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)
        
        # Get the current list of files
        [Object[]] $files = $contentBO.GetFilesForModel()

        # Instantiate Shell now so it is retained for the life of the method.
        if ($loadProperties) {
            $disposeWhenDone = $contentBO.InstantiatePersistantFilesystemShellIfNotPresent()
        }

        # For each json object
        foreach ($indexInfo in $infoFromIndexFile) {     
        
            # Show/Update a progress bar
            Write-Progress -Activity "Importing File Index" -Status ("Processing Item: " + ($i + 1) + " | " + $indexInfo.FileName) -PercentComplete (($i * 100) / $infoFromIndexFile.count)

            # Load the content 
            [Content] $content = $this.AddContentToModel($indexInfo.Filename, $indexInfo.Basename, $indexInfo.Extension, $indexInfo)

            $file = $files | Where-Object {$_.Name -eq $content.FileName}

            # If requested, load properties
            if ($loadProperties) {
                $contentBO.FillPropertiesWhereMissing($content, $file, $true)
            }

            # If requested, generate a hash
            if ($generateHash) {
                $contentBO.GenerateHashIfMissing($content, $file, $true)
            }

            # Increment the counter
            $i++
        
        }

        # Dispose non GC objects
        if ($disposeWhenDone) {
            $contentBO.DisposePersistantFilesystemShellIfPresent()
        }

        # Remove the progress bar
        Write-Progress -Activity "Importing File Index" -Completed

        # Provide tips to console
        $this.IfRequiredProvideConsoleTipsForLoadWarnings()
    }

    [Void] FillPropertiesAndHashWhereMissing ([Bool] $loadProperties, [Bool] $generateHash) {

        # Get the current list of files
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)
        [Object[]] $files = $contentBO.GetFilesForModel()
        [Bool] $disposeWhenDone = $contentBO.InstantiatePersistantFilesystemShellIfNotPresent()

         # initialise progress
         Write-InfoToConsole "Collecting Additional information ..."
         $i = 0

         foreach ($content in $this.ContentModel.Content) {

             Write-Progress -Activity "Collecting addtitional info" -Status ("Re-processing Item: " + ($i + 1) + " | " + $content.FileName) -PercentComplete (($i * 100) / $this.ContentModel.Content.Count)

             $file = $files | Where-Object {$_.Name -eq $content.FileName}

             # If requested, load properties
             if ($loadProperties) {
                 $contentBO.FillPropertiesWhereMissing($content, $file, $true)
             }

             # If requested, generate a hash
             if ($generateHash) {
                 $contentBO.GenerateHashIfMissing($content, $file, $true)
             }

             # Increment the counter
             $i++
         }

         # Dispose non GC objects
        if ($disposeWhenDone) {
            $contentBO.DisposePersistantFilesystemShellIfPresent()
        }
    }

    [Void] RemoveContentFromModel([String] $filename) {
    
        # Get the item to be deleted
        $contentToRemove = $this.ContentModel.Content.GetByFileName($filename)

        if ($null -eq $contentToRemove) {
            Write-WarnToConsole "No content with that filename exists in the model, abandoning action."
            return
        }

        # If actors are part of the model
        if ($null -ne $contentToRemove.Actors) {

            [ActorBO] $actorBO = [ActorBO]::new($this.ContentModel.Config)
            $actorBO.RemoveActorRelationshipsWithContentAndCleanup($this.ContentModel.Actors, $contentToRemove)
        }

        # If album is part of the model
        if ($null -ne $contentToRemove.OnAlbum) {

            [AlbumBO] $albumBO = [AlbumBO]::new($this.ContentModel.Config)
            $albumBO.RemoveAlbumRelationshipsWithContentAndCleanup($this.ContentModel.Albums, $contentToRemove)
        }

         # If artists are part of the model
         if ($null -ne $contentToRemove.Artists) {

            [ArtistBO] $artistBO = [ArtistBO]::new($this.ContentModel.Config)
            $artistBO.RemoveArtistRelationshipsWithContentAndCleanup($this.ContentModel.Artists, $contentToRemove)
        }

        # If series is part of the model
        if ($null -ne $contentToRemove.FromSeries) {

            [SeriesBO] $seriesBO = [SeriesBO]::new($this.ContentModel.Config)
            $seriesBO.RemoveSeriesRelationshipsWithContentAndCleanup($this.ContentModel.Series, $contentToRemove)
        }

        # If studio is part of the model
        if ($null -ne $contentToRemove.ProducedBy) {

            [StudioBO] $studioBO = [StudioBO]::new($this.ContentModel.Config)
            $studioBO.RemoveStudioRelationshipsWithContentAndCleanup($this.ContentModel.Studios, $contentToRemove)
        }

        # Delete the content item itself
        [ContentBO] $contentBO = [ContentBO]::new($this.ContentModel.Config)
        $contentBO.RemoveContentFromModel($this.ContentModel.Content, $contentToRemove)
    }
    
    #endregion Implemented Methods

    #region Internal Methods
    [Bool] WillAlterResultInContentCollision([Content] $alterContent, [FilenameElement] $filenameElement, [String] $fromName, [String] $toName) {

        # determine the end state filename
        $splitBaseName = ($alterContent.BaseName -split $this.ContentModel.Config.FilenameSplitter).Trim()
        $subjectSplitIndex = $this.ContentModel.Config.FilenameFormat.IndexOf($filenameElement)
        $splitBaseName[$subjectSplitIndex] = $splitBaseName[$subjectSplitIndex].Replace($fromName, $toName)
        $plannedFileName = ($splitBaseName -join $this.ContentModel.Config.FilenameSplitter) + $alterContent.Extension

        # return true if it already exists
        $collision = $this.ContentModel.Content.GetByFileName($plannedFileName)
        if ($null -ne $collision) {
            return $true
        }
        return $false
    }

    [Bool] IsValidForAlter ([IContentSubjectBO] $contentSubjectBO, [System.Collections.Generic.List[ContentSubjectBase]] $subjectList, [String] $fromName, [String] $toName) {
        
        if ($null -eq $contentSubjectBO) {
            Write-WarnToConsole "No business object dependency set, abandoning action."
            return $false
        }

        $filenameElement = $contentSubjectBO.ActsOnFilenameElement()

        if ($fromName -ceq $toName) {
            Write-WarnToConsole "Names match, adandoning action."
            return $false
        }
        
        if ($null -eq $subjectList) {
            Write-WarnToConsole "$filenameElement is not initialised on this ContentModel, adandoning action."
            return $false
        }

        $fromObject = $subjectList.GetByName($fromName)
        
        if ($null -eq $fromObject) {
            Write-WarnToConsole "No item found, adandoning action."
            return $false
        }

        if ($fromObject.GetType() -ne $contentSubjectBO.ActsOnType()) {
            Write-WarnToConsole "The injected business object cannot act on this type, abandoning action."
            return $false
        }
        
        foreach ($fromObjectContentItem in $fromObject.GetRelatedContent()) {
            if ($this.WillAlterResultInContentCollision($fromObjectContentItem, $filenameElement, $fromName, $toName)) {
                Write-WarnToConsole "This alteratinon will cause a collision with content already in the model, abandoning action."
                return $false
            }
        }
        
        return $true
    }

    [Void] IfRequiredProvideConsoleTipsForAlter([Bool] $alterations, [Bool] $updateCorrespondingFilename) {

        # Provide tips to console
        if ($alterations) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Some content has changed BaseName since it was first loaded. To identify this content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.AlteredBaseName -eq `$true}"
            Remove-ConsoleIndent
        }
        if ($alterations -and -not $updateCorrespondingFilename) {
            Write-InfoToConsole ""
            Write-InfoToConsole "Some content has pending Filename updates. To identify this content, try:"
            Add-ConsoleIndent
            Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.PendingFilenameUpdate -eq `$true}"
            Remove-ConsoleIndent
        }
    }

    [Void] IfRequiredProvideConsoleTipsForLoadWarnings() {

        # Provide tips to console
        if ($this.ContentModel.Content.Warnings.Count -gt 0) {
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
    
    [System.Array] GetFilesForModel () {
        # read the filesystem
        if ($this.ContentModel.Config.IncludedExtensions.Count -eq 0) {
            return Get-ChildItem -File
        }
        else {
            return Get-ChildItem -File | Where-Object {$_.Extension -in $this.ContentModel.Config.IncludedExtensions} 
        }
    }
    #endregion Internal Methods
}
#endregion Class Definition