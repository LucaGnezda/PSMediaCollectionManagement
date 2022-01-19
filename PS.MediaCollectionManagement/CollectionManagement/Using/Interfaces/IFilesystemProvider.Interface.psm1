#region Header
#
# About: Pseudo Interface 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\..\..\Shared\Using\Base\IsInterface.Class.psm1
using module .\..\..\..\FilesystemExtensions\Using\ObjectModels\FileMetadataProperty.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IFilesystemProvider : IsInterface {
    IFilesystemProvider () {
        $this.AssertAsInterface([IFilesystemProvider])
    }

    # Prototypes
    [Void] ChangePath ([String] $path) { }
    [System.IO.FileInfo[]] GetFiles () { return $null }
    [System.IO.FileInfo] GetFileIfExists([String] $filename) { return $null }
    [Bool] FileExists([String] $filename) { return $null }
    [String] GenerateHash([String] $filename) { return $null }
    [String] GenerateHash([System.IO.FileInfo] $file) { return $null }
    [Int] CheckFilesystemHash($hash, [String] $filename) { return $null }
    [Int] CheckFilesystemHash($hash, [System.IO.FileInfo] $file) { return $null }
    [System.Collections.Generic.List[FileMetadataProperty]] GetFileMetadataProperty([System.IO.FileInfo] $file, [Int] $propertyIndex) { return $null }
    [System.Collections.Generic.List[FileMetadataProperty]] GetFileMetadataProperties([System.IO.FileInfo] $file) { return $null }
    [Bool] UpdateFileName([String] $currentFilename, [String] $newFilename) { return $null }
    [Bool] UpdateFileName([System.IO.FileInfo] $file, [String] $newFilename) { return $null }
    [Void] Dispose () { }
}
