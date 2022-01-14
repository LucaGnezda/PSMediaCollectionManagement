#region Header
#
# About: Pseudo Interface 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\..\..\Shared\Using\Base\IsInterface.Class.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IContentSubjectBO : IsInterface {
    IContentSubjectBO () {
        $this.AssertAsInterface([IContentSubjectBO])
    }

    [Type] ActsOnType() { return $null }
    [FilenameElement] ActsOnFilenameElement() { return $null }
    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) { }
}
