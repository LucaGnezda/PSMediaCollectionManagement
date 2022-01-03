#region Header
#
# About: Content class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\ModuleBehaviour\CollectionManagementDefaults.Abstract.psm1
using module .\Actor.Class.psm1
using module .\Album.Class.psm1
using module .\Artist.Class.psm1
using module .\Series.Class.psm1
using module .\Studio.Class.psm1
using module .\ContentModelConfig.Class.psm1
using module .\..\Helpers\ContentSubjectParser.Abstract.psm1
using module .\..\..\..\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Abstract.psm1
#endregion Using



#region Class Definition
#-----------------------
class Content {
    
    #region Properties
    [String]                    $FileName
    [String]                    $BaseName
    [Bool]                      $AlteredBaseName
    [Bool]                      $PendingFilenameUpdate
    [String]                    $Extension
    [System.Nullable[Int]]      $FrameWidth
    [System.Nullable[Int]]      $FrameHeight
    [String]                    $FrameRate
    [String]                    $BitRate
    [System.Nullable[TimeSpan]] $TimeSpan
    [System.Collections.Generic.List[ContentWarning]] $Warnings
    [ContentModelConfig]        $_Config
    [String]                    $Title
    [String]                    $Hash
    [System.Collections.Generic.List[Actor]] $Actors
    [System.Collections.Generic.List[Artist]] $Artists
    [Studio]                    $ProducedBy
    [Series]                    $FromSeries
    [Album]                     $OnAlbum            
    [System.Nullable[Int]]      $Season
    [System.Nullable[Int]]      $Episode
    [String]                    $SeasonEpisode
    [System.Nullable[Int]]      $Track
    [String]                    $TrackLabel
    [System.Nullable[Int]]      $Year

    #endregion Properties


    #region Constructors
    Content(
        [String] $fileName,
        [String] $baseName,
        [String] $extension,
        [ContentModelConfig] $config
    ){
        $this.Init($fileName, $baseName, $extension, $config)
    }
    
