#region Header
#
# About: Handlers Layer Class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Interfaces\IModelPersistenceHandler.Interface.psm1
using module .\..\Interfaces\IContentModel.Interface.psm1
using module .\..\ModuleBehaviour\CollectionManagementDefaults.Static.psm1
#endregion Using


#region Class Definition
#-----------------------
class ModelPersistenceHandler : IModelPersistenceHandler {

    #region Properties
    [PSCustomObject] Hidden $fileData
    #endregion Properties


    #region Constructors
    ModelPersistenceHandler () {

    }
    #endregion Constructors
    
    
    #region Implemented Methods
    [Bool] LoadConfigFromIndexFile ([String] $indexFilePath, [IContentModel] $contentModel) {
        
        # If get don't have valid data to work with return
        if (-not $this.ReadFromIndexFile($indexFilePath)) {
            return $false
        }

        # Determine file format
        if (([Bool]($this.fileData.PSObject.Properties.Name -match "FileType")) -and 
            ([Bool]($this.fileData.PSObject.Properties.Name -match "Config")) -and 
            ([Bool]($this.fileData.PSObject.Properties.Name -match "Content"))) {
            
            if ($this.fileData.FileType -eq [CollectionManagementDefaults]::V3_FILEINDEX_FILEFORMAT()) {
        
                # v3 format
                Write-InfoToConsole "V3 FileType detected, loading full configuration ..."

                $contentModel.Config._IncludedExtensions = $this.fileData.Config._IncludedExtensions
                $contentModel.Config._DecorateAsTags = $this.fileData.Config._DecorateAsTags
                $contentModel.Config._TagOpenDelimiter = $this.fileData.Config._TagOpenDelimiter
                $contentModel.Config._TagCloseDelimiter = $this.fileData.Config._TagCloseDelimiter
                $contentModel.Config._FilenameFormat = $this.fileData.Config._FilenameFormat
                $contentModel.Config._FilenameSplitter = $this.fileData.Config._FilenameSplitter
                $contentModel.Config._ListSplitter = $this.fileData.Config._ListSplitter
                $contentModel.Config._ExportFormat = $this.fileData.Config._ExportFormat

                $contentModel.Config.UpdateIndexes()
                return $true
            
            }
            elseif ($this.fileData.FileType -eq [CollectionManagementDefaults]::V2_FILEINDEX_FILEFORMAT()) {

                # v2 format
                Write-InfoToConsole "V2 FileType detected, loading available configuration, using current config settings for remainder ..."

                $contentModel.Config._IncludedExtensions = $this.fileData.Config._IncludedExtensions
                $contentModel.Config._DecorateAsTags = $this.fileData.Config._DecorateAsTags
                $contentModel.Config._FilenameFormat = $this.fileData.Config._FilenameFormat
                $contentModel.Config._FilenameSplitter = $this.fileData.Config._FilenameSplitter
                $contentModel.Config._ListSplitter = $this.fileData.Config._ListSplitter
                $contentModel.Config._ExportFormat = $this.fileData.Config._ExportFormat

                $contentModel.Config.UpdateIndexes()
                return $true
            }
        }

        # if we've got here then we couldn't load the config.
        Write-WarnToConsole "Unknown FileType detected, unable to load config."
        return $true

    }

    [System.Array] RetrieveDataFromIndexFile ([String] $indexFilePath) {
        
        # If get don't have valid data to work with return
        if (-not $this.ReadFromIndexFile($indexFilePath)) {
            return $false
        }

        # Determine file format
        if (([Bool]($this.fileData.PSObject.Properties.Name -match "FileType")) -and 
            ([Bool]($this.fileData.PSObject.Properties.Name -match "Config")) -and 
            ([Bool]($this.fileData.PSObject.Properties.Name -match "Content"))) {
            
            if ($this.fileData.FileType -eq [CollectionManagementDefaults]::V3_FILEINDEX_FILEFORMAT()) {
        
                # set location of the content source
                return $this.fileData.Content
            
            }
            elseif ($this.fileData.FileType -eq [CollectionManagementDefaults]::V2_FILEINDEX_FILEFORMAT()) {

                # set location of the content source
                return $this.fileData.Content

            }
            else {

                Write-WarnToConsole "Unknown FileType detected, abandoning load."
                return $null
            }
        }
        else {

            # attempt legacy format
            Write-InfoToConsole "File format not detected, attempting legacy load and using current config settings ..."

            # set location of the content source
            return $this.fileData

        }
    }

    [Void] SaveToIndexFile ([String] $indexFilePath, [IContentModel] $contentModel) {

        Write-InfoToConsole "Validating path" $indexFilePath "..."

        # First validate the path portion of the filepath
        if (-not(((Split-Path $indexFilePath) -ne "") -and (Split-Path $indexFilePath | Test-Path))) {
            Write-ErrorToConsole "Error: Invalid filepath"
            return
        }
        
        Write-InfoToConsole "Generating json output..."

        # Start building the output format by export a core structure and the config info
        $output = [PSCustomObject]::new()
        $output | Add-Member NoteProperty "FileType" ([CollectionManagementDefaults]::DEFAULT_FILEINDEX_FILEFORMAT())
        $output | Add-Member NoteProperty "Config" $null 
        $output | Add-Member NoteProperty "Content" $null
        $output.Config = $contentModel.Config | Select-Object ([CollectionManagementDefaults]::DEFAULT_CONFIG_EXPORT_FORMAT())

        # Next recast the content model into an object format more suitable for export
        $output.Content = $contentModel.Content | Select-Object $this.ContentModel.Config.ExportFormat.ForEach([String])

        # convert the object to json and return the result
        $json = $output | ConvertTo-Json

        Write-InfoToConsole "Writing file..."

        # Write the file
        $json | Save-File $indexFilePath
        
    }
    #endregion Implemented Methods

    #region Internal Methods
    [Bool] ReadFromIndexFile ([String] $indexFilePath) {

        # Read in the file data if not already set
        if ($null -eq $this.fileData) {

            # First validate the index filepath
            if (-not (Test-Path $indexFilePath)) {
                Write-ErrorToConsole "Error: Invalid filepath"
                return $false
            }

            # Read in the json
            try {
                [PSCustomObject] $this.fileData = (Get-Content -Raw -Path $IndexFilePath | ConvertFrom-Json)    
            }
            catch {
                Write-ErrorToConsole "Error parsing file, abandoning action"
                Write-ErrorToConsole $_
                return $false
            }

        }

        return $true
    }


    #endregion Internal Methods
}
#endregion Class Definition