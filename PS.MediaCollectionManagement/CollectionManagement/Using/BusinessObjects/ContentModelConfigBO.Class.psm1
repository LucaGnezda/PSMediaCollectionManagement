#region Header
#
# About: Class for working with ContentModelConfig objects 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\ObjectModels\ContentModelConfig.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class ContentModelConfigBO
{
    #region Properties
    #endregion Properties


    #region Constructors
    #endregion Constructors


    #region Methods
    [Bool] IsMatch([ContentModelConfig] $configA, [ContentModelConfig] $configB) {
        
        $comparisonProperties = (Get-Member -InputObject $configA -MemberType Properties).Name
        
        if ( @(Compare-Object $configA $configB -SyncWindow 0 -Property $comparisonProperties).Length -eq 0 ) {
            return $true
        }
        return $false
    }

    [Void] CloneCopy([ContentModelConfig] $fromConfig, [ContentModelConfig] $toConfig) {
        $toConfig._IncludedExtensions = $fromConfig._IncludedExtensions.Clone()
        $toConfig._DecorateAsTags = $fromConfig._DecorateAsTags.Clone()
        $toConfig._TagOpenDelimiter = $fromConfig.TagOpenDelimiter.Clone()
        $toConfig._TagCloseDelimiter = $fromConfig.TagCloseDelimiter.Clone()
        $toConfig._FilenameFormat = $fromConfig._FilenameFormat.Clone()
        $toConfig._FilenameSplitter = $fromConfig._FilenameSplitter.Clone()
        $toConfig._ListSplitter = $fromConfig._ListSplitter.Clone()
        $toConfig._ExportFormat = $fromConfig._ExportFormat.Clone()
        $toConfig._FilenameFormatLock = $fromConfig._FilenameFormatLock

        $toConfig.UpdateIndexes()
    }
    #endregion Methods

}
#endregion Class Definition