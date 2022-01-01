using module .\..\PS.MediaCollectionManagement\CollectionManagement\Using\Helpers\ContentComparer.Class.psm1

BeforeAll { 

}

Describe "ContentComparer Helper Unit Test" -Tag UnitTest {
    It "Instantiation" {
        # Do
        $comp1 = [ContentComparer]::new("FileName")
        $comp2 = [ContentComparer]::new("FileName", $true)

        # Test
        $comp1.PropertyName | Should -Be "Filename"
        $comp1.Descending | Should -Be $false
        $comp2.PropertyName | Should -Be "Filename"
        $comp2.Descending | Should -Be $true
    }

    It "Comparision" {
        # Do
        $obj1 = [PSCustomObject]::new()
        $obj1 | Add-Member NoteProperty "Filename" "Foo.txt"
        $obj2 = [PSCustomObject]::new()
        $obj2 | Add-Member NoteProperty "Filename" "Bar.txt"
        $comp = [ContentComparer]::new("FileName", $true)

        # Test
        $comp.Compare($obj1, $obj2) | Should -Be -1
    }
}