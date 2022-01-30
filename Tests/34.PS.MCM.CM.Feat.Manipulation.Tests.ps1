using module .\..\PS.MediaCollectionManagement\FilesystemExtensions\Using\ModuleBehaviour\FilesystemExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\ConsoleExtensions\Using\ModuleBehaviour\ConsoleExtensionsState.Singleton.psm1
using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Types\Types.psm1

BeforeAll { 
    Import-Module $PSScriptRoot\..\PS.MediaCollectionManagement\PS.MediaCollectionManagement.psd1 -Force

    [ConsoleExtensionsState]::RedirectToMockConsole = $true
    [FilesystemExtensionsState]::MockDestructiveActions = $true
    
}

Describe "ContentModel.RemodelFilenameFormat Integration Test" -Tag IntegrationTest {
    BeforeEach {
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)
    }

    It "Remodel" {
        # Test
        $contentModel.Content[0].Basename | Should -Be "Foo - Cherry, Apple, Banana, Pear - Delta"
        $contentModel.RemodelFilenameFormat(-1,1) | Should -Be $false 
        $contentModel.RemodelFilenameFormat(4,1) | Should -Be $false
        $contentModel.RemodelFilenameFormat(1,-1) | Should -Be $false 
        $contentModel.RemodelFilenameFormat(1,4) | Should -Be $false 

        # Test
        $contentModel.RemodelFilenameFormat(1,2) | Should -Be $true

        # Test
        $contentModel.Content[0].Basename | Should -Be "Foo - Delta - Cherry, Apple, Banana, Pear"

    }

    It "Remodel with update" {
        # Test
        $contentModel.RemodelFilenameFormat(1,2, $true) | Should -Be $true

        # Test
        $contentModel.Content[0].Basename | Should -Be "Foo - Delta - Cherry, Apple, Banana, Pear"

    }

    It "Remodel with update and path" {
        # Test
        $contentModel.RemodelFilenameFormat(1,2, ".\", $true) | Should -Be $true

        # Test
        $contentModel.Content[0].Basename | Should -Be "Foo - Delta - Cherry, Apple, Banana, Pear"

    }
}

Describe "ContentModel.AlterActor Integration Test" -Tag IntegrationTest {

    It "Alter Actor" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        # Test 
        $contentModel.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Test
        $contentModel.AlterActor("Apple", "Alice") | Should -Be $true
        $contentModel.Actors | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModel.Actors.Matching("Alice").PerformedIn.Count | Should -Be 2

        # Test
        $contentModel.AlterActor("Banana", "Bob") | Should -Be $true
        $contentModel.Actors | Should -Be @("Cherry", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModel.Actors.Matching("Bob").PerformedIn.Count | Should -Be 2

        # Test
        $contentModel.AlterActor("Cherry", "Charlie") | Should -Be $true
        $contentModel.Actors | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModel.Actors.Matching("Charlie").PerformedIn.Count | Should -Be 2

        # Test
        $contentModel.AlterActor("Ecky", "Alice") | Should -Be $true
        $contentModel.Actors | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModel.Actors.Matching("Alice").PerformedIn.Count | Should -Be 3

        # Test
        $contentModel.AlterActor("Missing", "Alice") | Should -Be $false
        $contentModel.Actors | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModel.Actors.Matching("Alice").PerformedIn.Count | Should -Be 3
        $contentModel.Actors.Matching("Missing") | Should -Be $null
    }

    It "Alter Actor with update" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        # Test 
        $contentModel.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Test
        $contentModel.AlterActor("Apple", "Alice", $true) | Should -Be $true
        $contentModel.Actors | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModel.Actors.Matching("Alice").PerformedIn.Count | Should -Be 2
    }

    It "Alter Actor with update and path" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        # Test 
        $contentModel.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Test
        $contentModel.AlterActor("Apple", "Alice", ".\", $true) | Should -Be $true
        $contentModel.Actors | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModel.Actors.Matching("Alice").PerformedIn.Count | Should -Be 2
    }

    It "Alter Actor - Colision" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputB.json", $true)

        # Test 
        $contentModel.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
        
        # Test
        $contentModel.AlterActor("Cherry2", "Cherry") | Should -Be $false
        $contentModel.Actors | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
    }
}

