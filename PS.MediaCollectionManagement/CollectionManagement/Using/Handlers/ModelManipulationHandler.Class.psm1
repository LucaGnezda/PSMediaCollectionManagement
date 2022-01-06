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
using module .\..\ObjectModels\Actor.Class.psm1
using module .\..\ObjectModels\Album.Class.psm1
using module .\..\ObjectModels\Artist.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\Series.Class.psm1
using module .\..\ObjectModels\Studio.Class.psm1
using module .\..\BusinessObjects\ContentBO.Class.psm1
#endregion Using


#region Class Definition
#-----------------------
class ModelManipulationHandler : IModelManipulationHandler {

    #region Properties
    [IContentModel] $ContentModel
    [IContentSubjectBO] $contentSubjectBO
    #endregion Properties


    #region Constructors
    ModelManipulationHandler ([IContentModel] $contentModel) {
        $this.ContentModel = $contentModel
    }
    #endregion Constructors
    
    
    #region Methods
    [Void] SetContentSubjectBO([IContentSubjectBO] $contentSubjectBO) {
        $this.contentSubjectBO = $contentSubjectBO
    }

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

    [Bool] IsValidForAlter ([System.Collections.Generic.List[Object]] $subjectList, [String] $fromName, [String] $toName, [FilenameElement] $filenameElement) {
        
        if ($null -eq $this.contentSubjectBO) {
            Write-WarnToConsole "No business object dependency set, abandoning action."
            return $false
        }

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

        if ($fromObject.GetType() -ne $this.contentSubjectBO.ActsOnType()) {
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
        [ContentBO] $contentBO = [ContentBO]::new()

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
        [ContentBO] $contentBO = [ContentBO]::new()

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

    [Bool] Alter ([System.Collections.Generic.List[Object]] $subjectList, [String] $fromName, [String] $toName, [Bool] $updateCorrespondingFilename, [FilenameElement] $filenameElement) {

        if (-not $this.IsValidForAlter($subjectList, $fromName, $toName, $filenameElement)) {
            return $false
        }

        # Set starting state
        [Int]    $alterations = 0
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

            # if there is a toObject, then migrate content and relationships 
            if ($null -ne $toObject) {
                $this.contentSubjectBO.ReplaceSubjectLinkedToContent($fromObjectContentItem, $fromObject, $toObject) 
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