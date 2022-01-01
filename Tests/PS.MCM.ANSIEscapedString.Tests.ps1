using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\Helpers\ANSIEscapedString.Abstract.psm1

BeforeAll { 

}

Describe "ANSIEscapedString Helper Unit Test" -Tag UnitTest {
    BeforeEach {
        $s = [ANSIEscapedString]::Colourise("Hello ",92,$false) + [ANSIEscapedString]::Colourise("World",93) + "!"
        $e = [Char]27
    }
    
    It "Colourise" {
        # Test
        $s | Should -Be "$($e)[92mHello $($e)[93mWorld$($e)[0m!"
    }

    It "Strip" {
        # Test
        [ANSIEscapedString]::Strip($s) | Should -Be "Hello World!"
    }

    It "PrintedLength" {
        # Test
        [ANSIEscapedString]::PrintedLength($s) | Should -Be 12
    }

    It "FixedWidth" {
        # Test
        [ANSIEscapedString]::FixedWidth($s, 15, $false) | Should -Be "$($e)[92mHello $($e)[93mWorld$($e)[0m!   "
        [ANSIEscapedString]::FixedWidth($s, 12, $false) | Should -Be "$($e)[92mHello $($e)[93mWorld$($e)[0m!"
        [ANSIEscapedString]::FixedWidth($s, 10, $false) | Should -Be "$($e)[92mHello $($e)[93mWorl$($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, 3, $false) | Should -Be "$($e)[92mHel$($e)[93m$($e)[0m"

        [ANSIEscapedString]::FixedWidth($s, 15) | Should -Be "$($e)[92mHello $($e)[93mWorld$($e)[0m!   "
        [ANSIEscapedString]::FixedWidth($s, 12) | Should -Be "$($e)[92mHello $($e)[93mWorld$($e)[0m!"
        [ANSIEscapedString]::FixedWidth($s, 10) | Should -Be "$($e)[92mHello $($e)[93mW...$($e)[0m"
        [ANSIEscapedString]::FixedWidth($s, 3) | Should -Be "$($e)[92m...$($e)[93m$($e)[0m"
    }
}