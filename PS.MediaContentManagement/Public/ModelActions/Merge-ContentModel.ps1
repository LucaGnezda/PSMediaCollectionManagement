using module .\..\..\Using\ObjectModels\PS.MCM.ContentModel.Class.psm1
using module .\..\..\Using\Helpers\PS.MCM.ContentComparer.Class.psm1
using module .\..\..\Using\Types\PS.MCM.Types.psm1

<#
    .SYNOPSIS
    Merges two content models.

    .DESCRIPTION
    Merges two content models into a third return model.

    .INPUTS
    [ContentModel] ContentModel 
    [ContentModel] ContentModel to merge with

    .OUTPUTS
    [ContentModel] ContentModel merged

    .EXAMPLE
    PS> $contentModelC = Merge-ContentModel $contentModelA $contentModelB
#>
function Merge-ContentModel (
    [Parameter(Mandatory=$true)]
    [ContentModel] $contentModelA,

    [Parameter(Mandatory=$true)]
    [ContentModel] $contentModelB
) {
    # Set starting state
    $i = 0
    $loadWarnings = 0
    $totalItems = $contentModelA.Content.count + $contentModelB.Content.count

    # Confirm the two configs match
    if ( -not ( $contentModelA.Config._IncludedExtensions -eq $contentModelB.Config._IncludedExtensions -or
                $contentModelA.Config._DecorateAsTags -eq $contentModelB.Config._DecorateAsTags -or
                $contentModelA.Config._FilenameFormat -eq $contentModelB.Config._FilenameFormat -or
                $contentModelA.Config._FilenameSplitter -ceq $contentModelB.Config._FilenameSplitter -or
                $contentModelA.Config._ListSplitter -ceq $contentModelB.Config._ListSplitter -or
                $contentModelA.Config._ExportFormat -eq $contentModelB.Config._ExportFormat -or
                $contentModelA.Config._FilenameFormatLock -eq $contentModelB.Config._FilenameFormatLock )) {
        Write-WarnToConsole "Cannot Merge. Source configurations do not match, abandoning action."
        return $null
    }

    # Instantiate a new ContentModel
    [ContentModel] $merge = New-ContentModel

    # Copy the config
    $merge.Config._IncludedExtensions = $contentModelA.Config._IncludedExtensions.Clone()
    $merge.Config._DecorateAsTags = $contentModelA.Config._DecorateAsTags.Clone()
    $merge.Config._FilenameFormat = $contentModelA.Config._FilenameFormat.Clone()
    $merge.Config._FilenameSplitter = $contentModelA.Config._FilenameSplitter
    $merge.Config._ListSplitter = $contentModelA.Config._ListSplitter
    $merge.Config._ExportFormat = $contentModelA.Config._ExportFormat.Clone()
    $merge.Config._FilenameFormatLock = $contentModelA.Config._FilenameFormatLock

    # Initialise the ContentModel
    $merge.Init()

    # for each file
    foreach ($item in $contentModelA.Content) {    
        
        # Show a progress bar
        Write-Progress -Activity "Cloning Source A" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $totalItems)

        # Add the content to the model
        $addedContent = $merge.AddContentToModel($item.FileName, $item.BaseName, $item.Extension)

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
    Write-Progress -Activity "Cloning Source A" -Completed
    #>

    # for each file
    foreach ($item in $contentModelB.Content) {    
        
        # Show a progress bar
        Write-Progress -Activity "Merging B Into Clone" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $totalItems)

        # Add the content to the model
        $addedContent = $merge.AddContentToModel($item.FileName, $item.BaseName, $item.Extension)

        # Add content Properties if not duplicate
        if ([ContentWarning]::DuplicateDetectedInSources -in $addedContent.Warnings) {
            if ($addedContent.AlteredBaseName -ne $item.AlteredBaseName -or
                $addedContent.PendingFilenameUpdate -ne $item.PendingFilenameUpdate -or
                $addedContent.FrameWidth -ne $item.FrameWidth -or
                $addedContent.FrameHeight -ne $item.FrameHeight -or
                $addedContent.FrameRate -ne $item.FrameRate -or
                $addedContent.BitRate -ne $item.BitRate -or
                $addedContent.TimeSpan -ne $item.TimeSpan -or
                $addedContent.Hash -ne $item.Hash) {
                
                $addedContent.AddWarning([ContentWarning]::MergeConflictsInData)
            }
            $loadWarnings++
        }
        else {
            $addedContent.AlteredBaseName = $item.AlteredBaseName
            $addedContent.PendingFilenameUpdate = $item.PendingFilenameUpdate
            $addedContent.FrameWidth = $item.FrameWidth
            $addedContent.FrameHeight = $item.FrameHeight
            $addedContent.FrameRate = $item.FrameRate
            $addedContent.BitRate = $item.BitRate
            $addedContent.TimeSpan = $item.TimeSpan
            $addedContent.Hash = $item.Hash
            foreach ($warning in $item.Warnings) { $addedContent.AddWarning($warning) }
        }

        # Increment the counter
        $i++
    
    }

    # Hide the progress bar
    Write-Progress -Activity "Merging B Into Clone" -Completed
    #>

    # Resort the list
    Write-InfoToConsole "Resorting the list"
    $comp = [ContentComparer]::new("FileName")
    $merge.Content.Sort($comp)

    if ($loadWarnings) {
        Write-InfoToConsole ""
        Write-InfoToConsole "Duplicates detected. To identify problematic content, try:"
        Add-ConsoleIndent
        Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::DuplicateDetectedInSources}"
        Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings -contains [ContentWarning]::MergeConflictsInData}"
        Write-InfoToConsole "<ContentModelVariable>.Content | Where-Object {`$_.Warnings.Count -gt 0}"
        Remove-ConsoleIndent
    }

    return $merge
}

