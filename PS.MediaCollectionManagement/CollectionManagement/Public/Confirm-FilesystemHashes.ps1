<#
    .SYNOPSIS
    Checks hashes of files in the filesystem against known hashes in the content model.

    .DESCRIPTION
    Checks hashes of files in the filesystem against known hashes in the content model.

    .INPUTS
    [ContentModel] ContentModel with known hashes
    [Bool] ReturnSummary (returns an array if $true)

    .OUTPUTS
    None or Array.

    .EXAMPLE
    PS> Confirm-FilesystemHashes $contentModel $false
#>
function Confirm-FilesystemHashes (
    [Parameter(Mandatory=$true)]
    [ContentModel] $contentModel,

    [Parameter(Mandatory=$false)]
    [Switch] $ReturnSummary
) {

    [System.Collections.Generic.List[Object]] $output = [System.Collections.Generic.List[Object]]::new()
    [Int] $verified = 0
    [Int] $discrepancy = 0

    # for each file
    foreach ($item in $contentModel.Content) {    
        
        # Show a progress bar
        Write-Progress -Activity "Verifying Filesystem Hashes" -Status ("Processing Item: " + ($i + 1) + " | " + $item.FileName) -PercentComplete (($i * 100) / $contentModel.Content.count)

        if ($item.CheckFilesystemHash()) {
            $outputRow = [PSCustomObject]::new()
            $outputRow | Add-Member NoteProperty "Content" $item.FileName
            $outputRow | Add-Member NoteProperty "Verified" "[X]"
            $outputRow | Add-Member NoteProperty "Color" 92 # Green

            $verified++
        }
        else {
            $outputRow = [PSCustomObject]::new()
            $outputRow | Add-Member NoteProperty "Content" $item.FileName
            $outputRow | Add-Member NoteProperty "Verified" "[X]"
            $outputRow | Add-Member NoteProperty "Color" 95 # Magenta

            $discrepancy++
        }

        $output.Add($outputRow)

        # Increment the counter
        $i++
    
    }

    # Hide the progress bar
    Write-Progress -Activity "Copying Model" -Completed

    $screenWidth = $Host.UI.RawUI.WindowSize.Width
    $filenameWidth = [Int]($screenWidth - 9) - 2

    if ($ReturnSummary.IsPresent) {
        return @($verified, $discrepancy, $contentModel.Content.Count)
    }
    else {
        Write-FormattedTableToConsole -ColumnHeadings @("Verified", "Content") -ColumnProperties @("Verified", "Content") -ColumnWidths @(9, $filenameWidth) -ColumnColors @(0, 0) -AcceptColumnColorsFromInputIfAvailable @($true, $true) -Object $output
        return
    }
}