Describe "ContentModel.AlterAlbum Integration Test" -Tag IntegrationTest {

    It "Alter Album" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)

        # Test 
        $contentModel.Albums | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterAlbum("Foo", "Studio A") | Should -Be $true
        $contentModel.Albums | Should -Be @("Studio A", "Zim")
        $contentModel.Albums.Matching("Studio A").Tracks.Count | Should -Be 2

        # Test
        $contentModel.AlterAlbum("Missing", "Studio B") | Should -Be $false
        $contentModel.Albums | Should -Be @("Studio A", "Zim")
        $contentModel.Albums.Matching("Studio B") | Should -Be $null
    }

    It "Alter Album with update" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)

        # Test 
        $contentModel.Albums | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterAlbum("Foo", "Studio A", $true) | Should -Be $true
        $contentModel.Albums | Should -Be @("Studio A", "Zim")
        $contentModel.Albums.Matching("Studio A").Tracks.Count | Should -Be 2
    }

    It "Alter Album with update and path" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)

        # Test 
        $contentModel.Albums | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterAlbum("Foo", "Studio A", ".\", $true) | Should -Be $true
        $contentModel.Albums | Should -Be @("Studio A", "Zim")
        $contentModel.Albums.Matching("Studio A").Tracks.Count | Should -Be 2
    }

    It "Alter Album - Colision" {
        # Do 
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputF.json", $true)

        # Test 
        $contentModel.Albums | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
        
        # Test
        $contentModel.AlterAlbum("Zim2", "Zim") | Should -Be $false
        $contentModel.Albums | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
    }

    It "Alter Album - Cross reference with studios" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputG.json", $true)

        # Test
        $contentModel.AlterAlbum("AlbA", "AlbB") | Should -Be $true
        $contentModel.Albums[0].Name | Should -Be "AlbB"
        $contentModel.Albums[1].Name | Should -Be "AlbC"
        $contentModel.Studios[0].ProducedAlbums[0] | Should -Be "AlbB"
        $contentModel.Studios[1].ProducedAlbums[0] | Should -Be "AlbB"
        $contentModel.Studios[2].ProducedAlbums[0] | Should -Be "AlbC"
        $contentModel.Albums[0].ProducedBy[0] | Should -Be "StuB"
        $contentModel.Albums[0].ProducedBy[1] | Should -Be "StuA"
        $contentModel.Albums[1].ProducedBy[0] | Should -Be "StuC"
    }
}

Describe "ContentModel.AlterArtist Integration Test" -Tag IntegrationTest {

    It "Alter Artist" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)

        # Test 
        $contentModel.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Test
        $contentModel.AlterArtist("Apple", "Alice") | Should -Be $true
        $contentModel.Artists | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModel.Artists.Matching("Alice").Performed.Count | Should -Be 2

        # Test
        $contentModel.AlterArtist("Banana", "Bob") | Should -Be $true
        $contentModel.Artists | Should -Be @("Cherry", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModel.Artists.Matching("Bob").Performed.Count | Should -Be 2

        # Test
        $contentModel.AlterArtist("Cherry", "Charlie") | Should -Be $true
        $contentModel.Artists | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ecky", "Ni")
        $contentModel.Artists.Matching("Charlie").Performed.Count | Should -Be 2

        # Test
        $contentModel.AlterArtist("Ecky", "Alice") | Should -Be $true
        $contentModel.Artists | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModel.Artists.Matching("Alice").Performed.Count | Should -Be 3

        # Test
        $contentModel.AlterArtist("Missing", "Alice") | Should -Be $false
        $contentModel.Artists | Should -Be @("Charlie", "Alice", "Bob", "Pear", "Ni")
        $contentModel.Artists.Matching("Alice").Performed.Count | Should -Be 3
        $contentModel.Artists.Matching("Missing") | Should -Be $null
    }

    It "Alter Artist with update" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)

        # Test 
        $contentModel.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Test
        $contentModel.AlterArtist("Apple", "Alice", $true) | Should -Be $true
        $contentModel.Artists | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModel.Artists.Matching("Alice").Performed.Count | Should -Be 2
    }

    It "Alter Artist with update and path" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputE.json", $true)

        # Test 
        $contentModel.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni")
        
        # Test
        $contentModel.AlterArtist("Apple", "Alice", ".\", $true) | Should -Be $true
        $contentModel.Artists | Should -Be @("Cherry", "Alice", "Banana", "Pear", "Ecky", "Ni")
        $contentModel.Artists.Matching("Alice").Performed.Count | Should -Be 2
    }

    It "Alter Artist - Colision" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputF.json", $true)

        # Test 
        $contentModel.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
        
        # Test
        $contentModel.AlterArtist("Cherry2", "Cherry") | Should -Be $false
        $contentModel.Artists | Should -Be @("Cherry", "Apple", "Banana", "Pear", "Ecky", "Ni", "Cherry2")
    }
}

