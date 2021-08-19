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
    [System.Collections.Generic.List[Object]]$formatters = [System.Collections.Generic.List[Object]]::new()

    if (($ColumnHeadings.Count -ne $ColumnProperties.Count) -or
        ($ColumnHeadings.Count -ne $ColumnWidths.Count) -or
        ($ColumnHeadings.Count -ne $ColumnColors.Count) -or
        ($ColumnHeadings.Count -ne $AcceptColumnColorsFromInputIfAvailable.Count)) {
            Write-Host "Unable to output table. Formatter arrays do not share a common length."
            return
    }

    for($i = 0; $i -lt $ColumnHeadings.Count; $i++) {
 
        # Ok so one this line deserves an explanation. The purpose of this line is to craft a dynamic ScriptBlock (Lambda / Anonymous function) that Format-Table 
        # will use for its column output. Probably easiest to explain this by working backwards from the goal.
        # Ultimately, we need to pass in an array of Hashtables, with each element of the array representing a columnn.
        # Each Hashtable consists of three values; Label which is the Column Heading, Expression (the ScriptBlock) which is the formatter of the cells in that 
        # column, and Width which is the number of characters used for that column. The Label and Width parts are easy, the ScriptBLock not so much ...
        # Unfortunately, because we don't have control of the Format-Table function, we can't parameterise our ScriptBlock. So the only choice we have is to 
        # build one dynamically from a string and then cast it into a ScriptBlock.
        # ScripBlock formatters can use Escape codes to colour cells. What makes this trickier is that to Format-Table, an escape character counts as 4 characters 
        # when not processed and 1 character when processed. Which means the Table goes out of whack when columns end in "...", and when they do the reset escape 
        # character isn't processed meaning the colour will bleed into subsequent columns and rows. So we need to reimplement the "..." ourselves so the last 
        # character of each cell can be the escape. Escapes typiclly look like "<esc>[#m" where <esc> is [char]27 and the # is the numeric code for a colour.
        # The ScriptBlock below tries to inject a colour if available from the pipe into Format-Table (colouring a row), otherwise it will use the colour code from 
        # the parameters passed into this function (colouring a column).
        # Most of the ScriptBlock if just figuring out the escape character, the colour and if the "..." is needed. But the last line is where the magic happens.
        # Here is the format output itself, which is why it is ecsaped to hell. Its a string, for a ScriptBlock, that is variable substituting back into a string.
        # Once we have the ScriptBlock string, we then cast it into a ScriptBlock, add it to a Hashtable, then add it to an array. Finally we hand the whole array 
        # to the Format-Table function ... and voila a coloured, column formatted table!
        # FYI ... Yes I know what you're thinking, it probably would have been easier to just reimplement Format-Table as a series of Write-Host calls. But I didn't
        # know that until I started and once I did, it was such a cool problem I had to see it through.    
        # Here are relevant learning links:
        #   https://stackoverflow.com/questions/20705102/how-to-colorise-powershell-output-of-format-table (where this quest began for me)
        #   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.1 (Format-Table)
        #   https://powershellexplained.com/2017-01-13-powershell-variable-substitution-in-strings/ (Variable substitution into Strings)
        #   https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences (For the escape characters)  
        #   https://www.thomasmaurer.ch/2011/11/powershell-convert-string-to-scriptblock/ (converting strings into ScriptBlocks)
        #   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7.1 (ScriptBlocks)
        #   https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7.1  (Hashtables)
        $scriptBlockString  = "`$e = [char]27;"`
                            + "if (`$$($AcceptColumnColorsFromInputIfAvailable[$i]) -eq `$true -and `$_.Color -ne `$null) {"`
                            + "    `$color = `$_.Color"`
                            + "}"`
                            + "else {"`
                            + "    `$color = $($ColumnColors[$i]);"`
                            + "}"`
                            + "if ((`$(`$_.$($ColumnProperties[$i])).Length) -gt $($ColumnWidths[$i]-4)) {"`
                            + "    `$dotdotdot='...'"`
                            + "}"`
                            + "else {"`
                            + "    `$dotdotdot=''"`
                            + "};"`
                            + "`"`${e}[`${color}m`$(`$(`$_.$($ColumnProperties[$i])[0..$($ColumnWidths[$i]-5)] -join ''))`${dotdotdot}`${e}[0m `""
        $scriptBlock = [scriptblock]::Create($scriptBlockString)
        $formatter = @{ Label=$ColumnHeadings[$i]; Expression=$scriptBlock; width=$ColumnWidths[$i]}
        $formatters.Add($formatter)
    }

    $Object | Format-Table -Property $formatters | Out-String | Foreach-Object {Write-Host $_}
}