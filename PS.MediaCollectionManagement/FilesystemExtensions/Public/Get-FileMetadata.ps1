using module .\..\Using\ObjectModels\FileMetadataProperty.Class.psm1
using module .\..\Using\ModuleBehaviour\FilesystemExtensionsSettings.Static.psm1
using module .\..\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1

<#
    .SYNOPSIS
    Returns file metadata. 

    .DESCRIPTION
    Returns metadata for a specified file, either for a single specified index, or all available metadata.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    [System.Collections.Generic.List[FileMetadataProperty]] 
    An object list of FileMetadataProperty containing an index, a key name, and a key value 

    .EXAMPLE
    PS> Get-FileMetadata $file

    .EXAMPLE
    PS> Get-FileMetadata $file 317
#>
function Get-FileMetadata (

    # A System.IO.FileSystemInfo object
    [Parameter(Mandatory=$true)]
    [System.IO.FileSystemInfo] $file, 

    # An optional integer representing the index of the metadata requested.
    [Parameter(Mandatory=$false)]
    [Int] $propertyIndex

) {

    [System.Collections.Generic.List[FileMetadataProperty]] $fileMetadata = [System.Collections.Generic.List[FileMetadataProperty]]::new()
    [String] $rawPropertyName = ""
    [String] $rawPropertyValue = ""
    
    # If we don't have a COM Shell, instantiate one. If we do remember so we can dispose it when done.
    $disposeWhenDone = [FilesystemExtensionsState]::InstantiateShell()

    # Get a TextInfo object
    $textInfo = (Get-Culture).TextInfo

    # Target the folder in question
    $shellFolder = [FilesystemExtensionsState]::Shell.NameSpace($file.DirectoryName)

    # Target the file in question
    $shellFile = $shellFolder.ParseName($file.Name)

    # if an index was provided, just get that one, otherwise iterate over the entire possible set 
    if ($PSBoundParameters.ContainsKey('propertyIndex')) {
        
        $i = $propertyIndex

        $rawPropertyName = $shellFolder.GetDetailsOf($null, $i)
        $rawPropertyValue = $shellFolder.GetDetailsOf($shellFile, $i)

        # Create a cleansed property if valid information exists
        if (($rawPropertyName.Length -gt 0) -and ($rawPropertyValue.Length -gt 0)) {
                
            $property = [FileMetadataProperty]::new(
                $i,
                ($textInfo.ToTitleCase($rawPropertyName) -replace " ", ""),
                ($rawPropertyValue -replace [char]8206,"")
            )

            $fileMetadata.Add($property)
        }
    }
    else {
        # Iterate, creating cleansed properties if valid information exists (please note accessing the shell one by one is slow)
        while ($i -le [FilesystemExtensionsSettings]::DEFAULT_MAX_METADATA_PROPERTIES()) {

            $rawPropertyName = $shellFolder.GetDetailsOf($null, $i)
            $rawPropertyValue = $shellFolder.GetDetailsOf($shellFile, $i)

            if (($rawPropertyName.Length -gt 0) -and ($rawPropertyValue.Length -gt 0)) {
                
                $property = [FileMetadataProperty]::new(
                    $i,
                    ($textInfo.ToTitleCase($rawPropertyName) -replace " ", ""),
                    ($rawPropertyValue -replace [char]8206,"")
                )

                $fileMetadata.Add($property)
            }
        
            $i++
        }
    }

    if ($disposeWhenDone) {
        [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
    }

    return $fileMetadata
}