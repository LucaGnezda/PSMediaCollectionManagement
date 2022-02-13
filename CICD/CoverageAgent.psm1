#region Header
#
# About: Friendlt Code Coverage Report Generator
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\Helpers\ANSIEscapedString.Static.psm1
#endregion Using



#region Reference
#-----------------
$Colour = @{
    Red = 91;
    Green = 92;
    Yellow = 93;
    Magenta = 95;
    Grey = 90
}

$Width = @{
    MaxAutoWidth = 180
    Tab = 2
    ColumnSpacer = 1
    CoverageUnits = 20
    CoverageUnitsDelimiter = 1
    MinCoverageStats = 7
    MinExemptions = 2
    CoveragePercentage = 10
    EffectiveCoveragePercentage = 11
}

$Char = @{
    UnfilledCircle = [char]0x25cb
    FilledCircle = [char]0x25cf
    Triangle = [char]0x25b2
    CRLF = "`r`n"
    ColumnSpacer = " "
    HorizontalRule = "-"
    Tab = "  "
}
#endregion Reference


#region Class Definition
#-----------------------
class CoverageAgent {

    #region Properties
    [Bool]      Hidden $_OutputToConsole
    [Bool]      Hidden $_OutputToFile
    [String]    Hidden $_OutputFile
    [Int]       Hidden $_ConsoleOutputWidth
    [Int]       Hidden $_FileOutputWidth
    [xml]       Hidden $_CoverageXML
    [Hashtable] Hidden $_Exemptions
    [Bool]      Hidden $_AppendFile

    #endregion Properties

    #region Constructors
    CoverageAgent ([String] $coverageXMLFilePath, [Hashtable] $exemptions) {
        $this.IncludeConsoleOutput()
        $this.ExcludeFileOutput()
        $this._CoverageXML = Get-Content $coverageXMLFilePath
        $this._Exemptions = $exemptions
    }

    CoverageAgent ([String] $coverageXMLFilePath) {
        $this.IncludeConsoleOutput()
        $this.ExcludeFileOutput()
        $this._CoverageXML = Get-Content $coverageXMLFilePath
        $this._Exemptions = $null
    }
    #endregion Constructors

    #region Public Methods
    [Void] IncludeConsoleOutput () {
        $h = Get-Host
        $this._OutputToConsole = $true
        $this._ConsoleOutputWidth = [Math]::Min($h.UI.RawUI.WindowSize.Width - 1, $Script:Width.MaxAutoWidth)
    }

    [Void] IncludeConsoleOutput ([Int] $outputWidth) {
        $this._OutputToConsole = $true
        $this._ConsoleOutputWidth = $outputWidth
    }

    [Void] ExcludeConsoleOutput () {
        $this._OutputToConsole = $false
        $this._ConsoleOutputWidth = 0
    }

    [Void] IncludeFileOutput ([Int] $outputWidth, [String] $path) {
        $this._OutputToFile = $true
        $this._FileOutputWidth = $outputWidth
        $this._OutputFile = $path
    }

    [Void] ExcludeFileOutput () {
        $this._OutputToFile = $false
        $this._FileOutputWidth = 0
        $this._OutputFile = ""
    }

    [Void] SetExemptions ([Hashtable] $exemptions) {
        $this._Exemptions = $exemptions
    }

    [Hashtable] MeasureCode () {

        # Collect data
        [Int] $classesCovered = ($this._CoverageXML.report[1].counter | Where-Object {$_.type -eq "CLASS"}).Covered
        [Int] $classesMissed = ($this._CoverageXML.report[1].counter | Where-Object {$_.type -eq "CLASS"}).Missed
        [Int[]] $coverageArray = ($this._CoverageXML.report[1].package.class.method.counter | Where-Object {$_.type -eq "INSTRUCTION"}).Covered
        [Int[]] $missedArray = ($this._CoverageXML.report[1].package.class.method.counter | Where-Object {$_.type -eq "INSTRUCTION"}).Missed
        [Int[]] $totalArray = [Int[]]::new($coverageArray.Count)
        for ($i = 0; $i -lt $TotalArray.Count; $i++) { 
            $totalArray[$i] = $coverageArray[$i] + $missedArray[$i] 
        }

        # Populate the return hash
        $hash = @{
            Classes = $classesCovered + $classesMissed
            Methods = $totalArray.Count
            InstructionsCovered = ($coverageArray | Measure-Object -Sum).Sum
            InstructionsMissed = ($missedArray | Measure-Object -Sum).Sum
            InstructionsTotal = ($totalArray | Measure-Object -Sum).Sum
            InstructionsExempted = ($this._Exemptions.Values | Measure-Object -Sum).Sum
            InstructionCoverage = 0.0 # To be post populated
            MostInstructionsInAMethod = ($totalArray | Measure-Object -Maximum).Maximum
            LeastInstructionsInAMethod = ($totalArray | Measure-Object -Minimum).Minimum
            AverageInstructionsPerMethod = ($totalArray | Measure-Object -Average).Average
        }
        $hash.InstructionCoverage = $hash.InstructionsCovered / $hash.InstructionsTotal
        
        return $hash
    }

