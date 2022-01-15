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
using module .\..\ObjectModels\ContentModelConfig.Class.psm1
#endregion Using



#region Types
#------------
#endregion Types


#region Class Definition
#-----------------------
class ActorBO : IContentSubjectBO {
    
    #region Properties
    [ContentModelConfig] $Config
    #endregion Properties


    #region Constructors
    ActorBO([ContentModelConfig] $config) {
        if (-not $config.IsFilenameFormatLocked) {
            throw [System.InvalidOperationException] "System.InvalidOperationException: ContentBO Cannot be instantiated successfully a without a committed Filename Format."
        }
        $this.Config = $config
    }
    #endregion Constructors


    #region Methods
    [Type] ActsOnType() { 
        return [Actor]
    }

    [FilenameElement] ActsOnFilenameElement() {
        return [FilenameElement]::Actors
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

    [Void] AddActorRelationshipsWithContent([Content] $content, [System.Collections.Generic.List[ContentSubjectBase]] $actorsList, [String[]] $actorNamesToAdd) {
        
        # for each Actor
        foreach ($actorName in $actorNamesToAdd) {

            # Decorate Actors that are actually tags
            if ($actorName -in $this.Config.DecorateAsTags){
                $actorName = $this.Config.TagOpenDelimiter + $actorName + $this.Config.TagCloseDelimiter
            } 
    
            # If the Actor name already exists, grab that one, otherwise create a new Actor
            if ($actorsList.Count -eq 0) {
                $actor = [Actor]::new($actorName)
                $actorsList.Add($actor)
            }
            elseif ($actorName -cin $actorsList.Name) {
                $actor = $actorsList.Find({$args[0].Name -ceq $actorName})
            }
            else {
                $actor = [Actor]::new($actorName)
                $actorsList.Add($actor)
            }
    
            # two way link the Actor and content objects
            $content.Actors.Add($actor)
            $actor.PerformedIn.Add($content)
        }
    }

    [Void] RemoveActorRelationshipsWithContentAndCleanup([System.Collections.Generic.List[ContentSubjectBase]] $actorsList, [Content] $contentToRemove) {

        # For each actor linked to the content
        foreach ($actor in $contentToRemove.Actors) {

            # Delete the reference back to the content to be deleted
            $actor.PerformedIn.Remove($contentToRemove)

            # If no references remain, delete the actor too
            if ($actor.PerformedIn.Count -eq 0) {
                $actorsList.Remove($actor)
            }
        }
    }
    #endregion Methods

}
#endregion Class Definition