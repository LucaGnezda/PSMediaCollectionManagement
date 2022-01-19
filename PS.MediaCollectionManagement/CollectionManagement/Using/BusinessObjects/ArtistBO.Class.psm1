#region Header
#
# About: Class for working with Artist objects 
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
using module .\..\ObjectModels\Artist.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\ContentModelConfig.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class ArtistBO : IContentSubjectBO {
    
    #region Properties
    [ContentModelConfig] $Config
    #endregion Properties


    #region Constructors
    ArtistBO([ContentModelConfig] $config) {
        if (-not $config.IsFilenameFormatLocked) {
            throw [System.InvalidOperationException] "System.InvalidOperationException: ContentBO Cannot be instantiated successfully a without a committed Filename Format."
        }
        $this.Config = $config
    }
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Artist]
    }

    [FilenameElement] ActsOnFilenameElement() {
        return [FilenameElement]::Artists
    }

    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) {
        
        if (($replace.GetType() -eq [Artist]) -and ($with.GetType() -eq [Artist])) {
            $this.ReplaceArtistLinkedWithContent($content, $replace, $with) 
        }
        else {
            # Make no change
        }
    }

    [Void] ReplaceArtistLinkedWithContent([Content] $content, [Artist] $replaceArtist, [Artist] $withArtist) {
        
        for ($i = 0; $i -lt $content.Artists.Count; $i++) {
            if ($content.Artists[$i] -eq $replaceArtist) {
                $content.Artists[$i] = $withArtist
            }
        }
        $withArtist.Performed.Add($content)        
    }

    [Void] AddArtistRelationshipsWithContent([Content] $content, [System.Collections.Generic.List[ContentSubjectBase]] $artistsList, [String[]] $artistNamesToAdd) {
        
        # for each Artist
        foreach ($artistName in $artistNamesToAdd) {

            # Decorate Artists that are actually tags
            if ($artistName -in $this.Config.DecorateAsTags){
                $artistName = $this.Config.TagOpenDelimiter + $artistName + $this.Config.TagCloseDelimiter
            } 

            # If the Artist name already exists, grab that one, otherwise create a new Artist
            if ($artistsList.Count -eq 0) {
                $artist = [Artist]::new($artistName)
                $artistsList.Add($artist)
            }
            elseif ($artistName -cin $artistsList.Name) {
                $artist = $artistsList.Find({$args[0].Name -ceq $artistName})
            }
            else {
                $artist = [Artist]::new($artistName)
                $artistsList.Add($artist)
            }

            # two way link the Artist and content objects
            $content.Artists.Add($artist)
            $artist.Performed.Add($content)
        }
    }

    [Void] RemoveArtistRelationshipsWithContentAndCleanup([System.Collections.Generic.List[ContentSubjectBase]] $artistsList, [Content] $contentToRemove) {

        # For each actor linked to the content
        foreach ($artist in $contentToRemove.Actors) {

            # Delete the reference back to the content to be deleted
            $artist.PerformedIn.Remove($contentToRemove)

            # If no references remain, delete the actor too
            if ($artist.PerformedIn.Count -eq 0) {
                $artistsList.Remove($artist)
            }
        }
    }
    #endregion Methods

}
#endregion Class Definition