    [Void] GenerateFriendlyReport() {
        $codeMeasurement = $this.MeasureCode()
        $tableDimensions = $this.GetTableDimensions($codeMeasurement)

        $this.IfWritingToFileOverwriteNextOutput()

        $this.OutputPageHeader()
        $this.OutputStatsSummary($codeMeasurement)
        $this.OutputLegend()

        $this.OutputTableHeader($tableDimensions)
        $this.GenerateTableBody($tableDimensions)
        $this.OutputTableFooter($tableDimensions, $codeMeasurement.InstructionsCovered, $codeMeasurement.InstructionsMissed, $codeMeasurement.InstructionsExempted)
        
        $this.OutputPageFooter()
    }
    #endregion Public Methods

    #region Hidden Methods
    [Hashtable] GetTableDimensions ([Hashtable] $codeMeasurement) {

        # Collect additional data
        if ($null -ne $this._Exemptions) { 
            $exemptionsMaxLength = ($this._Exemptions.Values | Measure-Object -Sum).Sum.ToString().Length
        } 
        else { 
            $exemptionsMaxLength = 0 
        }
        $h = Get-Host

        # Populate the return hash
        $hash = @{
            ConsoleWidth = $h.UI.RawUI.WindowSize.Width
            ConsoleTableWidth = $this._ConsoleOutputWidth
            FileTableWidth = $this._FileOutputWidth
            Tab = $Script:Width.Tab
            ColumnSpacer = $Script:Width.ColumnSpacer
            CoveredInstructionsMaxLength = $codeMeasurement.InstructionsCovered.ToString().Length
            TotalInstructionsMaxLength = $codeMeasurement.InstructionsTotal.ToString().Length
            ExemptionsMaxLength = $exemptionsMaxLength
            ConsoleCodebaseColumnWidth = 0  # To be post populated
            FileCodebaseColumnWidth = 0     # To be post populated
            CoverageBarColumnWidth = $Script:Width.CoverageUnits + ($Script:Width.CoverageUnitsDelimiter * 2)
            CoverageStatsColumnWidth = 0    # To be post populated
            ExemptionsColumnWidth = 0       # To be post populated
            CoveragePercentageColumnWidth = $Script:Width.CoveragePercentage
            EffectiveCoveragePercentageColumnWidth = $Script:Width.EffectiveCoveragePercentage
        }
        $hash.CoverageStatsColumnWidth = [Math]::Max($hash.CoveredInstructionsMaxLength + 1 + $hash.TotalInstructionsMaxLength, $Script:Width.MinCoverageStats)
        $hash.ExemptionsColumnWidth = [Math]::Max(1 + $hash.ExemptionsMaxLength, $Script:Width.MinExemptions)
        $hash.ConsoleCodebaseColumnWidth = [Math]::Max($hash.ConsoleTableWidth - $hash.CoverageBarColumnWidth - $hash.CoverageStatsColumnWidth - $hash.ExemptionsColumnWidth - $hash.CoveragePercentageColumnWidth - $hash.EffectiveCoveragePercentageColumnWidth - ($hash.ColumnSpacer * 5), 0) 
        $hash.FileCodebaseColumnWidth = [Math]::Max($hash.FileTableWidth - $hash.CoverageBarColumnWidth - $hash.CoverageStatsColumnWidth - $hash.ExemptionsColumnWidth - $hash.CoveragePercentageColumnWidth - $hash.EffectiveCoveragePercentageColumnWidth - ($hash.ColumnSpacer * 5), 0)

        return $hash
    }