Describe "ContentModel.AlterSeries Integration Test" -Tag IntegrationTest {

    It "Alter Series" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputC.json", $true)

        # Test 
        $contentModel.Series | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterSeries("Foo", "Series A") | Should -Be $true
        $contentModel.Series | Should -Be @("Series A", "Zim")
        $contentModel.Series.Matching("Series A").Episodes.Count | Should -Be 2

        # Test
        $contentModel.AlterSeries("Missing", "Series B") | Should -Be $false
        $contentModel.Series | Should -Be @("Series A", "Zim")
        $contentModel.Series.Matching("Series B") | Should -Be $null
    }

    It "Alter Series with update" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputC.json", $true)

        # Test 
        $contentModel.Series | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterSeries("Foo", "Series A", $true) | Should -Be $true
        $contentModel.Series | Should -Be @("Series A", "Zim")
        $contentModel.Series.Matching("Series A").Episodes.Count | Should -Be 2
    }

    It "Alter Series with update and path" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputC.json", $true)

        # Test 
        $contentModel.Series | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterSeries("Foo", "Series A", ".\", $true) | Should -Be $true
        $contentModel.Series | Should -Be @("Series A", "Zim")
        $contentModel.Series.Matching("Series A").Episodes.Count | Should -Be 2
    }

    It "Alter Series - Colision" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputD.json", $true)

        # Test 
        $contentModel.Series | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
        
        # Test
        $contentModel.AlterSeries("Zim2", "Zim") | Should -Be $false
        $contentModel.Series | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
    }

    It "Alter Series - Cross reference with studios" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputF.json", $true)

        # Test
        $contentModel.AlterSeries("SerA", "SerB") | Should -Be $true
        $contentModel.Series[0].Name | Should -Be "SerB"
        $contentModel.Series[1].Name | Should -Be "SerC"
        $contentModel.Studios[0].ProducedSeries[0] | Should -Be "SerB"
        $contentModel.Studios[1].ProducedSeries[0] | Should -Be "SerB"
        $contentModel.Studios[2].ProducedSeries[0] | Should -Be "SerC"
        $contentModel.Series[0].ProducedBy[0] | Should -Be "StuB"
        $contentModel.Series[0].ProducedBy[1] | Should -Be "StuA"
        $contentModel.Series[1].ProducedBy[0] | Should -Be "StuC"
    }
}

