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
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="WithPath")]
    [String] $FilePath = ".\",

    [Parameter(Mandatory=$true, Position=1, ParameterSetName="WithPath")]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="NoPath")]
    [ContentModel] $ContentModel,

    [Parameter(Mandatory=$false, ParameterSetName="WithPath")]
    [Parameter(Mandatory=$false, ParameterSetName="NoPath")]
    [Switch] $ReturnSummary
) {

    return [CollectionManagementController]::TestFilesystemHashes($FilePath, $ContentModel, $ReturnSummary.IsPresent)
}