    [Int] GetCoverageColour ($missed, $exempted, $coverage) {
        if ($coverage -gt 1.00) {
            return $Script:Colour.Magenta
        }
        elseif ( ($missed - $exempted) -le 0 ) { 
            return $Script:Colour.Green 
        }
        elseif ( $coverage -ge 0.75 ) { 
            return $Script:Colour.Yellow 
        }
        else { 
            return $Script:Colour.Red 
        }
    }

    [Int] GetExemptions ([String] $package, [String] $class, [String] $method) {

        if ($null -eq $this._Exemptions) {
            return 0
        }

        $key = $package + "|"
        if (-not [String]::IsNullOrEmpty($class)) {
            $key = $key + $class + "|"
        }
        $key = $key + $method

        if ($this._Exemptions.ContainsKey($key)) {
            return $this._Exemptions[$key]
        }
        else {
            return 0
        }
    }

    [Void] OutputPageHeader () {
        
        # Build
        $output =  [String]::Format("``````Friendly Coverage Report" + $Script:Char.CRLF)
        $output += [String]::Format("Generated on: {0}" + $Script:Char.CRLF, (Get-Date).ToUniversalTime().ToString("dd MMMM yyyy HH:mm:ss UTC") + $Script:Char.CRLF)

        # Output
        $this.Output($output, $false, $true)
    }

    [Void] OutputStatsSummary ([Hashtable] $measurements) {

        # Build
        $output =  [String]::Format("Statistics:" + $Script:Char.CRLF)
        $output += [String]::Format("  Functions & classes     : {0}" + $Script:Char.CRLF, $measurements.Classes)
        $output += [String]::Format("  Functions & methods     : {0}" + $Script:Char.CRLF, $measurements.Methods)
        $output += [String]::Format("  Instructions            : {0}" + $Script:Char.CRLF, $measurements.InstructionsTotal)
        $output += [String]::Format("  Instructions per method : {0} to {1} instructions, {2} average" + $Script:Char.CRLF, $measurements.LeastInstructionsInAMethod, $measurements.MostInstructionsInAMethod, [Math]::Round($measurements.AverageInstructionsPerMethod, 1))
        $output += [String]::Format("  Instruction coverage    : {0} out of {1} ( {2} )" + $Script:Char.CRLF, $measurements.InstructionsCovered, $measurements.InstructionsTotal, $measurements.InstructionCoverage.ToString("P"))
        $output += [String]::Format("  Accepted Exemptions     : {0}" + $Script:Char.CRLF, $measurements.InstructionsExempted)

        # Output
        $this.Output($output)
    }

    [Void] OutputLegend () {

        # Build
        $output =  [String]::Format("Legend:" + $Script:Char.CRLF)
        $output += [String]::Format("  {0} = Coverage" + $Script:Char.CRLF, $Script:Char.FilledCircle)
        $output += [String]::Format("  {0} = Known Exemptions" + $Script:Char.CRLF, $Script:Char.Triangle)
        $output += [String]::Format("  {0} = Missed Instructions" + $Script:Char.CRLF, $Script:Char.UnfilledCircle)

        # Output
        $this.Output($output)
    }

    [Void] OutputTableHeader ([Hashtable] $dimensions) {

        # Build
        $output =  "Coverage".PadRight($dimensions.CoverageBarColumnWidth, " ") + $Script:Char.ColumnSpacer 
        $output += "Cov".PadLeft($dimensions.CoveredInstructionsMaxLength, " ") + "/" + "Tot".PadRight($dimensions.TotalInstructionsMaxLength, " ") + $Script:Char.ColumnSpacer
        $output += "Ex".PadRight($dimensions.ExemptionsColumnWidth, " ") + $Script:Char.ColumnSpacer
        $output += "Coverage %".PadRight($dimensions.CoveragePercentageColumnWidth, " ") + $Script:Char.ColumnSpacer
        $output += "Effective %".PadRight($dimensions.EffectiveCoveragePercentageColumnWidth, " ")

        # Output
        $this.Output(("Codebase".PadRight($dimensions.ConsoleCodebaseColumnWidth, " ") + $Script:Char.ColumnSpacer + $output), $true, $false)
        $this.Output(("Codebase".PadRight($dimensions.FileCodebaseColumnWidth, " ") + $Script:Char.ColumnSpacer + $output), $false, $true)

        # Build
        $output =  ($Script:Char.HorizontalRule * $dimensions.CoverageBarColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.CoverageStatsColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.ExemptionsColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.CoveragePercentageColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.EffectiveCoveragePercentageColumnWidth)

        # Output
        $this.Output(($Script:Char.HorizontalRule * $dimensions.ConsoleCodebaseColumnWidth) + $Script:Char.ColumnSpacer + $output, $true, $false)
        $this.Output(($Script:Char.HorizontalRule * $dimensions.FileCodebaseColumnWidth) + $Script:Char.ColumnSpacer + $output, $false, $true)
    }

