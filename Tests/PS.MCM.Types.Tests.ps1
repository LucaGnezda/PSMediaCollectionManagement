BeforeAll { 

    Import-Module D:\Scripting\PSMediaCollectionManagement\PS.MediaContentManagement\PS.MediaContentManagement.psm1 -Force

    $psScript = Get-Content $PSScriptRoot\..\PS.MediaContentManagement\Using\Types\PS.MCM.Types.psm1

    $e = [System.Collections.ObjectModel.Collection[System.Management.Automation.PSParseError]]::new()
    $tokens = [System.Management.Automation.PSParser]::Tokenize($psScript, [ref] $e)
    $i = 0
    [System.Collections.Generic.List[Object]] $enums = [System.Collections.Generic.List[Object]]::new()
    
    try {
        while ($i -lt $tokens.Count) {
            if ($tokens[$i].Type -eq [System.Management.Automation.PSTokenType]::Keyword -and 
                $tokens[$i].Content -eq "enum" -and 
                $null -ne $tokens[$i+2] -and
                $tokens[$i+2].Type -eq [System.Management.Automation.PSTokenType]::GroupStart ) {

                $enum = [PSCustomObject]::new()
                $enum | Add-Member NoteProperty "Name" $tokens[$i+1].Content
                $enum | Add-Member NoteProperty "Pairs" $null

                $enum.Pairs = [System.Collections.Generic.List[Object]]::new()

                $i += 3
                
                while ($i -lt $tokens.Count -and $tokens[$i].Type -ne [System.Management.Automation.PSTokenType]::GroupEnd) {
                    if ($tokens[$i].Type -eq [System.Management.Automation.PSTokenType]::Member -and
                        $null -ne $tokens[$i+2] -and
                        $tokens[$i+1].Type -eq [System.Management.Automation.PSTokenType]::Operator -and
                        $tokens[$i+1].Content -eq "=") {
                        
                        $pair = [PSCustomObject]::new()
                        $pair | Add-Member NoteProperty "Name" $tokens[$i].Content
                        $pair | Add-Member NoteProperty "Value" $tokens[$i+2].Content
                    
                        $enum.Pairs.Add($pair)

                        $i += 3
                    }
                    else {
                        $i++
                    } 
                }

                $enums.Add($enum)
            }
            else {
                $i++
            }
        }
    }
    catch {
        Write-Host "Error while parsing types"
    }
}

Describe "Type Unit Tests" -Tag UnitTest {    
    It "Compare Internal and Public Types" {

        foreach ($enum in $enums) {

            $cmd = "[Enum]::GetValues([$($enum.Name)]).Count"
            $count = 0

            try {
                $count = Invoke-Expression $cmd
            }
            catch {
                $_ | Should -Be $null
            }

            $count | Should -Be $enum.Pairs.Count

            if ($count -gt 0) {

                foreach ($pair in $enum.Pairs) {

                    $cmd = "[Int][$($enum.Name)]::$($pair.Name)"
                    $value = Invoke-Expression $cmd
                    $value | Should -Be $pair.Value

                    $cmd = "[$($enum.Name)]::$($pair.Name)"
                    $value = Invoke-Expression $cmd
                    $value | Should -Be $pair.Name

                }
            }
            
            [System.Enum]::IfDef
        }
        $true | Should -Be $true
    }
}