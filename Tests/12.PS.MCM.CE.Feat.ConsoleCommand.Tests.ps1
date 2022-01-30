using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
}

Describe "Write-ToConsole" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Write-ToConsole" {
        # Do
        Write-ToConsole "Hello World 1"
        Write-ToConsole -ForegroundColor Green "Hello World 2"
        Write-ToConsole -ForegroundColor Green "Hello World" -NoNewLine
        Write-ToConsole " 3"
        Write-ToConsole "Foo" "Bar" "Ecky"

        # Test
        [ConsoleExtensionsState]::MockConsole[0] | Should -Be "  Hello World 1"
        [ConsoleExtensionsState]::MockConsole[1] | Should -Be "  Hello World 2"
        [ConsoleExtensionsState]::MockConsole[2] | Should -Be "  Hello World 3"
        [ConsoleExtensionsState]::MockConsole[3] | Should -Be "  Foo Bar Ecky"
    }
}

Describe "Write-InfoToConsole" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Write-InfoToConsole" {
        # Do
        Write-InfoToConsole "Hello World 1"
        Write-InfoToConsole -ForegroundColor Green "Hello World 2"
        Write-InfoToConsole -ForegroundColor Green "Hello World" -NoNewLine
        Write-InfoToConsole " 3"
        Write-InfoToConsole "Foo" "Bar" "Ecky"

        # Test
        [ConsoleExtensionsState]::MockConsole[0] | Should -Be "  Hello World 1"
        [ConsoleExtensionsState]::MockConsole[1] | Should -Be "  Hello World 2"
        [ConsoleExtensionsState]::MockConsole[2] | Should -Be "  Hello World 3"
        [ConsoleExtensionsState]::MockConsole[3] | Should -Be "  Foo Bar Ecky"
    }
}

Describe "Write-WarnToConsole" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Write-WarnToConsole" {
        # Do
        Write-WarnToConsole "Hello World 1"
        Write-WarnToConsole -ForegroundColor Green "Hello World 2"
        Write-WarnToConsole -ForegroundColor Green "Hello World" -NoNewLine
        Write-WarnToConsole " 3"
        Write-WarnToConsole "Foo" "Bar" "Ecky"

        # Test
        [ConsoleExtensionsState]::MockConsole[0] | Should -Be "  Hello World 1"
        [ConsoleExtensionsState]::MockConsole[1] | Should -Be "  Hello World 2"
        [ConsoleExtensionsState]::MockConsole[2] | Should -Be "  Hello World 3"
        [ConsoleExtensionsState]::MockConsole[3] | Should -Be "  Foo Bar Ecky"
    }
}

Describe "Write-ErrorToConsole" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Write-ErrorToConsole" {
        # Do
        Write-ErrorToConsole "Hello World 1"
        Write-ErrorToConsole -ForegroundColor Green "Hello World 2"
        Write-ErrorToConsole -ForegroundColor Green "Hello World" -NoNewLine
        Write-ErrorToConsole " 3"
        Write-ErrorToConsole "Foo" "Bar" "Ecky"

        # Test
        [ConsoleExtensionsState]::MockConsole[0] | Should -Be "  Hello World 1"
        [ConsoleExtensionsState]::MockConsole[1] | Should -Be "  Hello World 2"
        [ConsoleExtensionsState]::MockConsole[2] | Should -Be "  Hello World 3"
        [ConsoleExtensionsState]::MockConsole[3] | Should -Be "  Foo Bar Ecky"
    }
}

Describe "Write-SuccessToConsole" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Write-SuccessToConsole" {
        # Do
        Write-SuccessToConsole "Hello World 1"
        Write-SuccessToConsole -ForegroundColor Green "Hello World 2"
        Write-SuccessToConsole -ForegroundColor Green "Hello World" -NoNewLine
        Write-SuccessToConsole " 3"
        Write-SuccessToConsole "Foo" "Bar" "Ecky"

        # Test
        [ConsoleExtensionsState]::MockConsole[0] | Should -Be "  Hello World 1"
        [ConsoleExtensionsState]::MockConsole[1] | Should -Be "  Hello World 2"
        [ConsoleExtensionsState]::MockConsole[2] | Should -Be "  Hello World 3"
        [ConsoleExtensionsState]::MockConsole[3] | Should -Be "  Foo Bar Ecky"
    }
}

