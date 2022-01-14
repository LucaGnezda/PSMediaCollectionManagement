#region Header
#
# About: Class for working with content objects 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\ObjectModels\Content.Class.psm1
using module .\..\ObjectModels\ContentModelConfig.Class.psm1
using module .\..\ModuleBehaviour\CollectionManagementDefaults.Abstract.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class ContentBO
{
    #region Properties
    [String[]] Hidden $_validSeasonEpisodeRegexPatterns = @("^S[\d]+E[\d]+$", "^s[\d]+e[\d]+$", "^[\d]+X[\d]+$", "^[\d]+x[\d]+$")
    [String] Hidden $_validYearRegexPattern = "^(\d\d|[12]\d\d\d)$"
    [String] Hidden $_validTrackRegexPattern = "^[\d]+$"
    [ContentModelConfig] $Config

    #endregion Properties


    #region Constructors
    ContentBO([ContentModelConfig] $config) {
        if (-not $config.IsFilenameFormatLocked) {
            throw [System.InvalidOperationException] "System.InvalidOperationException: ContentBO Cannot be instantiated successfully a without a committed Filename Format."
        }
        $this.Config = $config
    }
    #endregion Constructors


    #region Methods
    [Content] CreateContentObject([String] $filename, [String] $basename, [String] $extension) {

        [Content] $newContent = [Content]::new([String] $filename,
                                               $basename,
                                               $extension, 
                                               $this.Config.IncludeTitle, 
                                               $this.Config.IncludeActors, 
                                               $this.Config.IncludeAlbum, 
                                               $this.Config.IncludeArtists, 
                                               $this.Config.IncludeSeries, 
                                               $this.Config.IncludeStudio, 
                                               $this.Config.IncludeSeasonEpisode, 
                                               $this.Config.IncludeTrack, 
                                               $this.Config.IncludeYear)

        # Set starting state
        if ($this.Config.FilenameSplitter.Length -eq 0) {
            [System.Array]$splitBaseName = @($baseName)
        }
        else {
            [System.Array]$splitBaseName = [System.Array]($baseName -split $this.Config.FilenameSplitter).Trim()
        }

        if ($splitBaseName.Count -ne $this.Config.FilenameFormat.Count) {
 
            # Note warning to console and add to Warnings List
            Write-WarnToConsole "Warning: file with a non-compliant filename detected, performing a partial load."
            $newContent.AddWarning([ContentWarning]::NonCompliantFilename)
            $newContent.AddWarning([ContentWarning]::SubjectInfoSkipped)
        }
        else {

            # If included, set the title
            if ($this.Config.IncludeTitles) {
                $titleElement = $splitBaseName[$this.Config.TitleSplitIndex].Trim()
                if ($titleElement -in $this.Config.DecorateAsTags){
                    $titleElement = $this.Config.TagOpenDelimiter + $titleElement + $this.Config.TagCloseDelimiter
                }
                $newContent.Title = $titleElement
            }

            # If included, set the season and episode
            if ($this.Config.IncludeSeasonEpisodes) {
                if ($this.IsValidSeasonEpisode($splitBaseName[$this.Config.SeasonEpisodeSplitIndex].Trim())) {
                    
                    $newContent.Season = $this.GetSeasonFromString($splitBaseName[$this.Config.SeasonEpisodeSplitIndex].Trim())
                    $newContent.Episode = $this.GetEpisodeFromString($splitBaseName[$this.Config.SeasonEpisodeSplitIndex].Trim())
                    $newContent.SeasonEpisode = $splitBaseName[$this.Config.SeasonEpisodeSplitIndex].Trim()
                }
                else {
                    $newContent.Season = $null
                    $newContent.Episode = $null
                    $newContent.SeasonEpisode = ""
                    $newContent.AddWarning([ContentWarning]::NonCompliantFilename)
                    $newContent.AddWarning([ContentWarning]::SubjectInfoNotFullyLoaded)
                }
            }

            # If included, set the track number
            if ($this.Config.IncludeTracks) {
                if ($this.IsValidTrackNumber($splitBaseName[$this.Config.TrackSplitIndex].Trim())) {
                    $newContent.Track = [Int]$splitBaseName[$this.Config.TrackSplitIndex].Trim()
                    $newContent.TrackLabel = $splitBaseName[$this.Config.TrackSplitIndex].Trim()
                }
                else {
                    $newContent.Track = $null
                    $newContent.TrackLabel = ""
                    $newContent.AddWarning([ContentWarning]::NonCompliantFilename)
                    $newContent.AddWarning([ContentWarning]::SubjectInfoNotFullyLoaded)
                }
            }

            # If included, set the year
            if ($this.Config.IncludeYears) {
                if ($this.IsValidYear($splitBaseName[$this.Config.YearSplitIndex].Trim())) {
                    $newContent.Year = [Int]$splitBaseName[$this.Config.YearSplitIndex].Trim()
                }
                else {
                    $newContent.Year = $null
                    $newContent.AddWarning([ContentWarning]::NonCompliantFilename)
                    $newContent.AddWarning([ContentWarning]::SubjectInfoNotFullyLoaded)
                }
            }
        }
        return $newContent
    }

    [Bool] IsValidSeasonEpisode($s) {
        foreach ($pattern in $this._validSeasonEpisodeRegexPatterns) {
            if ($s -cmatch $pattern) { 
                return $true 
            }
        }
        return $false
    }

    [Bool] IsSeasonEpisodePattern($s, [SeasonEpisodePattern] $pattern) {
        if ($s -cmatch $this._validSeasonEpisodeRegexPatterns[[Int]$pattern]) { 
            return $true 
        }
        return $false
    }

    [Bool] IsValidTrackNumber($s){
        return $s -match $this._validTrackRegexPattern
    }

    [Bool] IsValidYear($s){
        return $s -match $this._validYearRegexPattern
    }

    [System.Nullable[Int]] GetSeasonFromString($s) {
        if (($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_S0E0)) -or 
            ($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_S0E0))) {
            return [Int](($s -split "S") -split "E")[1]
        }
        elseif (($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_0X0)) -or 
                ($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_0X0))) {
            return [Int]($s -split "X")[0]
        }
        else {
            return $null
        }
    }

    [System.Nullable[Int]] GetEpisodeFromString($s) {
        if (($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_S0E0)) -or 
            ($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_S0E0))) {
            return [Int](($s -split "S") -split "E")[2]
        }
        elseif (($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_0X0)) -or 
                ($this.IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_0X0))) {
            return [Int]($s -split "X")[1]
        }
        else {
            return $null
        }
    }

    [String] SeasonEpisodeToString([Int] $season, [Int] $episode, [Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern) {
        switch ($pattern) {
            {$_ -eq [SeasonEpisodePattern]::Uppercase_S0E0} {
                return ("S" + ([String]$season).PadLeft($padSeason, "0") + "E" + ([String]$episode).PadLeft($padEpisode, "0"))
                break
            }
            {$_ -eq [SeasonEpisodePattern]::Lowercase_S0E0} {
                return ("s" + ([String]$season).PadLeft($padSeason, "0") + "e" + ([String]$episode).PadLeft($padEpisode, "0"))
                break
            }
            {$_ -eq [SeasonEpisodePattern]::Uppercase_0X0} {
                return (([String]$season).PadLeft($padSeason, "0") + "X" + ([String]$episode).PadLeft($padEpisode, "0"))
                break
            }
            {$_ -eq [SeasonEpisodePattern]::Lowercase_0X0} {
                return (([String]$season).PadLeft($padSeason, "0") + "x" + ([String]$episode).PadLeft($padEpisode, "0"))
                break
            }
            Default {
                # Do nothing
            }
        }
        return ""
    }

    [String] TrackToString([Int] $track, [Int] $padTrack) {
        return ([String]$track).PadLeft($padTrack, "0")
    }

    [Void] AddContentToModel([System.Collections.Generic.List[Content]] $contentList, [Content] $contentToAdd) {
        $contentList.Add($contentToAdd)
    }

    [Void] RemoveContentFromModel([System.Collections.Generic.List[Content]] $contentList, [Content] $contentToRemove) {
        $contentList.Remove($contentToRemove)
    }

    [Void] UpdateContentBaseName([Content] $content) {

        [String] $newBaseName = ""

        foreach ($element in $this.Config.FilenameFormat) {

            if ($newBaseName.Length -gt 0) {
                $newBaseName = $newBaseName + $this.Config.FilenameSplitter
            }

            switch ($element) {
                {$_ -eq [FilenameElement]::Actors} {

                    $newBaseName = $newBaseName + ($content.Actors.Name -Join $this.Config.ListSplitter)
                    break
                }
                {$_ -eq [FilenameElement]::Album} {
                
                    $newBaseName = $newBaseName + $content.OnAlbum.Name
                    break
                }
                {$_ -eq [FilenameElement]::Artists} {
                
                    $newBaseName = $newBaseName + ($content.Artists.Name -Join $this.Config.ListSplitter)
                    break
                }
                {$_ -eq [FilenameElement]::SeasonEpisode} {
                
                    $newBaseName = $newBaseName + $content.SeasonEpisode
                    break
                }
                {$_ -eq [FilenameElement]::Series} {
                
                    $newBaseName = $newBaseName + $content.FromSeries.Name
                    break
                }
                {$_ -eq [FilenameElement]::Studio} {
                
                    $newBaseName = $newBaseName + $content.ProducedBy.Name
                    break
                }
                {$_ -eq [FilenameElement]::Title} {
                
                    $newBaseName = $newBaseName + $content.Title
                    break
                }
                {$_ -eq [FilenameElement]::Track} {
                
                    $newBaseName = $newBaseName + $content.TrackLabel
                    break
                }
                {$_ -eq [FilenameElement]::Year} {
                
                    $newBaseName = $newBaseName + $content.Year
                    break
                }
                default {
                    # Do nothing
                }   
            } 
        }

        # Apply the new basename
        $content.BaseName = $newBaseName
        $content.AlteredBaseName = $true
        $content.PendingFilenameUpdate = $true
    }

    [Bool] UpdateFileName([Content] $content) {
    
        # If change pending and the file exists
        if ($content.PendingFilenameUpdate -eq $true -and $this.FileExists($content)) {
            # Generate the new filename
            $newFileName = ($content.BaseName + $content.Extension) 

            # Attempt to apply the new filename and update properties if successful
            if (Rename-File $content.FileName $newFileName) {
                $content.FileName = $newFileName
                $content.PendingFilenameUpdate = $false
                return $true
            }
        }
        else {
            Write-WarnToConsole "Warning: No such file exists, abandoning operation."
        }
        return $false
    }

    [Bool] InstantiatePersistantFilesystemShellIfNotPresent() {
        return Initialize-PersistentFilesystemShell
    }

    [Bool] IsFilesystemShellInstantiated() {
        return Test-PersistentFilesystemShellExistence
    }

    [Void] DisposePersistantFilesystemShellIfPresent() {
        Remove-PersistentFilesystemShell
    }

    [Bool] FileExists([Content] $content) {
        return Test-Path $content.FileName
    }

    [Void] FillPropertiesWhereMissing([Content] $content, [System.IO.FileInfo] $file, [Bool] $silently) {
        
        # If we don't have a COM Shell, instantiate one. If we do remember so we can dispose it when done.
        $disposeWhenDone = $this.InstantiatePersistantFilesystemShellIfNotPresent()

        if ($null -eq $file) { $file = Get-ChildItem -File $content.FileName -ErrorAction SilentlyContinue }

        # try to load
        try {

            # Load relevant properties for file type
            switch ($content.Extension) {
                {$_ -in [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()} {

                    if ($null -eq $content.FrameWidth) {
                        $content.FrameWidth = (Get-FileMetadata $file 316).Value
                    }

                    if ($null -eq $content.FrameHeight) { 
                        $content.FrameHeight = (Get-FileMetadata $file 314).Value
                    }

                    if ([String]::IsNullOrEmpty($content.FrameRate)) {
                        $content.FrameRate = (Get-FileMetadata $file 315).Value
                    }

                    if ($null -eq $content.TimeSpan) {
                        $content.TimeSpan = [TimeSpan](Get-FileMetadata $file 27).Value
                    }

                    if ([String]::IsNullOrEmpty($content.BitRate)) {
                        $content.BitRate = (Get-FileMetadata $file 320).Value
                    }

                    if (($null -eq $content.FrameWidth) -or 
                        ($null -eq $content.FrameHeight) -or 
                        ([String]::IsNullOrEmpty($content.FrameRate)) -or
                        ($null -eq $content.TimeSpan) -or
                        ([String]::IsNullOrEmpty($content.BitRate))) {
                        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
                    }
                    else {
                        $content.ClearWarning([ContentWarning]::PropertyInfoLoadingError)
                        $content.ClearWarning([ContentWarning]::PropertyInfoFileNotFound)
                        $content.ClearWarning([ContentWarning]::PropertyInfoUnsupportedFileExtension)
                    }

                    break
                }
                {$_ -in [CollectionManagementDefaults]::DEFAULT_AUDIO_EXTENSIONS()} {
                
                    if ($null -eq $content.TimeSpan) {
                        $content.TimeSpan = [TimeSpan](Get-FileMetadata $file 27).Value
                    }

                    if ([String]::IsNullOrEmpty($content.BitRate)) {
                        $content.BitRate = (Get-FileMetadata $file 28).Value
                    }

                    if (($null -eq $content.TimeSpan) -or
                        ([String]::IsNullOrEmpty($content.BitRate))) {
                        $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
                    }
                    else {
                        $content.ClearWarning([ContentWarning]::PropertyInfoLoadingError)
                        $content.ClearWarning([ContentWarning]::PropertyInfoFileNotFound)
                        $content.ClearWarning([ContentWarning]::PropertyInfoUnsupportedFileExtension)
                    }

                    break
                }
                default {
                    if (-not $silently) {
                        Write-WarnToConsole "Warning: Unsupported file extension detected, unable to load properties." ($null -eq $file)
                    }
                    $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
                    $content.AddWarning([ContentWarning]::PropertyInfoUnsupportedFileExtension)
                } 
            }
        }
        catch {
            # Check we have a file
            if ($null -eq $file) {
                if (-not $silently) {
                    Write-WarnToConsole "Warning: File does not exist, unable to load properties."
                }
                $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
                $content.AddWarning([ContentWarning]::PropertyInfoFileNotFound)
            }
            else {
                if (-not $silently) {
                    Write-ErrorToConsole "Unexpected Error: Unable to load properties."
                }
                $content.AddWarning([ContentWarning]::PropertyInfoLoadingError)
            }
        }

        if ($disposeWhenDone) {
            $this.DisposePersistantFilesystemShellIfPresent()
        }

        return
    }

    [Void] GenerateHashIfMissing([Content] $content, [System.IO.FileInfo] $file, [Bool] $silently) {

        if ($null -eq $file) { $file = Get-ChildItem -File $content.FileName -ErrorAction SilentlyContinue }

        # try to generate
        try {
            if ([String]::IsNullOrEmpty($content.Hash)) {
                if ($null -eq $file) { Get-ChildItem $content.FileName }
                $content.Hash = (Get-FileHash $file.FullName -Algorithm MD5).Hash

                if ($null -eq $content.Hash) {
                    $content.AddWarning([ContentWarning]::HashLoadingError)
                }
                else {
                    $content.ClearWarning([ContentWarning]::HashLoadingError)
                }
            }
        }
        catch {
            # Check we have a file
            if ($null -eq $file) {
                if (-not $silently) {
                    Write-WarnToConsole "Warning: File does not exist, unable to generate hash."
                }
                $content.AddWarning([ContentWarning]::HashLoadingError)
                $content.AddWarning([ContentWarning]::HashFileNotFound)
            }
            else {
                if (-not $silently) {
                    Write-ErrorToConsole "Unexpected Error: Unable to generate hash."
                }
                $content.AddWarning([ContentWarning]::HashLoadingError)
            }
        }
        return
    }

    [Bool] CheckFilesystemHash([Content] $content, [System.IO.FileInfo] $file, [Bool] $silently) {
        
        if ([String]::IsNullOrEmpty($content.Hash)) {
            Write-WarnToConsole "Warning: No Hash is availabile for this content, unable to verify."
            return $true
        }

        # If we don't have a file object passed in, get one.
        if ($null -eq $file) { 
            $file = Get-ChildItem $content.FileName -ErrorAction SilentlyContinue
        }

        if ($null -eq $file) {
            if (-not $silently) {
                Write-WarnToConsole "Warning: File not found, unable to verify."
                return $true
            }
        }

        $currentFilesystemHash = (Get-FileHash $file.FullName -Algorithm MD5).Hash
        
        if ($currentFilesystemHash -eq $content.Hash) {
            return $true
        }
        else {
            return $false
        }
    }

    [System.Array] GetFilesForModel () {
        # read the filesystem
        if ($this.Config.IncludedExtensions.Count -eq 0) {
            return Get-ChildItem -File
        }
        else {
            return Get-ChildItem -File | Where-Object {$_.Extension -in $this.Config.IncludedExtensions} 
        }
    }

    [Void] CopyPropertiesHashAndWarnings([Content] $fromContent, [Content] $toContent) {
        $toContent.AlteredBaseName = $fromContent.AlteredBaseName
        $toContent.PendingFilenameUpdate = $fromContent.PendingFilenameUpdate
        $toContent.FrameWidth = $fromContent.FrameWidth
        $toContent.FrameHeight = $fromContent.FrameHeight
        $toContent.FrameRate = $fromContent.FrameRate
        $toContent.BitRate = $fromContent.BitRate
        $toContent.TimeSpan = $fromContent.TimeSpan
        $toContent.Hash = $fromContent.Hash
        foreach ($warning in $fromContent.Warnings) { $toContent.AddWarning($warning) }
    }
    #endregion Methods

}
#endregion Class Definition