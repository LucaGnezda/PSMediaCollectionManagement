using module .\..\PS.MediaContentManagement\Using\Helpers\PS.MCM.FileMetadataProperty.Class.psm1

BeforeAll { 

}

Describe "FileMetadataProperty Helper Unit Test" -Tag UnitTest {
    BeforeEach {
        
    }
    
    It "Instantiation" {
        # Do
        $fmd = [FileMetadataProperty]::new(1, "Foo", "Bar")

        # Test
        $fmd.Index | Should -Be 1
        $fmd.Property | Should -Be "Foo"
        $fmd.Value | Should -Be "Bar"
    }
}