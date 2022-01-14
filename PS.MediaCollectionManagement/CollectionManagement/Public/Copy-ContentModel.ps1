#using module .\..\Using\Interfaces\IContentModel.Interface.psm1
using module .\..\Using\Controllers\CollectionManagementController.Abstract.psm1
using module .\..\Using\ObjectModels\ContentModel.Class.psm1

<#
    .SYNOPSIS
    Copies a content model.

    .DESCRIPTION
    Creates a separate in memory copy of a content model.

    .INPUTS
    [ContentModel] ContentModel to copy.

    .OUTPUTS
    [ContentModel] ContentModel 

    .EXAMPLE
    PS> Copy-ContentModel $contentModel 
#>
function Copy-ContentModel (
    [Parameter(Mandatory=$true)]
    [ContentModel] $ContentModel
) {
    return [CollectionManagementController]::CopyModel($ContentModel)
}