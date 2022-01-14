#region Header
#
# About: Class for working with Album objects 
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
using module .\..\ObjectModels\Album.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\ContentModelConfig.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class AlbumBO : IContentSubjectBO {
    
    #region Properties
    [ContentModelConfig] $Config
    #endregion Properties


    #region Constructors
    AlbumBO([ContentModelConfig] $config) {
        if (-not $config.IsFilenameFormatLocked) {
            throw [System.InvalidOperationException] "System.InvalidOperationException: ContentBO Cannot be instantiated successfully a without a committed Filename Format."
        }
        $this.Config = $config
    }
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Album]
    }

    [FilenameElement] ActsOnFilenameElement() {
        return [FilenameElement]::Album
    }

    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) {
        
        if (($replace.GetType() -eq [Album]) -and ($with.GetType() -eq [Album])) {
            # if the content model also models has studios, then re need to remap the relationship between studios and albums as well
            if ($null -ne $replace.ProducedBy) {
                $this.ModifyCrossLinksBetweenAlbumAndStudio($replace, $with)
            }
            # and then
            $this.ReplaceAlbumLinkedWithContent($content, $with)
        }
        else {
            # Make no change
        }
    }

    [Void] ReplaceAlbumLinkedWithContent([Content] $content, [Album] $withAlbum) {

        $content.OnAlbum = $withAlbum
        $withAlbum.Tracks.Add($content)
    }

    [Void] ModifyCrossLinksBetweenAlbumAndStudio([Album] $replaceAlbum, [Album] $withAlbum) {
        foreach ($studio in $replaceAlbum.ProducedBy) {
            for ($i = 0; $i -lt $studio.ProducedAlbums.Count; $i++) {
                if ($studio.ProducedAlbums[$i] -eq $replaceAlbum) {

                    if ($withAlbum -in $studio.ProducedAlbums) {
                        $studio.ProducedAlbums.Remove($replaceAlbum)
                    }
                    else {
                        $studio.ProducedAlbums[$i] = $withAlbum
                    }
                    
                    if ($studio -notin $withAlbum.ProducedBy) {
                        $withAlbum.ProducedBy.Add($studio)
                    }
                }
            }
        } 
    }

    [ContentSubjectBase] AddAlbumRelationshipsWithContent([Content] $content, [System.Collections.Generic.List[ContentSubjectBase]] $albumsList, [String] $albumNameToAdd) {

        # Decorate Album that are actually tags
        if ($albumNameToAdd -in $this.Config.DecorateAsTags){
            $albumNameToAdd = $this.Config.TagOpenDelimiter + $albumNameToAdd + $this.Config.TagCloseDelimiter
        }
        
        # If the Album name already exists, grab that one, otherwise create a new Album
        if ($albumsList.Count -eq 0) {
            $album = [Album]::new($albumNameToAdd, $this.Config.IncludeStudios)
            $albumsList.Add($album)
        }
        elseif ($albumNameToAdd -cin $albumsList.Name) {
            $album = $albumsList.Find({$args[0].Name -ceq $albumNameToAdd})
        }
        else {
            $album = [Album]::new($albumNameToAdd, $this.Config.IncludeStudios)
            $albumsList.Add($album)
        } 

        # two way link the Album and content objects
        $content.OnAlbum = $album
        $album.Tracks.Add($content)

        return $album
    }

    [Void] RemoveAlbumRelationshipsWithContentAndCleanup([System.Collections.Generic.List[ContentSubjectBase]] $albumsList, [Content] $contentToRemove) {

        # For the album linked to the content
        $album = $contentToRemove.OnAlbum

        # Delete the reference back to the content to be deleted
        $album.Track.Remove($contentToRemove)

        # If no references remain, delete the album too
        if ($album.Track.Count -eq 0) {
            $albumsList.Remove($album)

            # And if part of the model, remove the cross reference from the studio
            if ($null -ne $contentToRemove.ProducedBy) {
                $contentToRemove.ProducedBy.ProducedAlbum.Remove($album)
            }
        }
    }
    #endregion Methods

}
#endregion Class Definition