Describe "ContentModel.AlterStudio Integration Test" -Tag IntegrationTest {

    It "Alter Studio" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        # Test 
        $contentModel.Studios | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterStudio("Foo", "Studio A") | Should -Be $true
        $contentModel.Studios | Should -Be @("Studio A", "Zim")
        $contentModel.Studios.Matching("Studio A").Produced.Count | Should -Be 2

        # Test
        $contentModel.AlterStudio("Missing", "Studio B") | Should -Be $false
        $contentModel.Studios | Should -Be @("Studio A", "Zim")
        $contentModel.Studios.Matching("Studio B") | Should -Be $null
    }

    It "Alter Studio with update" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        # Test 
        $contentModel.Studios | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterStudio("Foo", "Studio A", $true) | Should -Be $true
        $contentModel.Studios | Should -Be @("Studio A", "Zim")
        $contentModel.Studios.Matching("Studio A").Produced.Count | Should -Be 2
    }

    It "Alter Studio with update and path" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputA.json", $true)

        # Test 
        $contentModel.Studios | Should -Be @("Foo", "Zim")
        
        # Test
        $contentModel.AlterStudio("Foo", "Studio A", ".\", $true) | Should -Be $true
        $contentModel.Studios | Should -Be @("Studio A", "Zim")
        $contentModel.Studios.Matching("Studio A").Produced.Count | Should -Be 2
    }

    It "Alter Studio - Colision" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestC\index.test.inputB.json", $true)

        # Test 
        $contentModel.Studios | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
        
        # Test
        $contentModel.AlterStudio("Zim2", "Zim") | Should -Be $false
        $contentModel.Studios | Should -Be @("Fooo", "Foo", "Zim", "Zim2")
    }

    It "Alter Studio - Cross reference with albums" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputG.json", $true)

        # Test
        $contentModel.AlterStudio("StuB", "StuA") | Should -Be $true
        $contentModel.Studios[0].Name | Should -Be "StuA"
        $contentModel.Studios[1].Name | Should -Be "StuC"
        $contentModel.Studios[0].ProducedAlbums[0] | Should -Be "AlbA"
        $contentModel.Studios[0].ProducedAlbums[1] | Should -Be "AlbB"
        $contentModel.Studios[1].ProducedAlbums[0] | Should -Be "AlbC"
        $contentModel.Albums[0].ProducedBy[0] | Should -Be "StuA"
        $contentModel.Albums[1].ProducedBy[0] | Should -Be "StuA"
        $contentModel.Albums[2].ProducedBy[0] | Should -Be "StuC"
    }

    It "Alter Studio - Cross reference with series" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputF.json", $true)

        # Test
        $contentModel.AlterStudio("StuB", "StuA") | Should -Be $true
        $contentModel.Studios[0].Name | Should -Be "StuA"
        $contentModel.Studios[1].Name | Should -Be "StuC"
        $contentModel.Studios[0].ProducedSeries[0] | Should -Be "SerA"
        $contentModel.Studios[0].ProducedSeries[1] | Should -Be "SerB"
        $contentModel.Studios[1].ProducedSeries[0] | Should -Be "SerC"
        $contentModel.Series[0].ProducedBy[0] | Should -Be "StuA"
        $contentModel.Series[1].ProducedBy[0] | Should -Be "StuA"
        $contentModel.Series[2].ProducedBy[0] | Should -Be "StuC"
    }

    It "Alter - No change" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputF.json", $true)

        # Test
        $contentModel.AlterStudio("StuB", "StuB") | Should -Be $false
    }

    It "Alter - Does not exist" {
        # Do
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputF.json", $true)

        # Test
        $contentModel.AlterStudio("Doesnotexist", "StuB") | Should -Be $false
    }

    It "Alter - not initialised" {
        # Do
        $contentModel = New-ContentModel

        # Test
        { $contentModel.AlterStudio("Doesnotexist", "StuB") } | Should -Throw
    }
}

