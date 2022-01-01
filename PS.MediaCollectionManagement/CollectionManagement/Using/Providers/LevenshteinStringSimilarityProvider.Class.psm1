#region Header
#
# About: Provider for testing string similarity 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
# Credits: Thanks to Øyvind Kallstad for the implementation, on which this class has been derived.
#          https://github.com/gravejester/Communary.PASM 
#
# Further Reading: This class implements the Levenshtein distance calculation. Please refer to:
#                  https://en.wikipedia.org/wiki/Edit_distance
#                  http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#C.23
# 
#endregion Header


#region Using
#------------
using module .\..\Interfaces\IStringSimilarityProvider.Interface.psm1
#endregion Using


#region Class Definition
#-----------------------
class LevenshteinStringSimilarityProvider : IStringSimilarityProvider {

    #region Properties
    [Double[]] Hidden $_sensitivityBandBoundaries
    
    #endregion Properties


    #region Constructors
    LevenshteinStringSimilarityProvider () {}
    #endregion Constructors
    
    
    #region Methods
    [Double] GetNormalisedDistanceBetween([String] $s1, [String] $s2) {
        return [Double]([Double]$this.GetLevenshteinDistanceBetween($s1, $s2, $false) / [Double]([Math]::Max($s1.Length,$s2.Length)))
    }

    [Double] GetNormalisedDistanceBetween([String] $s1, [String] $s2, [Bool] $caseSensitive) {
        return [Double]([Double]$this.GetLevenshteinDistanceBetween($s1, $s2, $caseSensitive) / [Double]([Math]::Max($s1.Length,$s2.Length)))
    }

    [Int] GetRawDistanceBetween([String] $s1, [String] $s2) {
        return $this.GetLevenshteinDistanceBetween($s1, $s2, $false)
    }

    [Int] GetRawDistanceBetween([String] $s1, [String] $s2, [Bool] $caseSensitive) {
        return $this.GetLevenshteinDistanceBetween($s1, $s2, $caseSensitive)
    }

    [Int] Hidden GetLevenshteinDistanceBetween([String] $s1, [String] $s2, [Bool] $caseSensitive) {
        
        if (-not($caseSensitive)) {
            $s1 = $s1.ToLowerInvariant()
            $s1 = $s1.ToLowerInvariant()
        }
    
        [Int[,]] $d = [Int[,]]::new($s1.Length + 1, $s2.Length + 1)
    
        for ($i = 0; $i -le $d.GetUpperBound(0); $i++) {
            $d[$i,0] = $i
        }

        for ($i = 0; $i -le $d.GetUpperBound(1); $i++) {
            $d[0,$i] = $i
        }

        for ($i = 1; $i -le $d.GetUpperBound(0); $i++) {
            for ($j = 1; $j -le $d.GetUpperBound(1); $j++) {
                $cost = [Convert]::ToInt32((-not($s1[$i-1] -ceq $s2[$j-1])))
                $min1 = $d[($i-1),$j] + 1
                $min2 = $d[$i,($j-1)] + 1
                $min3 = $d[($i-1),($j-1)] + $cost
                $d[$i,$j] = [Math]::Min([Math]::Min($min1,$min2),$min3)
            }
        }

        return ($d[$d.GetUpperBound(0),$d.GetUpperBound(1)])
    }

    #endregion Methods
}
#endregion Class Definition