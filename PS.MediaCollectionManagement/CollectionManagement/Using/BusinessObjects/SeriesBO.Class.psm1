#region Header
#
# About: Class for working with Series objects 
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
using module .\..\ObjectModels\Series.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class SeriesBO : IContentSubjectBO {
    #region Properties
    #endregion Properties


    #region Constructors
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Series]
    }

    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) {
        
        if (($replace.GetType() -eq [Series]) -and ($with.GetType() -eq [Series])) {
            # if the content model also models has studios, then re need to remap the relationship between studios and series as well
            if ($null -ne $replace.ProducedBy) {
                $this.ModifyCrossLinksBetweenSeriesAndStudio($replace, $with)
            }
            # and then
            $this.ReplaceSeriesLinkedWithContent($content, $with)
        }
        else {
            # Make no change
        }
    }

    [Void] ReplaceSeriesLinkedWithContent([Content] $content, [Series] $withSeries) {

        $content.FromSeries = $withSeries
        $withSeries.Episodes.Add($content)
    }

    [Void] ModifyCrossLinksBetweenSeriesAndStudio([Series] $replaceSeries, [Series] $withSeries) {
        foreach ($studio in $replaceSeries.ProducedBy) {
            for ($i = 0; $i -lt $studio.ProducedSeries.Count; $i++) {
                if ($studio.ProducedSeries[$i] -eq $replaceSeries) {

                    if ($withSeries -in $studio.ProducedSeries) {
                        $studio.ProducedSeries.Remove($replaceSeries)
                    }
                    else {
                        $studio.ProducedSeries[$i] = $withSeries
                    }
                    
                    if ($studio -notin $withSeries.ProducedBy) {
                        $withSeries.ProducedBy.Add($studio)
                    }
                }
            }
        } 
    }
    #endregion Methods

}
#endregion Class Definition