Describe "Add-ConsoleIndent, Remove-ConsoleIndent, Reset-ConsoleIndent" -Tag IntegrationTest {
    BeforeEach {
        [ConsoleExtensionsState]::ResetMockConsole()
    }
    
    It "Add-ConsoleIndent, Remove-ConsoleIndent, Reset-ConsoleIndent" {
        # Do
        Write-ToConsole "Hello World 1"
        Add-ConsoleIndent
        Write-ToConsole "Hello World 2"
        Add-ConsoleIndent
        Write-ToConsole "Hello World 3"
        Remove-ConsoleIndent
        Write-ToConsole "Hello World 4"
        Remove-ConsoleIndent
        Write-ToConsole "Hello World 5"
        Remove-ConsoleIndent
        Write-ToConsole "Hello World 6"
        Add-ConsoleIndent
        Add-ConsoleIndent
        Reset-ConsoleIndent
        Write-ToConsole "Hello World 7"

        # Test
        [ConsoleExtensionsState]::MockConsole[0] | Should -Be "  Hello World 1"
        [ConsoleExtensionsState]::MockConsole[1] | Should -Be "    Hello World 2"
        [ConsoleExtensionsState]::MockConsole[2] | Should -Be "      Hello World 3"
        [ConsoleExtensionsState]::MockConsole[3] | Should -Be "    Hello World 4"
        [ConsoleExtensionsState]::MockConsole[4] | Should -Be "  Hello World 5"
        [ConsoleExtensionsState]::MockConsole[5] | Should -Be "  Hello World 6"
        [ConsoleExtensionsState]::MockConsole[6] | Should -Be "  Hello World 7"
    }
}

Describe "ToConsole - Colour tests" -Tag IntegrationTest {
    BeforeAll {
        [ConsoleExtensionsState]::RedirectToMockConsole = $false
    }
    
    It "Write-SuccessToConsole" {
        # Do
        Add-ConsoleIndent
        Write-SuccessToConsole "Success"
        Reset-ConsoleIndent
    }

    It "Write-InfoToConsole" {
        # Do
        Add-ConsoleIndent
        Write-InfoToConsole "Info"
        Reset-ConsoleIndent
    }

    It "Write-WarnToConsole" {
        # Do
        Add-ConsoleIndent
        Write-WarnToConsole "Warning"
        Reset-ConsoleIndent
    }

    It "Write-ErrorToConsole" {
        # Do
        Add-ConsoleIndent
        Write-ErrorToConsole "Error"
        Reset-ConsoleIndent
    }

    It "Write-ToConsole" {
        # Do
        Add-ConsoleIndent
        Write-ToConsole "Generic"
        Write-ToConsole -ForegroundColor Magenta "Specifcied Colour"
        Reset-ConsoleIndent
    }

    It "Write-FormattedTableToConsole" {
        # Do
        $out = (Get-ChildItem -Directory $pshome)
        $out[2] | Add-Member NoteProperty "Color" 96 # Cyan
        Write-FormattedTableToConsole -ColumnHeadings @("Mode", "Name") -ColumnProperties @("Mode", "Name") -ColumnWidths @(10, 40) -ColumnColors @(92, 93) -AcceptColumnColorsFromInputIfAvailable @($false, $true) -Object $out

        [ConsoleExtensionsState]::RedirectToMockConsole = $true
        Write-FormattedTableToConsole -ColumnHeadings @("Mode", "Name") -ColumnProperties @("Mode", "Name") -ColumnWidths @(10, 40, 60) -ColumnColors @(92, 93) -AcceptColumnColorsFromInputIfAvailable @($false, $true) -Object $out # Inconsistent formatter array lengths
        [ConsoleExtensionsState]::RedirectToMockConsole = $false
    }
}



