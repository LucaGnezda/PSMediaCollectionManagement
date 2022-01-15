#region Header
#
# About: Class for working with Studio objects 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\Interfaces\IContentSubjectBO.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\Studio.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\ContentModelConfig.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class StudioBO : IContentSubjectBO {
    
    #region Properties
    [ContentModelConfig] $Config
    #endregion Properties


    #region Constructors
    StudioBO([ContentModelConfig] $config) {
        if (-not $config.IsFilenameFormatLocked) {
            throw [System.InvalidOperationException] "System.InvalidOperationException: ContentBO Cannot be instantiated successfully a without a committed Filename Format."
        }
        $this.Config = $config
    }
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Studio]
    }

    [FilenameElement] ActsOnFilenameElement() {
        return [FilenameElement]::Studio
    }

    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) {
        
        if (($replace.GetType() -eq [Studio]) -and ($with.GetType() -eq [Studio])) {
            # if the content model also models has albums, then re need to remap the relationship between studios and albums as well
            if ($null -ne $replace.ProducedAlbums) {
                $this.ModifyCrossLinksBetweenAlbumAndStudio($replace, $with)
            }

            # if the content model also models has series, then re need to remap the relationship between studios and series as well
            if ($null -ne $replace.ProducedSeries) {
                $this.ModifyCrossLinksBetweenSeriesAndStudio($replace, $with)
            }
            # and then
            $this.ReplaceStudioLinkedWithContent($content, $with)
        }
        else {
            # Make no change
        }
    }

    [Void] ReplaceStudioLinkedWithContent([Content] $content, [Studio] $withStudio) {
        
        $content.ProducedBy = $withStudio
        $withStudio.Produced.Add($content)
    }

    [Void] ModifyCrossLinksBetweenAlbumAndStudio([Studio] $replaceStudio, [Studio] $withStudio) {
        foreach ($album in $replaceStudio.ProducedAlbums) {
            for ($i = 0; $i -lt $album.ProducedBy.Count; $i++) {
                if ($album.ProducedBy[$i] -eq $replaceStudio) {
                    
                    if ($withStudio -in $album.ProducedBy) {
                        $album.ProducedBy.Remove($replaceStudio)
                    }
                    else {
                        $album.ProducedBy[$i] = $withStudio
                    }

                    if ($album -notin $withStudio.ProducedAlbums) {
                        $withStudio.ProducedAlbums.Add($album)
                    }
                }
            }
        } 
    }

    [Void] ModifyCrossLinksBetweenSeriesAndStudio([Studio] $replaceStudio, [Studio] $withStudio) {
        foreach ($series in $replaceStudio.ProducedSeries) {
            for ($i = 0; $i -lt $series.ProducedBy.Count; $i++) {
                if ($series.ProducedBy[$i] -eq $replaceStudio) {
                    
                    if ($withStudio -in $series.ProducedBy) {
                        $series.ProducedBy.Remove($replaceStudio)
                    }
                    else {
                        $series.ProducedBy[$i] = $withStudio
                    }
                    
                    if ($series -notin $withStudio.ProducedSeries) {
                        $withStudio.ProducedSeries.Add($series)
                    }
                }
            }
        } 
    }

    [ContentSubjectBase] AddStudioRelationshipsWithContent([Content] $content, [System.Collections.Generic.List[ContentSubjectBase]] $studiosList, [String] $studioNameToAdd) {

        # Decorate Studios that are actually tags
        if ($studioNameToAdd -in $this.Config.DecorateAsTags){
            $studioNameToAdd = $this.Config.TagOpenDelimiter + $studioNameToAdd + $this.Config.TagCloseDelimiter
        }
        
        # If the Studio name already exists, grab that one, otherwise create a new Studio
        if ($studiosList.Count -eq 0) {
            $studio = [Studio]::new($studioNameToAdd, $this.Config.IncludeAlbums, $this.Config.IncludeSeries)
            $studiosList.Add($studio)
        }
        elseif ($studioNameToAdd -cin $studiosList.Name) {
            $studio = $studiosList.Find({$args[0].Name -ceq $studioNameToAdd})
        }
        else {
            $studio = [Studio]::new($studioNameToAdd, $this.Config.IncludeAlbums, $this.Config.IncludeSeries)
            $studiosList.Add($studio)
        } 

        # two way link the Studio and content objects
        $content.ProducedBy = $studio
        $studio.Produced.Add($content)

        return $studio
    }

    [Void] RemoveStudioRelationshipsWithContentAndCleanup([System.Collections.Generic.List[ContentSubjectBase]] $studiosList, [Content] $contentToRemove) {

        # For the studio linked to the content
        $studio = $contentToRemove.ProducedBy

        # Delete the reference back to the content to be deleted
        $studio.Produced.Remove($contentToRemove)

        # If no references remain, delete the studio too
        if ($studio.Produced.Count -eq 0) {
            $studiosList.Remove($studio)

            # And if part of the model, remove the cross reference from the album
            if ($null -ne $contentToRemove.OnAlbum) {
                $contentToRemove.OnAlbum.ProducedBy.Remove($studio)
            }

            # And if part of the model, remove the cross reference from the series
            if ($null -ne $contentToRemove.FromSeries) {
                $contentToRemove.FromSeries.ProducedBy.Remove($studio)
            }
        }
    }
    #endregion Methods

}
#endregion Class Definition