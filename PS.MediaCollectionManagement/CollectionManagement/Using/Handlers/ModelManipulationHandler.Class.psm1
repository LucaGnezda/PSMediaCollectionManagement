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
using module .\..\Helpers\ContentSubjectParser.Abstract.psm1
using module .\..\ObjectModels\Actor.Class.psm1
using module .\..\ObjectModels\Album.Class.psm1
using module .\..\ObjectModels\Artist.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\Series.Class.psm1
using module .\..\ObjectModels\Studio.Class.psm1
#using module .\..\ObjectModels\ContentModel.Class.psm1
#endregion Using


#region Class Definition
#-----------------------
class ModelManipulationHandler : IModelManipulationHandler {

    #region Properties
    [IContentModel] $ContentModel
    #endregion Properties


    #region Constructors
    ModelManipulationHandler ([IContentModel] $contentModel) {
        $this.ContentModel = $contentModel
    }
    #endregion Constructors
    
    
    #region Methods
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

    [Void] ReplaceActorLinkedWithContent([Content] $content, [Actor] $replaceActor, [Actor] $withActor) {
        
        for ($i = 0; $i -lt $content.Actors.Count; $i++) {
            if ($content.Actors[$i] -eq $replaceActor) {
                $content.Actors[$i] = $withActor
            }
        }
        $withActor.PerformedIn.Add($content)
        break
    }

    [Void] ReplaceArtistLinkedWithContent([Content] $content, [Artist] $replaceArtist, [Artist] $withArtist) {
        
        for ($i = 0; $i -lt $content.Artists.Count; $i++) {
            if ($content.Artists[$i] -eq $replaceArtist) {
                $content.Artists[$i] = $withArtist
            }
        }
        $withArtist.Performed.Add($content)
        break
    }

    [Void] ReplaceAlbumLinkedWithContent([Content] $content, [Artist] $withAlbum) {

        $content.OnAlbum = $withAlbum
        $withAlbum.Tracks.Add($content)
    }

    [Void] ReplaceAlbumLinkedWithContent([Content] $content, [Album] $withAlbum) {

        $content.OnAlbum = $withAlbum
        $withAlbum.Tracks.Add($content)
    }

    [Void] ReplaceSeriesLinkedWithContent([Content] $content, [Series] $withSeries) {

        $content.FromSeries = $withSeries
        $withSeries.Episodes.Add($content)
    }

    [Void] ReplaceStudioLinkedWithContent([Content] $content, [Studio] $withStudio) {
        
        $content.ProducedBy = $withStudio
        $withStudio.Produced.Add($content)
    }

    [Void] ModifyCrossLinksBetweenAlbumAndStudio([Album] $fromAlbum, [Album] $toAlbum) {
        foreach ($studio in $fromAlbum.ProducedBy) {
            for ($i = 0; $i -lt $studio.ProducedAlbums.Count; $i++) {
                if ($studio.ProducedAlbums[$i] -eq $fromAlbum) {

                    if ($toAlbum -in $studio.ProducedAlbums) {
                        $studio.ProducedAlbums.Remove($fromAlbum)
                    }
                    else {
                        $studio.ProducedAlbums[$i] = $toAlbum
                    }
                    
                    if ($studio -notin $toAlbum.ProducedBy) {
                        $toAlbum.ProducedBy.Add($studio)
                    }
                }
            }
        } 
    }

    [Void] ModifyCrossLinksBetweenAlbumAndStudio([Studio] $fromStudio, [Studio] $toStudio) {
        foreach ($album in $fromStudio.ProducedAlbums) {
            for ($i = 0; $i -lt $album.ProducedBy.Count; $i++) {
                if ($album.ProducedBy[$i] -eq $fromStudio) {
                    
                    if ($toStudio -in $album.ProducedBy) {
                        $album.ProducedBy.Remove($fromStudio)
                    }
                    else {
                        $album.ProducedBy[$i] = $toStudio
                    }

                    if ($album -notin $toStudio.ProducedAlbums) {
                        $toStudio.ProducedAlbums.Add($album)
                    }
                }
            }
        } 
    }
    
