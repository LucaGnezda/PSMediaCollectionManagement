using module .\..\Using\ObjectModels\PS.MCM.ContentModel.Class.psm1

<#
    .SYNOPSIS
    Returns a new ContentModel object

    .DESCRIPTION
    Returns a new ContentModel object which can then be used to process or analyse content.    

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    [ContentModel]
    A new ContentModel object

    .EXAMPLE
    PS> $contentModel = New-ContentModel
#>
function New-ContentModel () {
    return [ContentModel]::new()  
}