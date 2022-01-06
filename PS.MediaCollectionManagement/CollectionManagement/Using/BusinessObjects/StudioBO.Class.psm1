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
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class StudioBO : IContentSubjectBO {
    #region Properties
    #endregion Properties


    #region Constructors
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Studio]
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
    #endregion Methods

}
#endregion Class Definition