    [Void] ModifyCrossLinksBetweenSeriesAndStudio([Series] $fromSeries, [Series] $toSeries) {
        foreach ($studio in $fromSeries.ProducedBy) {
            for ($i = 0; $i -lt $studio.ProducedSeries.Count; $i++) {
                if ($studio.ProducedSeries[$i] -eq $fromSeries) {

                    if ($toSeries -in $studio.ProducedSeries) {
                        $studio.ProducedSeries.Remove($fromSeries)
                    }
                    else {
                        $studio.ProducedSeries[$i] = $toSeries
                    }
                    
                    if ($studio -notin $toSeries.ProducedBy) {
                        $toSeries.ProducedBy.Add($studio)
                    }
                }
            }
        } 
    }

    [Void] ModifyCrossLinksBetweenSeriesAndStudio([Studio] $fromStudio, [Studio] $toStudio) {
        foreach ($series in $fromStudio.ProducedSeries) {
            for ($i = 0; $i -lt $series.ProducedBy.Count; $i++) {
                if ($series.ProducedBy[$i] -eq $fromStudio) {
                    
                    if ($toStudio -in $series.ProducedBy) {
                        $series.ProducedBy.Remove($fromStudio)
                    }
                    else {
                        $series.ProducedBy[$i] = $toStudio
                    }
                    
                    if ($series -notin $toStudio.ProducedSeries) {
                        $toStudio.ProducedSeries.Add($series)
                    }
                }
            }
        } 
    }

    [Object] GetCollectionByType ([FilenameElement] $filenameElement) {

        switch ($filenameElement) {
            {$_ -eq [FilenameElement]::Actors} {
                return $this.ContentModel.Actors
                break
            }
            {$_ -eq [FilenameElement]::Album} {
                return $this.ContentModel.Albums
                break
            }
            {$_ -eq [FilenameElement]::Artists} {
                return $this.ContentModel.Artists
                break
            }
            {$_ -eq [FilenameElement]::Series} {
                return $this.ContentModel.Series
                break
            }
            {$_ -eq [FilenameElement]::Studio} {
                return $this.ContentModel.Studios
                break
            }
            default {
                # Do nothing
            }
        }
        return $null
    }

    [Bool] IsValidForAlter ([String] $fromName, [String] $toName, [FilenameElement] $filenameElement) {
        
        [System.Collections.Generic.List[Object]] $subjectList = $this.GetCollectionByType([FilenameElement] $filenameElement)
        
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
        
        foreach ($fromObjectContentItem in $fromObject.GetRelatedContent()) {
            if ($this.WillAlterResultInContentCollision($fromObjectContentItem, $filenameElement, $fromName, $toName)) {
                Write-WarnToConsole "This alteratinon will cause a collision with content already in the model, abandoning action."
                return $false
            }
        }
        
        return $true
    }

    [Bool] RemodelFilenameFormat ([Int] $swapElement, [Int] $withElement, [Bool] $updateCorrespondingFilename) { 
        if (($swapElement -lt 0) -or ($swapElement -gt $this.ContentModel.config._FilenameFormat.Count - 1)) {
            Write-WarnToConsole "First element index is out of range, abandoning action."
            return $false
        }

        if (($withElement -lt 0) -or ($withElement -gt $this.ContentModel.config._FilenameFormat.Count - 1)) {
            Write-WarnToConsole "Second element index is out of range, abandoning action."
            return $false
        }

        [FilenameElement] $tempElement = $this.ContentModel.config._FilenameFormat[$swapElement]
        $this.ContentModel.config._FilenameFormat[$swapElement] = $this.ContentModel.config._FilenameFormat[$withElement]
        $this.ContentModel.config._FilenameFormat[$withElement] = $tempElement

        foreach ($item in $this.ContentModel.Content) {
            $item.UpdateContentBaseName()
        }

        return $true
    }