    [Void] OutputTableGroupingRow ([Hashtable] $dimensions, [Int] $indent, [String] $codeGrouping) {
        
        # Calculate
        $availableConsoleWidth = $dimensions.ConsoleTableWidth - ($indent * $Script:Width.Tab)
        $availableFileWidth = $dimensions.FileTableWidth - ($indent * $Script:Width.Tab)

        # Build
        $consoleOutput =  $Script:Char.Tab * $indent
        $consoleOutput += [ANSIEscapedString]::Colourise([ANSIEscapedString]::FixedWidth($codeGrouping, $availableConsoleWidth, $true), $Script:Colour.Grey)

        $fileOutput =  $Script:Char.Tab * $indent
        $fileOutput += [ANSIEscapedString]::FixedWidth($codeGrouping, $availableFileWidth, $true)
        
        # Output
        $this.Output($consoleOutput, $true, $false)
        $this.Output($fileOutput, $false, $true)  
    }
    
    [Void] OutputTableDataRow ([Hashtable] $dimensions, [Int] $indent, [String] $codeElement, [Int] $covered, [Int] $missed, [Int] $exempted) {

        # Calculate
        $availableConsoleWidth = $dimensions.ConsoleCodebaseColumnWidth - ($indent * $Script:Width.Tab)
        $availableFileWidth = $dimensions.FileCodebaseColumnWidth - ($indent * $Script:Width.Tab)
        $coverage = $covered / ($covered + $missed)
        $effectiveCoverage = ($covered + $exempted) / ($covered + $missed)
        $coverageUnits = [Math]::Floor($coverage * $Script:Width.CoverageUnits)
        $exemptionUnits = [Math]::Floor([Math]::Min($effectiveCoverage, 1) * $Script:Width.CoverageUnits) - $coverageUnits
        $missedUnits = $Script:Width.CoverageUnits - $coverageUnits - $exemptionUnits
        $coverageColour = $this.GetCoverageColour($missed, 0, $coverage)
        $effectiveCoverageColour = $this.GetCoverageColour($missed, $exempted, $effectiveCoverage)

        # Build
        $commonOutput =  "["
        $commonOutput += [ANSIEscapedString]::Colourise($Script:Char.FilledCircle.ToString() * [Int]$coverageUnits, $effectiveCoverageColour)
        $commonOutput += [ANSIEscapedString]::Colourise($Script:Char.Triangle.ToString() * [Int]$exemptionUnits, $effectiveCoverageColour)
        $commonOutput += [ANSIEscapedString]::Colourise($Script:Char.UnfilledCircle.ToString() * [Int]$missedUnits, $Script:Colour.Grey)
        $commonOutput += "]" + $Script:Char.ColumnSpacer
        $commonOutput += [ANSIEscapedString]::Colourise($covered.ToString().PadLeft($dimensions.CoveredInstructionsMaxLength," "), $coverageColour) + "/" + ($covered + $missed).ToString().PadRight($dimensions.TotalInstructionsMaxLength," ") + $Script:Char.ColumnSpacer
        $commonOutput += [ANSIEscapedString]::Colourise([String]::Format("{0:+0;-0;#}", $exempted).PadRight($dimensions.ExemptionsColumnWidth," "), $effectiveCoverageColour) + $Script:Char.ColumnSpacer
        $commonOutput += [ANSIEscapedString]::Colourise($coverage.ToString("P").PadLeft($dimensions.CoveragePercentageColumnWidth," "), $coverageColour) + $Script:Char.ColumnSpacer
        $commonOutput += [ANSIEscapedString]::Colourise($effectiveCoverage.ToString("P").PadLeft($dimensions.EffectiveCoveragePercentageColumnWidth," "), $effectiveCoverageColour)


        $consoleOutput =  $Script:Char.Tab * $indent
        $consoleOutput += [ANSIEscapedString]::FixedWidth($codeElement, $availableConsoleWidth, $true)

        $fileOutput =  $Script:Char.Tab * $indent
        $fileOutput += [ANSIEscapedString]::FixedWidth($codeElement, $availableFileWidth, $true)

        # Output
        $this.Output(($consoleOutput + $Script:Char.ColumnSpacer + $commonOutput) , $true, $false)
        $this.Output(($fileOutput + $Script:Char.ColumnSpacer + $commonOutput), $false, $true) 

    }