    [void] Hidden Init(
        [String]                    $fileName,
        [String]                    $baseName,
        [String]                    $extension,
        [ContentModelConfig]        $config
    ) {
        $this.FileName = $fileName
        $this.BaseName = $baseName
        $this.AlteredBaseName = $false
        $this.PendingFilenameUpdate = $false
        $this.Extension = $extension
        $this.Warnings = [System.Collections.Generic.List[ContentWarning]]::new()
        $this._Config = $config
        $this.Title = ""
        $this.FrameWidth = $null
        $this.FrameHeight = $null
        $this.FrameRate = $null
        $this.TimeSpan = $null
        $this.BitRate = $null
        $this.Hash = $null
        $this.Season = $null
        $this.Episode = $null
        $this.SeasonEpisode = ""
        $this.Track = $null
        $this.TrackLabel = ""
        $this.Year = $null

        # Set starting state
        [System.Array]$splitBaseName = [System.Array]($baseName -split $config.FilenameSplitter).Trim()

        [Int] $titleSplitIndex = -1
        [Int] $actorsSplitIndex = -1
        [Int] $albumSplitIndex = -1
        [Int] $artistsSplitIndex = -1
        [Int] $seasonEpisodeSplitIndex = -1
        [Int] $seriesSplitIndex = -1
        [Int] $studioSplitIndex = -1
        [Int] $trackSplitIndex = -1
        [Int] $yearSplitIndex = -1

        [Bool] $basenameUpdateNeeded = $false

        if ($splitBaseName.Count -ne $config.FilenameFormat.Count) {
 
            # Note warning to console and add to Warnings List
            Write-WarnToConsole "Warning: file with a non-compliant filename detected, performing a partial load."
            $this.AddWarning([ContentWarning]::NonCompliantFilename)
            $this.AddWarning([ContentWarning]::PartialLoad)
        
        }
        else { 

            # get the indexes needed for initialisation
            $titleSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Title)
            $actorsSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Actors)
            $albumSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Album)
            $artistsSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Artists)
            $seasonEpisodeSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::SeasonEpisode)
            $seriesSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Series)
            $studioSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Studio)
            $trackSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Track)
            $yearSplitIndex = ([System.Array]$this._Config.FilenameFormat).IndexOf([FilenameElement]::Year)

            # If present, set the title
            if ($titleSplitIndex -ge 0) {
                $titleElement = $splitBaseName[$titleSplitIndex].Trim()
                if ($titleElement -in $config.DecorateAsTags){
                    $titleElement = "<" + $titleElement + ">"
                }
                $this.Title = $titleElement
            }

            # If present, set the season and episode
            if ($seasonEpisodeSplitIndex -ge 0) {
                if ([ContentSubjectParser]::IsValidSeasonEpisode($splitBaseName[$seasonEpisodeSplitIndex].Trim())) {
                    
                    $this.Season = [ContentSubjectParser]::GetSeason($splitBaseName[$seasonEpisodeSplitIndex].Trim())
                    $this.Episode = [ContentSubjectParser]::GetEpisode($splitBaseName[$seasonEpisodeSplitIndex].Trim())
                    $this.SeasonEpisode = $splitBaseName[$seasonEpisodeSplitIndex].Trim()
                }
                else {
                    $this.Season = $null
                    $this.Episode = $null
                    $this.SeasonEpisode = ""
                    $this.AddWarning([ContentWarning]::NonCompliantFilename)
                    $this.AddWarning([ContentWarning]::PartialLoad)
                }
            }

            # If present, set the track number
            if ($trackSplitIndex -ge 0) {
                if ([ContentSubjectParser]::IsValidTrackNumber($splitBaseName[$trackSplitIndex].Trim())) {
                    $this.Track = [Int]$splitBaseName[$trackSplitIndex].Trim()
                    $this.TrackLabel = $splitBaseName[$trackSplitIndex].Trim()
                }
                else {
                    $this.Track = $null
                    $this.TrackLabel = ""
                    $this.AddWarning([ContentWarning]::NonCompliantFilename)
                    $this.AddWarning([ContentWarning]::PartialLoad)
                }
            }

            # If present, set the year
            if ($yearSplitIndex -ge 0) {
                if ([ContentSubjectParser]::IsValidYear($splitBaseName[$trackSplitIndex].Trim())) {
                    $this.Year = [Int]$splitBaseName[$trackSplitIndex].Trim()
                }
                else {
                    $this.Year = $null
                    $this.AddWarning([ContentWarning]::NonCompliantFilename)
                    $this.AddWarning([ContentWarning]::PartialLoad)
                }
            }

            # If required, instantiate the Actors Generic List and add Members 
            if ($actorsSplitIndex -ge 0) {
                $this.Actors = [System.Collections.Generic.List[Actor]]::new()

                Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name SortedBy -Value { 
                    param ([String[]] $property)  return ($this | Sort-Object $property)
                } -Force

                Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name Matching -value {
                    param ([String] $s)
                    return ($this | Where-Object {$_.Name -match $s})
                } -Force

                Add-Member -InputObject $this.Actors -MemberType ScriptMethod -Name GetByName -value {
                    param ([String] $s)
                    return ($this | Where-Object {$_.Name -ceq $s})
                } -Force
            }

            # If required, instantiate the Artists Generic List and add Members 
            if ($artistsSplitIndex -ge 0) {
                $this.Artists = [System.Collections.Generic.List[Artist]]::new()

                Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name SortedBy -Value { 
                    param ([String[]] $property)  return ($this | Sort-Object $property)
                } -Force

                Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name Matching -value {
                    param ([String] $s)
                    return ($this | Where-Object {$_.Name -match $s})
                } -Force

                Add-Member -InputObject $this.Artists -MemberType ScriptMethod -Name GetByName -value {
                    param ([String] $s)
                    return ($this | Where-Object {$_.Name -ceq $s})
                } -Force
            }
        }

        # Add an accessor (getter)
        $this | Add-Member -Name "Duration" -MemberType ScriptProperty -Value {
            if ($this.TimeSpan -eq 0) {
                return $null
            }
            else {
                return $this.TimeSpan.ToString()
            }
        } -Force

        # Set the detault table column order
        $DefaultProps = [System.Collections.Generic.List[String]]@("FileName", "BaseName", "Extension", "Warnings", "AlteredBaseName", "PendingFilenameUpdate", "Title", "FrameWidth", "FrameHeight", "FrameRate", "BitRate", "Duration", "TimeSpan", "Hash")
        if ($seasonEpisodeSplitIndex -ge 0) {
            $DefaultProps.Add("Season")
            $DefaultProps.Add("Episode") 
            $DefaultProps.Add("SeasonEpisode")  
        }
        if ($trackSplitIndex -ge 0) { 
            $DefaultProps.Add("Track")
            $DefaultProps.Add("TrackLabel")
        }
        if ($yearSplitIndex -ge 0) { $DefaultProps.Add("Year") }
        if ($actorsSplitIndex -ge 0) { $DefaultProps.Add("Actors") }
        if ($artistsSplitIndex -ge 0) { $DefaultProps.Add("Artists") }
        if ($studioSplitIndex -ge 0) { $DefaultProps.Add("ProducedBy") }
        if ($seriesSplitIndex -ge 0) { $DefaultProps.Add("FromSeries") }
        if ($albumSplitIndex -ge 0) { $DefaultProps.Add("OnAlbum") }
        $DefaultProps = $DefaultProps.ToArray() 
        $DefaultDisplay = New-Object System.Management.Automation.PSPropertySet("DefaultDisplayPropertySet",[string[]]$DefaultProps)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($DefaultDisplay)
        $this | Add-Member MemberSet PSStandardMembers $PSStandardMembers

        # Update the basename if needed
        if ($basenameUpdateNeeded) {
            $this.UpdateContentBaseName()
        }
    }
    #endregion Constructors



    #region Public Methods
    [String] ToString() {
        return $this.Title
    }

    [Void] UpdateContentBaseName() {
    
        [String] $newBaseName = ""

        foreach ($element in $this._Config.FilenameFormat) {

            if ($newBaseName.Length -gt 0) {
                $newBaseName = $newBaseName + $this._Config.FilenameSplitter
            }

            switch ($element) {
                {$_ -eq [FilenameElement]::Actors} {

                    $newBaseName = $newBaseName + ($this.Actors.Name -Join $this._Config.ListSplitter)
                    break
                }
                {$_ -eq [FilenameElement]::Album} {
                
                    $newBaseName = $newBaseName + $this.OnAlbum.Name
                    break
                }
                {$_ -eq [FilenameElement]::Artists} {
                
                    $newBaseName = $newBaseName + ($this.Artists.Name -Join $this._Config.ListSplitter)
                    break
                }
                {$_ -eq [FilenameElement]::SeasonEpisode} {
                
                    $newBaseName = $newBaseName + $this.SeasonEpisode
                    break
                }
                {$_ -eq [FilenameElement]::Series} {
                
                    $newBaseName = $newBaseName + $this.FromSeries.Name
                    break
                }
                {$_ -eq [FilenameElement]::Studio} {
                
                    $newBaseName = $newBaseName + $this.ProducedBy.Name
                    break
                }
                {$_ -eq [FilenameElement]::Title} {
                
                    $newBaseName = $newBaseName + $this.Title
                    break
                }
                {$_ -eq [FilenameElement]::Track} {
                
                    $newBaseName = $newBaseName + $this.TrackLabel
                    break
                }
                {$_ -eq [FilenameElement]::Year} {
                
                    $newBaseName = $newBaseName + $this.Year
                    break
                }
                default {
                    # Do nothing
                }
                
            } 
        }


        # Apply the new basename
        $this.BaseName = $newBaseName
        $this.AlteredBaseName = $true
        $this.PendingFilenameUpdate = $true
    }

    [Bool] UpdateFileName() {
        
        # If change pending and the file exists
        if ($this.PendingFilenameUpdate -eq $true -and $this.FileExists()) {
            # Generate the new filename
            $newFileName = ($this.BaseName + $this.Extension) 

            # Attempt to apply the new filename and update properties if successful
            if (Rename-File $this.FileName $newFileName) {
                $this.FileName = $newFileName
                $this.PendingFilenameUpdate = $false
                return $true
            }
        }
        else {
            Write-WarnToConsole "Warning: No such file exists, abandoning operation."
        }
        return $false
    }

    [Bool] FileExists() {
        return Test-Path $this.FileName
    }

    [Void] FillPropertiesWhereMissing() {    
        $this.FillPropertiesWhereMissing($false)
    }
    
    [Void] FillPropertiesWhereMissing([Bool] $silently) {
        $this.FillPropertiesWhereMissing($null, $silently)
    }

    [Void] FillPropertiesWhereMissing([System.IO.FileInfo] $file) {
        $this.FillPropertiesWhereMissing($file, $false)
    }

    [Void] FillPropertiesWhereMissing([System.IO.FileInfo] $file, [Bool] $silently) {
        
        # If we don't have a COM Shell, instantiate one. If we do remember so we can dispose it when done.
        $disposeWhenDone = [FilesystemExtensionsState]::InstantiateShell()

        if ($null -eq $file) { 
            $file = Get-ChildItem $this.FileName -ErrorAction SilentlyContinue
        }

        # try to load
        try {

            # Load relevant properties for file type
            switch ($this.Extension) {
                {$_ -in [CollectionManagementDefaults]::DEFAULT_VIDEO_EXTENSIONS()} {

                    if ($null -eq $this.FrameWidth) {
                        $this.FrameWidth = (Get-FileMetadata $file 316).Value
                    }

                    if ($null -eq $this.FrameHeight) { 
                        $this.FrameHeight = (Get-FileMetadata $file 314).Value
                    }

                    if ([String]::IsNullOrEmpty($this.FrameRate)) {
                        $this.FrameRate = (Get-FileMetadata $file 315).Value
                    }

                    if ($null -eq $this.TimeSpan) {
                        $this.TimeSpan = [TimeSpan](Get-FileMetadata $file 27).Value
                    }

                    if ([String]::IsNullOrEmpty($this.BitRate)) {
                        $this.BitRate = (Get-FileMetadata $file 320).Value
                    }

                    break
                }
                {$_ -in [CollectionManagementDefaults]::DEFAULT_AUDIO_EXTENSIONS()} {
                
                    if ($null -eq $this.TimeSpan) {
                        $this.TimeSpan = [TimeSpan](Get-FileMetadata $file 27).Value
                    }

                    if ([String]::IsNullOrEmpty($this.BitRate)) {
                        $this.BitRate = (Get-FileMetadata $file 28).Value
                    }

                    break
                }
                default {
                    if (-not $silently) {
                        Write-WarnToConsole "Warning: Unsupported file extension detected, unable to load properties." ($null -eq $file)
                    }
                    $this.AddWarning([ContentWarning]::UnsupportedFileExtension)
                    $this.AddWarning([ContentWarning]::ErrorLoadingProperties)
                }
                
            }
        }
        catch {
            # Check we have a file
            if ($null -eq $file) {
                if (-not $silently) {
                    Write-WarnToConsole "Warning: File does not exist, unable to load properties."
                }
                $this.AddWarning([ContentWarning]::FileNotFound)
            }
            else {
                if (-not $silently) {
                    Write-ErrorToConsole "Unexpected Error: Unable to load properties."
                }
            }
            $this.AddWarning([ContentWarning]::ErrorLoadingProperties)
        }

        if ($disposeWhenDone) {
            [FilesystemExtensionsState]::DisposeCurrentShellIfPresent()
        }

        return
    }

    [Void] GenerateHashIfMissing() {
        $this.GenerateHashIfMissing($false)
    }

    [Void] GenerateHashIfMissing([Bool] $silently) {
        $this.GenerateHashIfMissing($null, $silently)
    }

    [Void] GenerateHashIfMissing([System.IO.FileInfo] $file) {
        $this.GenerateHashIfMissing($file, $false)
    }

    [Void] GenerateHashIfMissing([System.IO.FileInfo] $file, [Bool] $silently) {
        
        if ($null -eq $file) { 
            $file = Get-ChildItem $this.FileName -ErrorAction SilentlyContinue
        }

        # try to generate
        try {
            if ([String]::IsNullOrEmpty($this.Hash)) {
                if ($null -eq $file) { Get-ChildItem $this.FileName }
                $this.Hash = (Get-FileHash $file.FullName -Algorithm MD5).Hash
            }
        }
        catch {
             # Check we have a file
            if ($null -eq $file) {
                if (-not $silently) {
                    Write-WarnToConsole "Warning: File does not exist, unable to generate hash."
                }
                $this.AddWarning([ContentWarning]::FileNotFound)
            }
            else {
                if (-not $silently) {
                    Write-ErrorToConsole "Unexpected Error: Unable to generate hash."
                }
            }
            $this.AddWarning([ContentWarning]::ErrorLoadingProperties)
        }
        return
    }

    [Bool] CheckFilesystemHash() {
        
        if ([String]::IsNullOrEmpty($this.Hash)) {
            Write-WarnToConsole "Warning: No Hash is availabile for this content, unable to verify."
            return $true
        }

        $file = Get-ChildItem $this.FileName

        if ($null -eq $file) {
            Write-WarnToConsole "Warning: File not found, unable to verify."
            return $true
        }

        $currentFilesystemHash = (Get-FileHash $file.FullName -Algorithm MD5).Hash
        
        if ($currentFilesystemHash -eq $this.Hash) {
            return $true
        }
        else {
            return $false
        }
    }

    [Void] AddWarning([ContentWarning] $warning) {
        if ($warning -notin $this.Warnings){
            $this.Warnings.Add($warning)
        }
    }

    [Void] ClearWarnings() {
        $this.Warnings.Clear()
    }
    #endregion Public Methods


    #region Hidden Methods
    [Object] Hidden GetCollectionByType ([FilenameElement] $filenameElement) {

        switch ($filenameElement) {
            {$_ -eq [FilenameElement]::Actors} {
                return $this.Actors
                break
            }
            {$_ -eq [FilenameElement]::Album} {
                return $this.OnAlbum
                break
            }
            {$_ -eq [FilenameElement]::Artists} {
                return $this.Artists
                break
            }
            {$_ -eq [FilenameElement]::Series} {
                return $this.FromSeries
                break
            }
            {$_ -eq [FilenameElement]::Studio} {
                return $this.ProducedBy
                break
            }
            default {
                # Do nothing
            }
        }
        return $null
    }
    #endregion Hidden Methods

}
#endregion Class Definition