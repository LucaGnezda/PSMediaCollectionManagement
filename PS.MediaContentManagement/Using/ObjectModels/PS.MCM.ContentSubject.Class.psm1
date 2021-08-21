#region Header
#
# About: Base class for content subject classes in PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
#endregion Using


#region Class Definition
#-----------------------
class ContentSubject {

    #region Properties
    [string] $Name
    [System.Collections.Generic.List[object]] Hidden $_Content
    #endregion Properties


    #region Constructors
    ContentSubject () {
        $this.ContentSubjectInit($null)
    }

    ContentSubject ([String] $name) {
        $this.ContentSubjectInit($name)
    }
    
    [Void] ContentSubjectInit ([String] $name) {

        $this.Name = $name

        # Initialise the PerformedIn List
        $this._Content = [System.Collections.Generic.List[object]]::new()

        # Add Members to the Content Generic List
        Add-Member -InputObject $this._Content -MemberType ScriptMethod -Name SortedBy -Value { 
            param ([String[]] $property) 
            return ($this | Sort-Object $property)
        } -Force

        Add-Member -InputObject $this._Content -MemberType ScriptMethod -Name Matching -value {
            param ([String] $s)
            return ($this | Where-Object {$_.Title -match $s})
        } -Force
    }
    #endregion Constructors
    
    
    #region Methods
    [String] ToString() {
        return $this.Name
    }

    [Object] Hidden GetRelatedContent() {
        return $this._Content
    }
    #endregion Methods
}
#endregion Class Definition