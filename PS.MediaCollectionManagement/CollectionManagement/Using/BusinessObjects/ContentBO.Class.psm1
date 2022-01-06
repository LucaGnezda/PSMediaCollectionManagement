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
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class ContentBO
{
    #region Properties
    [String[]] hidden $_validSeasonEpisodeRegexPatterns = @("^S[\d]+E[\d]+$", "^s[\d]+e[\d]+$", "^[\d]+X[\d]+$", "^[\d]+x[\d]+$")
    [String] hidden $_validYearRegexPattern = "^(\d\d|[12]\d\d\d)$"
    [String] hidden $_validTrackRegexPattern = "^[\d]+$"
    #endregion Properties


    #region Constructors
    #endregion Constructors


    #region Methods
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
    #endregion Methods

}
#endregion Class Definition