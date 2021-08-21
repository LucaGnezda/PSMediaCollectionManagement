using module .\..\..\Using\ObjectModels\PS.MCM.ContentModel.Class.psm1

function Copy-ContentModel (
    [Parameter(Mandatory=$true)]
    [ContentModel] $contentModel
) {
    # Set starting state
    $i = 0

    # Instantiate a new ContentModel
    [ContentModel] $copy = New-ContentModel

    # Copy the config
    $copy.Config._IncludedExtensions = $contentModel.Config._IncludedExtensions.Clone()
    $copy.Config._DecorateAsTags = $contentModel.Config._DecorateAsTags.Clone()
    $copy.Config._FilenameFormat = $contentModel.Config._FilenameFormat.Clone()
    $copy.Config._FilenameSplitter = $contentModel.Config._FilenameSplitter
    $copy.Config._ListSplitter = $contentModel.Config._ListSplitter
    $copy.Config._ExportFormat = $contentModel.Config._ExportFormat.Clone()
    $copy.Config._FilenameFormatLock = $contentModel.Config._FilenameFormatLock

    # Initialise the ContentModel
    $copy.Init()

    # for each file
    foreach ($item in $contentModel.Content) {    
        
        # Show a progress bar
        Write-Progress -Activity "Copying Model" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $contentModel.Content.count)

        # Add the content to the model
        $addedContent = $copy.AddContentToModel($item.FileName, $item.BaseName, $item.Extension)

        # Add content Properties
        $addedContent.AlteredBaseName = $item.AlteredBaseName
        $addedContent.PendingFilenameUpdate = $item.PendingFilenameUpdate
        $addedContent.FrameWidth = $item.FrameWidth
        $addedContent.FrameHeight = $item.FrameHeight
        $addedContent.FrameRate = $item.FrameRate
        $addedContent.BitRate = $item.BitRate
        $addedContent.TimeSpan = $item.TimeSpan
        $addedContent.Hash = $item.Hash
        foreach ($warning in $item.Warnings) { $addedContent.AddWarning($warning) }

        # Increment the counter
        $i++
    
    }

    # Hide the progress bar
    Write-Progress -Activity "Copying Model" -Completed
    #>
    return $copy
}