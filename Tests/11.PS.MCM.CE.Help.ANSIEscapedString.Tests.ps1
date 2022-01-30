using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\Helpers\ANSIEscapedString.Static.psm1

BeforeAll { 

}

Describe "ANSIEscapedString Helper Unit Test" -Tag UnitTest {
    BeforeEach {
        $s = [ANSIEscapedString]::Colourise("Hello ",92,$false) + [ANSIEscapedString]::Colourise("Colour ",93,$true) + [ANSIEscapedString]::Colourise("World",94) + "!"
        $e = [Char]27
        $s;$e
    }
    
    It "Colourise" {
        # Test
        $s | Should -Be "$($e)[92mHello $($e)[93mColour $($e)[0m$($e)[94mWorld$($e)[0m!"
    }

    It "Strip" {
        # Test
        [ANSIEscapedString]::Strip($s) | Should -Be "Hello Colour World!"
    }

    It "PrintedLength" {
        # Test
        [ANSIEscapedString]::PrintedLength($s) | Should -Be 19
    }

    It "FixedWidth" {
        # Test
        [ANSIEscapedString]::FixedWidth($s, 22, $false) | Should -Be "$($e)[92mHello $($e)[93mColour $($e)[0m$($e)[94mWorld$($e)[0m!   "
        [ANSIEscapedString]::FixedWidth($s, 19, $false) | Should -Be "$($e)[92mHello $($e)[93mColour $($e)[0m$($e)[94mWorld$($e)[0m!"
        [ANSIEscapedString]::FixedWidth($s, 10, $false) | Should -Be "$($e)[92mHello $($e)[93mColo$($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, 6, $false) | Should -Be "$($e)[92mHello $($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, 3, $false) | Should -Be "$($e)[92mHel$($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, -1, $false) | Should -Be ""

        [ANSIEscapedString]::FixedWidth($s, 22) | Should -Be "$($e)[92mHello $($e)[93mColour $($e)[0m$($e)[94mWorld$($e)[0m!   "
        [ANSIEscapedString]::FixedWidth($s, 19) | Should -Be "$($e)[92mHello $($e)[93mColour $($e)[0m$($e)[94mWorld$($e)[0m!"
        [ANSIEscapedString]::FixedWidth($s, 10) | Should -Be "$($e)[92mHello $($e)[93mC...$($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, 9) | Should -Be "$($e)[92mHello $($e)[93m...$($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, 3) | Should -Be "$($e)[92m...$($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, -1) | Should -Be ""
    }
}