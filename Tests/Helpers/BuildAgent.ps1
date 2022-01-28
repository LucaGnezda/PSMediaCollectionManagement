function Invoke-PesterTestAndGenerateCoverageReport () {

    Import-Module Pester -MinimumVersion 5.0.0
        
    Invoke-Pester $PSScriptRoot\..\*.Tests.ps1 `
                  -CodeCoverage $PSScriptRoot\..\..\PS.MediaCollectionManagement\* `
                  -CodeCoverageOutputFile $PSScriptRoot\..\coverage.xml `
                  -CodeCoverageOutputFileFormat JaCoCo

}

function Invoke-DetailedPesterTest () {

    Import-Module Pester -MinimumVersion 5.0.0
        
    Invoke-Pester -Output Detailed $PSScriptRoot\..\*.Tests.ps1

}