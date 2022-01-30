using module .\..\Using\ObjectModels\FileMetadataProperty.Class.psm1
using module .\..\Using\ModuleBehaviour\FilesystemExtensionsSettings.Static.psm1
using module .\..\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1

<#
    .SYNOPSIS
    Returns file metadata keys exposed by the filesystem 

    .DESCRIPTION
    Returns file metadata keys exposed by the filesystem.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    [System.Collections.Generic.List[FileMetadataProperty]] 
    An object list of FileMetadataProperty containing an index and a key name 

    .EXAMPLE
    PS> Get-AvailableFileMetadataKeys
#>
function Get-AvailableFileMetadataKeys () {
    
    [System.Collections.Generic.List[FileMetadataProperty]] $fileMetadataKeys = [System.Collections.Generic.List[FileMetadataProperty]]::new()
    [String] $rawPropertyName

    # If we don't have a COM Shell, instantiate one. If we do remember so we can dispose it when done.
    $disposeWhenDone = [FilesystemExtensionsState]::InstantiateShell()

    # Get a TextInfo object
    $textInfo = (Get-Culture).TextInfo
    
    # Get the current location
    $currentFolderPath = Get-Location
    
    # If it's a remote path strip away the first part
    if ($currentFolderPath -match "::") {
        $currentFolderPath = (($currentFolderPath -split "::")[1]).Trim()
    }

    

    # Target the current folder
    $shellFolder = [FilesystemExtensionsState]::Shell.NameSpace($currentFolderPath.ToString())

    # Iterate, creating cleansed properties if valid information exists (please note accessing the shell one by one is slow)
    while ($i -le [FilesystemExtensionsSettings]::DEFAULT_MAX_METADATA_PROPERTIES()) {

        $rawPropertyName = $shellFolder.GetDetailsOf($null, $i)

        if ($rawPropertyName.Length -gt 0) {
            $cleansedPropertyName = ($textInfo.ToTitleCase($rawPropertyName) -replace " ", "")
            [FileMetadataProperty] $key = [FileMetadataProperty]::new($i, $cleansedPropertyName, $null)                
            $fileMetadataKeys.Add($key)
        }
        
        $i++
    }

    if ($disposeWhenDone) {
        [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
    }

    return $fileMetadataKeys

}