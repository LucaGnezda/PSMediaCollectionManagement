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

using module .\Using\ObjectModels\PS.MCM.ContentModel.Class.psm1

#endregion Using



#region Dot source scripts 
#-------------------------
#Get public and private function definition files.
$publicScripts   = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$privateScripts  = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach ($moduleScript in @($publicScripts + $privateScripts)) {
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