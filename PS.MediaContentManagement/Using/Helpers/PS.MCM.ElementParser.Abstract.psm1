#region Header
#
# About: Helper class for working with SeasonEpisode strings 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\PS.MCM.Types.psm1
#endregion Using



#region Types
#------------
#enum SeasonEpisodePattern {
#    Uppercase_S0E0 = 0
#    Lowercase_S0E0 = 1
#    Uppercase_0X0 = 2
#    Lowercase_0X0 = 3
#} 
#endregion Types


#region Class Definition
#-----------------------
class ElementParser
{
    #region Properties
    [String[]] static hidden $_validSeasonEpisodeRegexPatterns = @("^S[\d]+E[\d]+$", "^s[\d]+e[\d]+$", "^[\d]+X[\d]+$", "^[\d]+x[\d]+$")
    [String] static hidden $_validYearRegexPattern = "^(\d\d|[12]\d\d\d)$"
    [String] static hidden $_validTrackRegexPattern = "^[\d]+$"
    #endregion Properties


    #region Constructors
    # This class is intented to be used as an abstract class. However PowerShell cannot declare abstract classes, 
    # nor can it force disposal of a class. So there is no way to prevent this class being instantiated. 
    # That said, it will still work well enough if instantiated.
    #endregion Constructors


    #region Methods
    [Bool] static IsValidSeasonEpisode($s) {
        foreach ($pattern in [ElementParser]::_validSeasonEpisodeRegexPatterns) {
            if ($s -cmatch $pattern) { 
                return $true 
            }
        }
        return $false
    }

    [Bool] static IsSeasonEpisodePattern($s, [SeasonEpisodePattern] $pattern) {
        if ($s -cmatch [ElementParser]::_validSeasonEpisodeRegexPatterns[[Int]$pattern]) { 
            return $true 
        }
        return $false
    }

    [Bool] static IsValidTrackNumber($s){
        return $s -match [ElementParser]::_validTrackRegexPattern
    }

    [Bool] static IsValidYear($s){
        return $s -match [ElementParser]::_validYearRegexPattern
    }

    [System.Nullable[Int]] static GetSeason($s) {
        if (([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_S0E0)) -or 
            ([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_S0E0))) {
            return [Int](($s -split "S") -split "E")[1]
        }
        elseif (([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_0X0)) -or 
                ([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_0X0))) {
            return [Int]($s -split "X")[0]
        }
        else {
            return $null
        }
    }

    [System.Nullable[Int]] static GetEpisode($s) {
        if (([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_S0E0)) -or 
            ([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_S0E0))) {
            return [Int](($s -split "S") -split "E")[2]
        }
        elseif (([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_0X0)) -or 
                ([ElementParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_0X0))) {
            return [Int]($s -split "X")[1]
        }
        else {
            return $null
        }
    }

    [String] static SeasonEpisodeToString([Int] $season, [Int] $episode, [Int] $padSeason, [Int] $padEpisode, [SeasonEpisodePattern] $pattern) {
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

    [String] static TrackToString([Int] $track, [Int] $padTrack) {
        return ([String]$track).PadLeft($padTrack, "0")
    }
    #endregion Methods

}
#endregion Class Definition