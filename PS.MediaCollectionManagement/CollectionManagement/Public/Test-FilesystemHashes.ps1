using module .\..\Using\Controllers\CollectionManagementController.Static.psm1
using module .\..\Using\ObjectModels\ContentModel.Class.psm1

<#
    .SYNOPSIS
    Tests hashes of files in the filesystem against known hashes in the content model.

    .DESCRIPTION
    Tests hashes of files in the filesystem against known hashes in the content model.

    .INPUTS
    [ContentModel] ContentModel with known hashes
    [Bool] ReturnSummary (returns an array if $true)

    .OUTPUTS
    None or Array.

    .EXAMPLE
    PS> Test-FilesystemHashes $contentModel $false
#>
function Test-FilesystemHashes (
    [Parameter(Mandatory=$true)]
    [ContentModel] $ContentModel,

    [Parameter(Mandatory=$false)]
    [Switch] $ReturnSummary
) {

    return [CollectionManagementController]::TestFilesystemHashes($ContentModel, $ReturnSummary.IsPresent)
}