#region Header
#
# About: Helper class for working with content descriptor strings 
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
class ContentSubjectParser
{
    #region Properties
    [String[]] static hidden $_validSeasonEpisodeRegexPatterns = @("^S[\d]+E[\d]+$", "^s[\d]+e[\d]+$", "^[\d]+X[\d]+$", "^[\d]+x[\d]+$")
    [String] static hidden $_validYearRegexPattern = "^(\d\d|[12]\d\d\d)$"
    [String] static hidden $_validTrackRegexPattern = "^[\d]+$"
    #endregion Properties


    #region Constructors
    ContentSubjectParser () {

        # Prevent instantiation of this class
        if ($this.GetType() -eq [ContentSubjectParser]) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        }
    } 
    #endregion Constructors


    #region Methods
    [Bool] static IsValidSeasonEpisode($s) {
        foreach ($pattern in [ContentSubjectParser]::_validSeasonEpisodeRegexPatterns) {
            if ($s -cmatch $pattern) { 
                return $true 
            }
        }
        return $false
    }

    [Bool] static IsSeasonEpisodePattern($s, [SeasonEpisodePattern] $pattern) {
        if ($s -cmatch [ContentSubjectParser]::_validSeasonEpisodeRegexPatterns[[Int]$pattern]) { 
            return $true 
        }
        return $false
    }

    [Bool] static IsValidTrackNumber($s){
        return $s -match [ContentSubjectParser]::_validTrackRegexPattern
    }

    [Bool] static IsValidYear($s){
        return $s -match [ContentSubjectParser]::_validYearRegexPattern
    }

    [System.Nullable[Int]] static GetSeason($s) {
        if (([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_S0E0)) -or 
            ([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_S0E0))) {
            return [Int](($s -split "S") -split "E")[1]
        }
        elseif (([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_0X0)) -or 
                ([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_0X0))) {
            return [Int]($s -split "X")[0]
        }
        else {
            return $null
        }
    }

    [System.Nullable[Int]] static GetEpisode($s) {
        if (([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_S0E0)) -or 
            ([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_S0E0))) {
            return [Int](($s -split "S") -split "E")[2]
        }
        elseif (([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Uppercase_0X0)) -or 
                ([ContentSubjectParser]::IsSeasonEpisodePattern($s, [SeasonEpisodePattern]::Lowercase_0X0))) {
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