    [Bool] AlterSeasonEpisodeFormat([Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern, [Bool] $updateCorrespondingFilename) {

        # Set starting state
        [Int] $alterations = 0

        # For each content item
        foreach ($contentItem in $this.ContentModel.Content) {

            # Generate what the format should look like
            [String] $generatedElement = [ContentSubjectParser]::SeasonEpisodeToString($contentItem.season, $contentItem.episode, $padSeason, $padEpisode, $pattern)
            
            # If not null and the generated is different, update the SeasonEpisode and Basename
            if ($null -eq $generatedElement) {
                Write-WarnToConsole "Unexpected result while generating SeasonEpisode, skipping element."
            }
            elseif (($generatedElement -cne $contentItem.SeasonEpisode) -and ($null -ne $contentItem.Season) -and ($null -ne $contentItem.Episode)) {
                
                Write-InfoToConsole "Altering BaseName" $contentItem.BaseName

                $contentItem.SeasonEpisode = $generatedElement
                $contentItem.UpdateContentBaseName()
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

        # For each content item
        foreach ($contentItem in $this.ContentModel.Content) {
 
            # Generate what the format should look like
            [String] $generatedElement = [ContentSubjectParser]::TrackToString($contentItem.track, $padtrack)
            
            # If not null and the generated is different, update the Track and Basename
            if ($null -eq $generatedElement) {
                Write-WarnToConsole "Unexpected result while generating SeasonEpisode, skipping element."
            }
            elseif (($generatedElement -ne $contentItem.TrackLabel) -and ($null -ne $contentItem.Track)) {
                
                Write-InfoToConsole "Altering BaseName" $contentItem.BaseName

                $contentItem.TrackLabel = $generatedElement
                $contentItem.UpdateContentBaseName()
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

    [Bool] Alter ([String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        if (-not $this.IsValidForAlter($fromName, $toName, $filenameElement)) {
            return $false
        }

        # Set starting state
        [Int]    $alterations = 0
        [System.Collections.Generic.List[Object]] $subjectList = $this.GetCollectionByType([FilenameElement] $filenameElement)
        [Object] $fromObject = $subjectList.GetByName($fromName)
        [Object] $toObject = $subjectList.GetByName($toName)

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

            # if there is a toObject, then
            if ($null -ne $toObject) {
                
                # depending on the subject type ...
                if ($filenameElement -eq [FilenameElement]::Actors) {
                    $this.ReplaceActorLinkedWithContent($fromObjectContentItem, $fromObject, $toObject) 
                
                }
                elseif ($filenameElement -eq [FilenameElement]::Artists) {
                    $this.ReplaceArtistLinkedWithContent($fromObjectContentItem, $fromObject, $toObject) 
                
                }
                elseif ($filenameElement -eq [FilenameElement]::Album) {

                    # if the content model also models has studios, then re need to remap the relationship between studios and albums as well
                    if ($null -ne $fromObject.ProducedBy) {
                        $this.ModifyCrossLinksBetweenAlbumAndStudio($fromObject, $toObject)
                    }
                    # and then
                    $this.ReplaceAlbumLinkedWithContent($fromObjectContentItem, $toObject)

                }
                elseif ($filenameElement -eq [FilenameElement]::Series) {

                    # if the content model also models has studios, then re need to remap the relationship between studios and series as well
                    if ($null -ne $fromObject.ProducedBy) {
                        $this.ModifyCrossLinksBetweenSeriesAndStudio($fromObject, $toObject)
                    }
                    # and then
                    $this.ReplaceSeriesLinkedWithContent($fromObjectContentItem, $toObject)

                }
                elseif ($filenameElement -eq [FilenameElement]::Studio) {
                        
                    # if the content model also models has albums, then re need to remap the relationship between studios and albums as well
                    if ($null -ne $fromObject.ProducedAlbums) {
                        $this.ModifyCrossLinksBetweenAlbumAndStudio($fromObject, $toObject)
                    }

                    # if the content model also models has series, then re need to remap the relationship between studios and series as well
                    if ($null -ne $fromObject.ProducedSeries) {
                        $this.ModifyCrossLinksBetweenSeriesAndStudio($fromObject, $toObject)
                    }
                    # and then
                    $this.ReplaceStudioLinkedWithContent($fromObjectContentItem, $toObject)

                }
                else {
                    Write-WarnToConsole "Unsupport type, adandoning action."
                    return $null
                }
            }

            # Update the basename and filename in the model
            $fromObjectContentItem.UpdateContentBaseName()
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
    #endregion Methods
}
#endregion Class Definition