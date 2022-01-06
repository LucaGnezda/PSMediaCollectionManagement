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
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class AlbumBO : IContentSubjectBO {
    #region Properties
    #endregion Properties


    #region Constructors
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Album]
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
    #endregion Methods

}
#endregion Class Definition