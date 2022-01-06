#region Header
#
# About: Class for working with Actor objects 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\..\Types\Types.psm1
using module .\..\Interfaces\IContentSubjectBO.Interface.psm1
using module .\..\ObjectModels\ContentSubjectBase.Class.psm1
using module .\..\ObjectModels\Actor.Class.psm1
using module .\..\ObjectModels\Content.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class ActorBO : IContentSubjectBO {
    #region Properties
    #endregion Properties


    #region Constructors
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Actor]
    }

    [Void] ReplaceSubjectLinkedToContent([Content] $content, [ContentSubjectBase] $replace, [ContentSubjectBase] $with) {
        
        if (($replace.GetType() -eq [Actor]) -and ($with.GetType() -eq [Actor])) {
            $this.ReplaceActorLinkedWithContent($content, $replace, $with)
        }
        else {
            # Make no change
        }
    }

    [Void] ReplaceActorLinkedWithContent([Content] $content, [Actor] $replaceActor, [Actor] $withActor) {
        
        for ($i = 0; $i -lt $content.Actors.Count; $i++) {
            if ($content.Actors[$i] -eq $replaceActor) {
                $content.Actors[$i] = $withActor
            }
        }
        $withActor.PerformedIn.Add($content)
    }
    #endregion Methods

}
#endregion Class Definition