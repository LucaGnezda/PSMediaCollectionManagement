using module .\..\Using\Controllers\CollectionManagementController.Static.psm1
using module .\..\Using\ObjectModels\ContentModel.Class.psm1


<#
    .SYNOPSIS
    Compares two ContentModels and/or FileIndexes.

    .DESCRIPTION
    Allows a ContentModel or a FileIndex to be compared against a baseline. Effective when merging to sets of content, or when comparing current content against a known good FileIndex.    

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Compare-FileIndex $contentModel $contentModel2

    .EXAMPLE
    PS> Compare-FileIndex $contentModel "./Index.json"
    
    .EXAMPLE
    PS> Compare-FileIndex "./Index.json" $contentModel 

    .EXAMPLE
    PS> Compare-FileIndex "./CurrentIndex.json" "./PastIndex.json"
#>
function Compare-ContentModels (

    # FileIndex baseline of comparison  
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="F2F")]
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="F2M")]
    [String] $baselineFilePath,
    
    # ContentModel baseline of comparison  
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="M2F")]
    [Parameter(Mandatory=$true, Position = 0, ParameterSetName="M2M")]
    [ContentModel] $baselineContentModel,
    
    # FileIndex to compare  
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="F2F")]
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="M2F")]
    [String] $comparisonFilePath,
    
    # ContentModel basis of comparison  
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="F2M")]
    [Parameter(Mandatory=$true, Position = 1, ParameterSetName="M2M")]
    [ContentModel] $comparisonContentModel,

    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="F2F")]
    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="F2M")]
    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="M2F")]
    [Parameter(Mandatory=$false, Position = 2, ParameterSetName="M2M")]
    [Switch] $ReturnSummary
){
  
    if ($PSBoundParameters.ContainsKey('baselineFilePath')) {
        $baseline = $baselineFilePath
    }

    if ($PSBoundParameters.ContainsKey('baselineContentModel')) {
        $baseline = $baselineContentModel
    }

    if ($PSBoundParameters.ContainsKey('comparisonFilePath')) {
        $comparison = $comparisonFilePath
    }

    if ($PSBoundParameters.ContainsKey('comparisonContentModel')) {
        $comparison = $comparisonContentModel
    }

    return [CollectionManagementController]::Compare($baseline, $comparison, $ReturnSummary.IsPresent)

}
