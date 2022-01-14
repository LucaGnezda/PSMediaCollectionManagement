#region Header
#
# About: Pseudo Interface 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\..\..\Shared\Using\Base\IsInterface.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IStringSimilarityProvider : IsInterface {
    IStringSimilarityProvider () {
        $this.AssertAsInterface([IStringSimilarityProvider])
    }

    # Prototypes
    [Double] GetNormalisedDistanceBetween([String] $s1, [String] $s2) { return $null }
    [Double] GetNormalisedDistanceBetween([String] $s1, [String] $s2, [Bool] $caseSensitive) { return $null }
    [Int] GetRawDistanceBetween([String] $s1, [String] $s2) { return $null }
    [Int] GetRawDistanceBetween([String] $s1, [String] $s2, [Bool] $caseSensitive) { return $null }
}

