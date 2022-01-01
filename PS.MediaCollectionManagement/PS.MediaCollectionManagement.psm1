#region Header
#
# About: Root of PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------

using module .\CollectionManagement\Using\ObjectModels\ContentModel.Class.psm1

#endregion Using



#region Dot source scripts 
#-------------------------
#Get public and private function definition files.
$consoleExtensionsScripts = @( Get-ChildItem -Path $PSScriptRoot\ConsoleExtensions\*\*.ps1 -ErrorAction SilentlyContinue )
$filesystemExtensionsScripts = @( Get-ChildItem -Path $PSScriptRoot\FilesystemExtensions\*\*.ps1 -ErrorAction SilentlyContinue )
$collectionManagementScripts = @( Get-ChildItem -Path $PSScriptRoot\CollectionManagement\*\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach ($moduleScript in @($consoleExtensionsScripts + $filesystemExtensionsScripts + $collectionManagementScripts)) {
    try {
        . $moduleScript.fullname
    }
    catch {
        Write-Host "Failed to import function $($moduleScript.fullname): $_"
    }
}

#endregion dot source scripts



#region Export Module Members
#----------------------------

# Implicit foreach export
# Export-ModuleMember -Function $publicScripts.Basename

#endregion Export Module Members