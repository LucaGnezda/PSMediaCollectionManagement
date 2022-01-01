#region Header
#
# About: Album class for PS.MediaCollectionManagement Module 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\ContentSubjectBase.Class.psm1
#endregion Using


#region Class Definition
#-----------------------
class Album : ContentSubjectBase {

    #region Properties
    [System.Collections.Generic.List[object]] $ProducedBy
    #endregion Properties
    

    #region Constructors
    Album() : base() {
        $this.Init($false)
    }

    Album([String] $name) : base($name) {
        $this.Init($false)
    }

    Album([String] $name, [Bool] $includeProducedBy) : base($name) {
        $this.Init($includeProducedBy)
    }

    [Void] Hidden Init([Bool] $includeProducedBy) {

        # Add an accessor (getter)
        $this | Add-Member -Name "TrackCount" -MemberType ScriptProperty -Value {
            return $this.Tracks.Count
        } -Force

        # Add content Alias
        $this | Add-Member -Name "Tracks" -MemberType AliasProperty -Value "_Content"

        # If required
        if ($includeProducedBy) { 

            # Initialise the collection
            $this.ProducedBy = [System.Collections.Generic.List[object]]::new()

            # Add Members to the ProducedBy Generic List
            Add-Member -InputObject $this.ProducedBy -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property) 
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.ProducedBy -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force
        }

        # Set the detault table column order
        $DefaultProps = [System.Collections.Generic.List[String]]@("Name", "TrackCount", "Tracks")
        if ($includeProducedBy) { $DefaultProps.Add("ProducedBy") }
        $DefaultProps = $DefaultProps.ToArray() 
        $DefaultDisplay = New-Object System.Management.Automation.PSPropertySet("DefaultDisplayPropertySet",[string[]]$DefaultProps)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($DefaultDisplay)
        $this | Add-Member MemberSet PSStandardMembers $PSStandardMembers
    }

    #endregion Constructors


    #region Methods
    #endregion Methods
}

#endregion Class Definition