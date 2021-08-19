using module .\..\Module\Using\Helpers\PS.MCM.ElementParser.Abstract.psm1

BeforeAll { 
    
}

Describe "SeasonEpisodeParser Unit Test" -Tag UnitTest {
    BeforeEach {
       
    }
    
    It "IsValidSeasonEpisode" -ForEach @(
        @{s = "Foo"; expected = $false}
        @{s = "aS15E12"; expected = $false}
        @{s = "Sa15E12"; expected = $false}
        @{s = "S15aE12"; expected = $false}
        @{s = "S15Ea12"; expected = $false}
        @{s = "S15E12a"; expected = $false}
        @{s = "S15E12"; expected = $true}
        @{s = "s15e12"; expected = $true}
        @{s = "S15e12"; expected = $false}
        @{s = "s15E12"; expected = $false}
        @{s = "a15X12"; expected = $false}
        @{s = "15aX12"; expected = $false}
        @{s = "15Xa12"; expected = $false}
        @{s = "15X12a"; expected = $false}
        @{s = "15X12"; expected = $true}
        @{s = "15x12"; expected = $true}
    ) {
        # Test
        [ElementParser]::IsValidSeasonEpisode($s) | Should -Be $expected
    }

    It "IsSeasonEpisodePattern" -ForEach @(
        @{s = "Foo"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "aS15E12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "Sa15E12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15aE12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15Ea12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15E12a"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "S15E12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $true}
        @{s = "s15e12"; p=[SeasonEpisodePattern]::Uppercase_S0E0 ; expected = $false}
        @{s = "as15e12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "sa15e12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15ae12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15ea12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15e12a"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "s15e12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $true}
        @{s = "S15E12"; p=[SeasonEpisodePattern]::Lowercase_S0E0 ; expected = $false}
        @{s = "a15X12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15aX12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15Xa12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15X12a"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "15X12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $true}
        @{s = "15x12"; p=[SeasonEpisodePattern]::Uppercase_0X0 ; expected = $false}
        @{s = "a15x12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15ax12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15xa12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15x12a"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
        @{s = "15x12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $true}
        @{s = "15X12"; p=[SeasonEpisodePattern]::Lowercase_0X0 ; expected = $false}
    ) {
        # Test
        [ElementParser]::IsSeasonEpisodePattern($s, $p) | Should -Be $expected
    }

    It "IsValidTrackNumber" -ForEach @(
        @{s = "Foo"; expected = $false}
        @{s = "111a"; expected = $false}
        @{s = "a111"; expected = $false}
        @{s = "1"; expected = $true}
        @{s = "01"; expected = $true}
        @{s = "99"; expected = $true}
        @{s = "111"; expected = $true}
    ) {
        # Test
        [ElementParser]::IsValidTrackNumber($s) | Should -Be $expected
    }

    It "IsValidYear" -ForEach @(
        @{s = "Foo"; expected = $false}
        @{s = "0000"; expected = $false}
        @{s = "1929"; expected = $true}
        @{s = "2021"; expected = $true}
        @{s = "3400"; expected = $false}
        @{s = "82"; expected = $true}
        @{s = "821"; expected = $false}
        @{s = "8"; expected = $false}
    ) {
        # Test
        [ElementParser]::IsValidYear($s) | Should -Be $expected
    }

    It "GetSeason" -ForEach @(
        @{s = "Foo"; expected = $null}
        @{s = "S15E12"; expected = 15}
        @{s = "s15e12"; expected = 15}
        @{s = "15X12"; expected = 15}
        @{s = "15x12"; expected = 15}
    ) {
        # Test
        [ElementParser]::GetSeason($s) | Should -Be $expected
    }

    It "GetEpisode" -ForEach @(
        @{s = "Foo"; expected = $null}
        @{s = "S15E12"; expected = 12}
        @{s = "s15e12"; expected = 12}
        @{s = "15X12"; expected = 12}
        @{s = "15x12"; expected = 12}
    ) {
        # Test
        [ElementParser]::GetEpisode($s) | Should -Be $expected
    }

    It "SeasonEpisodeToString" -ForEach @(
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S1E2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S01E2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S1E02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S01E02"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s1e2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s01e2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s1e02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s01e02"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "1X2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "01X2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "1X02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "01X02"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "1x2"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "01x2"}
        @{season = 1; episode = 2; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "1x02"}
        @{season = 1; episode = 2; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "01x02"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_S0E0; expected = "S11E12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_S0E0; expected = "s11e12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Uppercase_0X0; expected = "11X12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 0; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
        @{season = 11; episode = 12; padSeason = 0; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
        @{season = 11; episode = 12; padSeason = 2; padEpisode = 2; pattern = [SeasonEpisodePattern]::Lowercase_0X0; expected = "11x12"}
    ) {
        # Test
        [ElementParser]::SeasonEpisodeToString($season, $episode, $padSeason, $padEpisode, $pattern) | Should -BeExactly $expected
    }
}

AfterAll {

}