    [Void] OutputEmptyRow () {
        $this.Output("") 
    }

    [Void] OutputTableFooter ([Hashtable] $dimensions, [Int] $covered, [Int] $missed, [Int] $exempted) {

        # Build
        $output += ($Script:Char.HorizontalRule * $dimensions.CoverageBarColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.CoverageStatsColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.ExemptionsColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.CoveragePercentageColumnWidth) + $Script:Char.ColumnSpacer
        $output += ($Script:Char.HorizontalRule * $dimensions.EffectiveCoveragePercentageColumnWidth) + $Script:Char.ColumnSpacer

        # Output
        $this.Output(($Script:Char.HorizontalRule * $dimensions.ConsoleCodebaseColumnWidth) + $Script:Char.ColumnSpacer + $output, $true, $false)
        $this.Output(($Script:Char.HorizontalRule * $dimensions.FileCodebaseColumnWidth) + $Script:Char.ColumnSpacer + $output, $false, $true)
        
        $this.OutputTableDataRow([Hashtable] $dimensions, 0, "Overall coverage", $covered, $missed, $exempted)

        $this.OutputEmptyRow()

    }

    [Void] OutputPageFooter () {
        $this.Output("``````Friendly Coverage Report", $false, $true)
    }

    [Void] GenerateTableBody ([Hashtable] $dimensions) {

        foreach ($package in $this._CoverageXML.report[1].package) {
            
            $this.OutputTableGroupingRow($dimensions, 1, $package.name)
            
            foreach ($class in $package.class) {

                $className = Split-Path $class.name -Leaf
            
                if (($class.method.GetType() -eq [System.Xml.XmlElement]) -and ($className -eq $class.method.name)) {

                    $instructionCounters = $class.method.counter | Where-Object {$_.type -eq "INSTRUCTION"}
                    $exempted = $this.GetExemptions($package.name, $null, $class.method.name)

                    $this.OutputTableDataRow($dimensions, 2, "Function " + $class.method.name, $instructionCounters.covered, $instructionCounters.missed, $exempted)
                }
                else {
                    $this.OutputTableGroupingRow($dimensions, 2, $className)

                    foreach ($method in $class.method) {
                        $instructionCounters = $method.counter | Where-Object {$_.type -eq "INSTRUCTION"}
                        $exempted = $this.GetExemptions($package.name, $className, $method.name)
    
                        $this.OutputTableDataRow($dimensions, 3, $method.name, $instructionCounters.covered, $instructionCounters.missed, $exempted)
                    }

                    $this.OutputEmptyRow()
                }
                
            }

            $this.OutputEmptyRow()
        }
    }

    [Void] IfWritingToFileOverwriteNextOutput () {
        $this._AppendFile = $false
    }

    [Void] Output ([String] $s, [Bool] $ToConsole, [Bool] $ToFile) {
        if ($this._OutputToFile -and $ToFile) {
            if ($this._AppendFile) {
                [ANSIEscapedString]::Strip($s) | Out-File -FilePath $this._OutputFile -Encoding utf8 -Append
            }
            else {
                [ANSIEscapedString]::Strip($s) | Out-File -FilePath $this._OutputFile -Encoding utf8
                $this._AppendFile = $true
            }
        }
        if ($this._OutputToConsole -and $ToConsole) {
            Write-Host $s
        }
    }

    [Void] Output ([String] $s) {
        $this.Output($s, $true, $true)
    }
    #endregion Hidden Methods

}