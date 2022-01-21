#region Header
#
# About: Provider for interacting with the filesystem
#
# Author: Luca Gnezda 
#
# Circa:  2022 
#
#endregion Header


#region Using
#------------
using module .\..\Interfaces\IFilesystemProvider.Interface.psm1
using module .\..\..\..\FilesystemExtensions\Using\ObjectModels\FileMetadataProperty.Class.psm1
#endregion Using


#region Class Definition
#-----------------------
class FilesystemProvider : IFilesystemProvider {

    #region Properties
    [Bool] Hidden $_DisposeShellOnDispose = $false
    [Bool] Hidden $_ActSilently = $false
    [Bool] Hidden $_HasValidPath = $false
    [String] Hidden $_AbsolutePath
    [String[]] Hidden $_IncludedExtensions
    [System.Array] Hidden $_fileCache

    #endregion Properties


    #region Constructors
    FilesystemProvider ([String] $path, [String[]] $includedExtensions, [Bool] $actSilently) {
        
        $this.ChangePath($path)
        $this._IncludedExtensions = $includedExtensions
        $this._ActSilently = $actSilently

        $this | Add-Member -Name "ActingSilently" -MemberType AliasProperty -Value "_ActSilently"
        $this | Add-Member -Name "HasValidPath" -MemberType AliasProperty -Value "_HasValidPath"
    }
    #endregion Constructors
    
    
    #region Methods
    [Void] ChangePath ([String] $path) {
        if ([String]::IsNullOrEmpty($path) -or ($path -eq ".") -or ($path -eq ".\")) {
            $this._AbsolutePath = (Get-Location).Path + "\"
        }
        elseif (Test-Path -PathType Container $path) {
            $this._AbsolutePath = (Resolve-Path $path).Path
            if (-not $this._AbsolutePath.EndsWith("\")) {
                $this._AbsolutePath += "\"
            }
        }
        else {
            $this._HasValidPath = $false
            throw [System.IO.DirectoryNotFoundException] "System.IO.DirectoryNotFoundException: Unable to resolve path as it does not exist."
        }
        $this._fileCache = $null
        $this._HasValidPath = $true
    }

    [System.IO.FileInfo[]] GetFiles () {
        # read the filesystem
        if ($null -eq $this._fileCache) {
            if ($this._IncludedExtensions.Count -eq 0) {
                $this._fileCache = Get-ChildItem $this._AbsolutePath -File
            }
            else {
                $this._fileCache = Get-ChildItem $this._AbsolutePath -File | Where-Object {$_.Extension -in $this._IncludedExtensions} 
            }
        }
        return $this._fileCache
    }

    [System.IO.FileInfo] GetFileIfExists([String] $filename) {

        if ($filename.Contains("\")) {
            if (-not $this._ActSilently) {
                Write-WarnToConsole "Warning: filenames must not be pathed, unable to generate."
            }
            return $null
        }

        return $this.GetFiles() | Where-Object {$_.Name -eq $filename}
    }

    [Bool] FileExists([String] $filename) {
        
        if ($null -eq $this.GetFileIfExists($filename)) {
            return $false
        }
        return $true
    }

    [String] GenerateHash([String] $filename) {

        $file = $this.GetFileIfExists($filename)
        return $this.GenerateHash([System.IO.FileInfo] $file)
    }

    [String] GenerateHash([System.IO.FileInfo] $file) {

        if ($null -eq $file) {
            if (-not $this._ActSilently) {
                Write-WarnToConsole "Warning: File not found, unable to generate."
            }
            return -1
        }

        return (Get-FileHash $file.FullName -Algorithm MD5).Hash
    }

    [Int] CheckFilesystemHash($hash, [String] $filename) {

        $file = $this.GetFileIfExists($filename) 
        return $this.CheckFilesystemHash($hash, $file)
    }

    [Int] CheckFilesystemHash($hash, [System.IO.FileInfo] $file) {
        
        if ([String]::IsNullOrEmpty($hash)) {
            if (-not $this._ActSilently) {
                Write-WarnToConsole "Warning: No Hash is availabile for this content, unable to verify."
            }
            return -1
        }

        if ($null -eq $file) {
            if (-not $this._ActSilently) {
                Write-WarnToConsole "Warning: File not found, unable to verify."
            }
            return -1
        }
        
        if ($this.GenerateHash($file) -eq $hash) {
            return 1
        }
        else {
            return 0
        }
    }

    [System.Collections.Generic.List[FileMetadataProperty]] GetFileMetadataProperty([System.IO.FileInfo] $file, [Int] $propertyIndex) {
        
        $this._DisposeShellOnDispose += Initialize-PersistentFilesystemShell
        return Get-FileMetadata $file $propertyIndex
    }

    [System.Collections.Generic.List[FileMetadataProperty]] GetFileMetadataProperties([System.IO.FileInfo] $file) {

        $this._DisposeShellOnDispose += Initialize-PersistentFilesystemShell
        return Get-FileMetadata $file
    }

    [Bool] UpdateFileName([String] $currentFilename, [String] $newFilename) {
    
        $file = $this.GetFileIfExists($currentFilename)
        return $this.UpdateFileName($file, $newFilename)
    
    } 

    [Bool] UpdateFileName([System.IO.FileInfo] $file, [String] $newFilename) {
    
        return Rename-File $file.Name $newFilename 
    }

    [Void] Dispose () {
        if ($this._DisposeShellOnDispose) {
            Remove-PersistentFilesystemShell
        }
    }
    #endregion Methods
}
#endregion Class Definition