Describe "ContentModel.AlterSeasonEpisodeFormat Integration Test" -Tag IntegrationTest {
    BeforeEach {
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputC.json", $true)
    }

    It "Alter SeasonEpisode - Initial" {
        # Test
        $contentModel.Content[0].Season | Should -Be 1
        $contentModel.Content[1].Season | Should -Be 2
        $contentModel.Content[2].Season | Should -Be 3
        $contentModel.Content[3].Season | Should -Be 4
        $contentModel.Content[4].Season | Should -Be $null
        $contentModel.Content[0].Episode | Should -Be 5
        $contentModel.Content[1].Episode | Should -Be 6
        $contentModel.Content[2].Episode | Should -Be 7
        $contentModel.Content[3].Episode | Should -Be 8
        $contentModel.Content[4].Episode | Should -Be $null
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 01x05"
        $contentModel.Content[1].Basename | Should -BeExactly "Foo - Banana - 2X6"
        $contentModel.Content[2].Basename | Should -BeExactly "Foo - Cherry - s03e07"
        $contentModel.Content[3].Basename | Should -BeExactly "Foo - Pear - s4e8"
        $contentModel.Content[4].Basename | Should -BeExactly "Foo - Zim - Unknown"
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[1].AlteredBaseName | Should -Be $false
        $contentModel.Content[2].AlteredBaseName | Should -Be $false
        $contentModel.Content[3].AlteredBaseName | Should -Be $false
        $contentModel.Content[4].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[1].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[2].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[3].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[4].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].SeasonEpisode | Should -BeExactly "01x05"
        $contentModel.Content[1].SeasonEpisode | Should -BeExactly "2X6"
        $contentModel.Content[2].SeasonEpisode | Should -BeExactly "s03e07"
        $contentModel.Content[3].SeasonEpisode | Should -BeExactly "s4e8"
        $contentModel.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to S0E0 no padding" {
        # Test
        $contentModel.AlterSeasonEpisodeFormat(0, 0, [SeasonEpisodePattern]::Uppercase_S0E0) | Should -Be $true
        $contentModel.Content[0].Season | Should -Be 1
        $contentModel.Content[0].Episode | Should -Be 5
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - S1E5"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].SeasonEpisode | Should -BeExactly "S1E5"
        $contentModel.Content[1].SeasonEpisode | Should -BeExactly "S2E6"
        $contentModel.Content[2].SeasonEpisode | Should -BeExactly "S3E7"
        $contentModel.Content[3].SeasonEpisode | Should -BeExactly "S4E8"
        $contentModel.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to s0s0 padding s2" {
        # Test
        $contentModel.AlterSeasonEpisodeFormat(2, 0, [SeasonEpisodePattern]::Lowercase_S0E0) | Should -Be $true
        $contentModel.Content[0].Season | Should -Be 1
        $contentModel.Content[0].Episode | Should -Be 5
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - s01e5"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].SeasonEpisode | Should -BeExactly "s01e5"
        $contentModel.Content[1].SeasonEpisode | Should -BeExactly "s02e6"
        $contentModel.Content[2].SeasonEpisode | Should -BeExactly "s03e7"
        $contentModel.Content[3].SeasonEpisode | Should -BeExactly "s04e8"
        $contentModel.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to 0X0 padding e2" {
        # Test
        $contentModel.AlterSeasonEpisodeFormat(0, 2, [SeasonEpisodePattern]::Uppercase_0X0) | Should -Be $true
        $contentModel.Content[0].Season | Should -Be 1
        $contentModel.Content[0].Episode | Should -Be 5
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 1X05"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].SeasonEpisode | Should -BeExactly "1X05"
        $contentModel.Content[1].SeasonEpisode | Should -BeExactly "2X06"
        $contentModel.Content[2].SeasonEpisode | Should -BeExactly "3X07"
        $contentModel.Content[3].SeasonEpisode | Should -BeExactly "4X08"
        $contentModel.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - Alter to 0x0 padding s3 e2" {
        # Test
        $contentModel.AlterSeasonEpisodeFormat(3, 2, [SeasonEpisodePattern]::Lowercase_0X0) | Should -Be $true
        $contentModel.Content[0].Season | Should -Be 1
        $contentModel.Content[0].Episode | Should -Be 5
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 001x05"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].SeasonEpisode | Should -BeExactly "001x05"
        $contentModel.Content[1].SeasonEpisode | Should -BeExactly "002x06"
        $contentModel.Content[2].SeasonEpisode | Should -BeExactly "003x07"
        $contentModel.Content[3].SeasonEpisode | Should -BeExactly "004x08"
        $contentModel.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - with update" {
        # Test
        $contentModel.AlterSeasonEpisodeFormat(3, 2, [SeasonEpisodePattern]::Lowercase_0X0, $true) | Should -Be $true
        $contentModel.Content[0].Season | Should -Be 1
        $contentModel.Content[0].Episode | Should -Be 5
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 001x05"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].SeasonEpisode | Should -BeExactly "001x05"
        $contentModel.Content[1].SeasonEpisode | Should -BeExactly "002x06"
        $contentModel.Content[2].SeasonEpisode | Should -BeExactly "003x07"
        $contentModel.Content[3].SeasonEpisode | Should -BeExactly "004x08"
        $contentModel.Content[4].SeasonEpisode | Should -BeExactly ""
    }

    It "Alter SeasonEpisode - with update and path" {
        # Test
        $contentModel.AlterSeasonEpisodeFormat(3, 2, [SeasonEpisodePattern]::Lowercase_0X0, ".\", $true) | Should -Be $true
        $contentModel.Content[0].Season | Should -Be 1
        $contentModel.Content[0].Episode | Should -Be 5
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 001x05"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].SeasonEpisode | Should -BeExactly "001x05"
        $contentModel.Content[1].SeasonEpisode | Should -BeExactly "002x06"
        $contentModel.Content[2].SeasonEpisode | Should -BeExactly "003x07"
        $contentModel.Content[3].SeasonEpisode | Should -BeExactly "004x08"
        $contentModel.Content[4].SeasonEpisode | Should -BeExactly ""
    }
}

