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
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class ArtistBO : IContentSubjectBO {
    #region Properties
    #endregion Properties


    #region Constructors
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Artist]
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
        break
    }
    #endregion Methods

}
#endregion Class Definition