using module .\..\..\Using\Helpers\PS.MCM.ANSIEscapedString.Abstract.psm1

function Write-FormattedTableToConsole (
    [Parameter(Mandatory=$true)]
    [String[]] $ColumnHeadings,
    
    [Parameter(Mandatory=$true)]
    [String[]] $ColumnProperties,

    [Parameter(Mandatory=$true)]
    [Int[]] $ColumnWidths,    

    [Parameter(Mandatory=$true)]
    [Int[]] $ColumnColors, 

    [Parameter(Mandatory=$true)]
    [Bool[]] $AcceptColumnColorsFromInputIfAvailable, 

    [Parameter(Mandatory=$false, ValueFromRemainingArguments, ValueFromPipeline=$true)]
    [System.Collections.Generic.List[Object]]
    $Object=""
)
{
    [System.Collections.Generic.List[String]] $output = [System.Collections.Generic.List[String]]::new()

    if (($ColumnHeadings.Count -ne $ColumnProperties.Count) -or
        ($ColumnHeadings.Count -ne $ColumnWidths.Count) -or
        ($ColumnHeadings.Count -ne $ColumnColors.Count) -or
        ($ColumnHeadings.Count -ne $AcceptColumnColorsFromInputIfAvailable.Count)) {
            Write-Host "Unable to output table. Formatter arrays do not share a common length."
            return
    }

    $output.Add("")
    $output.Add("")

    # Heading
    for ($i = 0; $i -lt $ColumnHeadings.Count; $i++) {
        if ($i -gt 0) {
            $output[0] = $output[0] + " "
            $output[1] = $output[1] + " "
        }
        
        $output[0] = $output[0] + [ANSIEscapedString]::FixedWidth($ColumnHeadings[$i], $ColumnWidths[$i], $false)
        $output[1] = $output[1] + [ANSIEscapedString]::FixedWidth("-" * $ColumnHeadings[$i].Length, $ColumnWidths[$i], $false)
    }

    # Body
    foreach ($item in $Object) {
        
        $output.Add("")

        for ($i = 0; $i -lt $ColumnHeadings.Count; $i++) {
            if ($i -gt 0) {
                $output[$output.Count - 1] = $output[$output.Count - 1] + " "
            }

            $cellValue = $item.$($ColumnProperties[$i])

            if ($AcceptColumnColorsFromInputIfAvailable[$i] -and ($null -ne $item.Color)) {
                $cellValue = [ANSIEscapedString]::Colourise($cellValue, $item.Color)
            }
            elseif ($ColumnColors[$i] -gt 0) {
                $cellValue = [ANSIEscapedString]::Colourise($cellValue, $ColumnColors[$i])
            }
            else {
                # Do nothing
            }
            
            $cellValue = [ANSIEscapedString]::FixedWidth($cellValue, $ColumnWidths[$i])

            $output[$output.Count - 1] = $output[$output.Count - 1] + $cellValue
        }
    }

    $output | Out-String | Foreach-Object {Write-ToConsole -NoIndent $_}
}