Describe "ContentModel.AlterTrackFormat Integration Test" -Tag IntegrationTest {
    BeforeEach {
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputD.json", $true)
    }

    It "Alter Track - Initial" {
        # Test
        $contentModel.Content[0].Track | Should -Be 1
        $contentModel.Content[1].Track | Should -Be 2
        $contentModel.Content[2].Track | Should -Be 3
        $contentModel.Content[3].Track | Should -Be 4
        $contentModel.Content[4].Track | Should -Be $null
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 01"
        $contentModel.Content[1].Basename | Should -BeExactly "Foo - Banana - 2"
        $contentModel.Content[2].Basename | Should -BeExactly "Foo - Cherry - 003"
        $contentModel.Content[3].Basename | Should -BeExactly "Foo - Pear - 4"
        $contentModel.Content[4].Basename | Should -BeExactly "Foo - Zim - Unknown"
        $contentModel.Content[0].AlteredBaseName | Should -Be $false
        $contentModel.Content[1].AlteredBaseName | Should -Be $false
        $contentModel.Content[2].AlteredBaseName | Should -Be $false
        $contentModel.Content[3].AlteredBaseName | Should -Be $false
        $contentModel.Content[4].AlteredBaseName | Should -Be $false
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[1].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[2].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[3].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[4].PendingFilenameUpdate | Should -Be $false
        $contentModel.Content[0].TrackLabel | Should -BeExactly "01"
        $contentModel.Content[1].TrackLabel | Should -BeExactly "2"
        $contentModel.Content[2].TrackLabel | Should -BeExactly "003"
        $contentModel.Content[3].TrackLabel | Should -BeExactly "4"
        $contentModel.Content[4].TrackLabel | Should -BeExactly ""
    }

    It "Alter Track - Alter to no padding" {
        # Test
        $contentModel.AlterTrackFormat(0) | Should -Be $true
        $contentModel.Content[0].Track | Should -Be 1
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 1"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].TrackLabel | Should -BeExactly "1"
        $contentModel.Content[1].TrackLabel | Should -BeExactly "2"
        $contentModel.Content[2].TrackLabel | Should -BeExactly "3"
        $contentModel.Content[3].TrackLabel | Should -BeExactly "4"
        $contentModel.Content[4].TrackLabel | Should -BeExactly ""
    }

    It "Alter Track - Alter to padding 2" {
        # Test
        $contentModel.AlterTrackFormat(3) | Should -Be $true
        $contentModel.Content[0].Track | Should -Be 1
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 001"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].TrackLabel | Should -BeExactly "001"
        $contentModel.Content[1].TrackLabel | Should -BeExactly "002"
        $contentModel.Content[2].TrackLabel | Should -BeExactly "003"
        $contentModel.Content[3].TrackLabel | Should -BeExactly "004"
        $contentModel.Content[4].TrackLabel | Should -BeExactly ""
    }

    It "Alter Track - Alter to padding with update" {
        # Test
        $contentModel.AlterTrackFormat(3, $true) | Should -Be $true
        $contentModel.Content[0].Track | Should -Be 1
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 001"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].TrackLabel | Should -BeExactly "001"
        $contentModel.Content[1].TrackLabel | Should -BeExactly "002"
        $contentModel.Content[2].TrackLabel | Should -BeExactly "003"
        $contentModel.Content[3].TrackLabel | Should -BeExactly "004"
        $contentModel.Content[4].TrackLabel | Should -BeExactly ""
    }

    It "Alter Track - Alter to padding with update and path" {
        # Test
        $contentModel.AlterTrackFormat(3, ".\", $true) | Should -Be $true
        $contentModel.Content[0].Track | Should -Be 1
        $contentModel.Content[0].Basename | Should -BeExactly "Foo - Apple - 001"
        $contentModel.Content[0].AlteredBaseName | Should -Be $true
        $contentModel.Content[0].PendingFilenameUpdate | Should -Be $true
        $contentModel.Content[0].TrackLabel | Should -BeExactly "001"
        $contentModel.Content[1].TrackLabel | Should -BeExactly "002"
        $contentModel.Content[2].TrackLabel | Should -BeExactly "003"
        $contentModel.Content[3].TrackLabel | Should -BeExactly "004"
        $contentModel.Content[4].TrackLabel | Should -BeExactly ""
    }
}

Describe "ContentModel.ApplyAllPendingFilenameChanges Integration Test" -Tag IntegrationTest {
    BeforeEach {
        $contentModel = New-ContentModel
        $contentModel.LoadIndex("$PSScriptRoot\TestData\ContentTestF\index.test.inputD.json", $true)
    }

    It "ApplyAllPendingFilenameChanges" {
        # Test
        $contentModel.AlterTrackFormat(3) | Should -Be $true
        $contentModel.ApplyAllPendingFilenameChanges()
    }

    It "ApplyAllPendingFilenameChanges with path" {
        # Test
        $contentModel.AlterTrackFormat(3) | Should -Be $true
        $contentModel.ApplyAllPendingFilenameChanges(".\")
    }
}

AfterAll {
    [ConsoleExtensionsState]::RedirectToMockConsole = $false
    [FilesystemExtensionsState]::MockDestructiveActions = $false
}