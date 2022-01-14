using module .\..\Using\ObjectModels\ContentModel.Class.psm1
using module .\..\Using\ObjectModels\ContentComparer.Class.psm1
#using module .\..\Using\Types\Types.psm1

<#
    .SYNOPSIS
    Merges two content models.

    .DESCRIPTION
    Merges two content models into a third return model.

    .INPUTS
    [ContentModel] ContentModel 
    [ContentModel] ContentModel to merge with

    .OUTPUTS
    [ContentModel] ContentModel merged

    .EXAMPLE
    PS> $contentModelC = Merge-ContentModel $contentModelA $contentModelB
#>
function Merge-ContentModel (
    [Parameter(Mandatory=$true)]
    [ContentModel] $contentModelA,

    [Parameter(Mandatory=$true)]
    [ContentModel] $contentModelB
) {
    return [CollectionManagementController]::MergeModel($contentModelA, $contentModelB)
}

