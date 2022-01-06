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
using module .\IBase.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IContentSubjectBO : IBase {
    IContentSubjectBO () {
        $this.AssertAsInterface([IContentSubjectBO])
    }

    [Type] ActsOnType() { return $null }
    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) { }
}
