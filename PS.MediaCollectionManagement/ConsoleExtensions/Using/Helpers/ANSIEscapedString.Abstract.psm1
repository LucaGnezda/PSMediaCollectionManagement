#region Header
#
# About: Helper class for working with ANSI escaped strings 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
#endregion Using



#region Class Definition
#-----------------------
class ANSIEscapedString
{
    #region Properties
    [String] static hidden $_e = [Char]27
    [String] static hidden $_escapeRegex = "\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])"
    [String] static hidden $_escapeSplitRegex = "(\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~]))"
    [String] static hidden $_colourResetEscape = "$([ANSIEscapedString]::_e)[0m"
    #endregion Properties


    #region Constructors
    ANSIEscapedString () {

        # Prevent instantiation of this class
        if ($this.GetType() -eq [ANSIEscapedString]) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        }
    } 
    #endregion Constructors


    #region Methods
    [Int] static PrintedLength([String] $s) {
        return ($s -replace [ANSIEscapedString]::_escapeRegex, "").Length
    }



    [String] static Strip([String] $s) {
        return $s -replace [ANSIEscapedString]::_escapeRegex, ""
    }



    [String] static Colourise([String] $s, [Int] $colour) {
        return [ANSIEscapedString]::Colourise($s, $colour, $true)
    }

    [String] static Colourise([String] $s, [Int] $colour, [Bool] $reset) {
        $escapeColour = "$([ANSIEscapedString]::_e)[$($colour)m"
        
        if ($reset) {
            return $escapeColour + $s + [ANSIEscapedString]::_colourResetEscape
        }
        else {
            return $escapeColour + $s 
        }
    }



    [String] static FixedWidth([String] $s, [Int] $width) {
        return [ANSIEscapedString]::FixedWidth($s, $width, $true)
    }

    [String] static FixedWidth([String] $s, [Int] $width, [Bool] $includeDotDotDot) {

        # Cleanse input
        if ($width -lt 0) { $width = 0 }

        # Set initial state
        [Int] $printedLength = [ANSIEscapedString]::PrintedLength($s)
        [String] $dotdotdot = "." * [Int]$includeDotDotDot * [System.Math]::Min(3, $width)
        [Int] $remainingStringWidth = $width

        if ($printedLength -le $remainingStringWidth) {
        
            # If shorter or equal to the width, pad the string
            $output = ($s + (" " * ($remainingStringWidth  - $printedLength)))
        }
        else {

            # If too long
            $splitArray = $s -split [ANSIEscapedString]::_escapeSplitRegex
            [String] $output = ""

            foreach ($element in $splitArray) {
                if ($element -match [ANSIEscapedString]::_escapeRegex) {
                    $output = $output + $element
                }
                elseif ($remainingStringWidth -gt ($element.Length + $dotdotdot.Length)) {
                    $output = $output + $element
                    $remainingStringWidth = $remainingStringWidth - $element.Length
                }
                elseif (($remainingStringWidth -ge 0) -and ($element.Length -gt $remainingStringWidth)) {
                    $output = $output + $element.subString(0, [System.Math]::Max(0, $remainingStringWidth - $dotdotdot.Length)) + $dotdotdot.Substring(0,[System.Math]::Min($remainingStringWidth, $dotdotdot.Length))
                    $remainingStringWidth = 0
                }
                elseif (($remainingStringWidth -gt 0) -and ($element.Length -gt 0)) {
                    $output = $output + $element.subString(0, $remainingStringWidth - $dotdotdot.Length) + $dotdotdot.Substring(0, $element.Length - $remainingStringWidth + $dotdotdot.Length)
                    $remainingStringWidth = $remainingStringWidth - $element.Length
                }
                else {
                    # Do nothing
                }
            }
        }

        return $output
    }
    #endregion Methods

}
#endregion Class Definition