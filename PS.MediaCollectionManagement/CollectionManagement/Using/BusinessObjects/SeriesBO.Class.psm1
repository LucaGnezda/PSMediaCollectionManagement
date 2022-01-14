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
using module .\..\ObjectModels\ContentModelConfig.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class SeriesBO : IContentSubjectBO {
    
    #region Properties
    [ContentModelConfig] $Config
    #endregion Properties


    #region Constructors
    SeriesBO([ContentModelConfig] $config) {
        if (-not $config.IsFilenameFormatLocked) {
            throw [System.InvalidOperationException] "System.InvalidOperationException: ContentBO Cannot be instantiated successfully a without a committed Filename Format."
        }
        $this.Config = $config
    }
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Series]
    }

    [FilenameElement] ActsOnFilenameElement() {
        return [FilenameElement]::Series
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

    [ContentSubjectBase] AddSeriesRelationshipsWithContent([Content] $content, [System.Collections.Generic.List[ContentSubjectBase]] $seriesList, [String] $seriesNameToAdd) {

        # Decorate Series that are actually tags
        if ($seriesNameToAdd -in $this.Config.DecorateAsTags){
            $seriesNameToAdd = $this.Config.TagOpenDelimiter + $seriesNameToAdd + $this.Config.TagCloseDelimiter
        }
        
        # If the Series name already exists, grab that one, otherwise create a new Series
        if ($seriesList.Count -eq 0) {
            $seriesObj = [Series]::new($seriesNameToAdd, $this.Config.IncludeStudios)
            $seriesList.Add($seriesObj)
        }
        elseif ($seriesNameToAdd -cin $seriesList.Name) {
            $seriesObj = $seriesList.Find({$args[0].Name -ceq $seriesNameToAdd})
        }
        else {
            $seriesObj = [Series]::new($seriesNameToAdd, $this.Config.IncludeStudios)
            $seriesList.Add($seriesObj)
        } 

        # two way link the Series and content objects
        $content.FromSeries = $seriesObj
        $seriesObj.Episodes.Add($content)

        return $seriesObj
    }

    [Void] RemoveSeriesRelationshipsWithContentAndCleanup([System.Collections.Generic.List[ContentSubjectBase]] $seriesList, [Content] $contentToRemove) {

        # For the series linked to the content
        $seriesObj = $contentToRemove.FromSeries

        # Delete the reference back to the content to be deleted
        $seriesObj.Episodes.Remove($contentToRemove)

        # If no references remain, delete the series too
        if ($seriesObj.Track.Count -eq 0) {
            $seriesList.Remove($seriesObj)

            # And if part of the model, remove the cross reference from the studio
            if ($null -ne $contentToRemove.ProducedBy) {
                $contentToRemove.ProducedBy.ProducedSeries.Remove($seriesObj)
            }
        }
        
    }
    #endregion Methods

}
#endregion Class Definition