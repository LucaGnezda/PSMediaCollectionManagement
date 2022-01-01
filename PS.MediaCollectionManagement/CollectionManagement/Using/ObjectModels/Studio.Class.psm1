#region Header
#
# About: Studio class for PS.MediaCollectionManagement Module 
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
class Studio : ContentSubjectBase {

    #region Properties
    [System.Collections.Generic.List[object]] $ProducedAlbums
    [System.Collections.Generic.List[object]] $ProducedSeries
    #endregion Properties
    

    #region Constructors
    Studio() : base() {
        $this.Init($false, $false)
    }

    Studio([String] $name) : base($name) {
        $this.Init($false, $false)
    }

    Studio([String] $name, [Bool] $includeProducedAlbums, [Bool] $includeProducedSeries) : base($name) {
        $this.Init($includeProducedAlbums, $includeProducedSeries)
    }

    [Void] Hidden Init([Bool] $includeProducedAlbums, [Bool] $includeProducedSeries) {

        # Add an accessor (getter)
        $this | Add-Member -Name "ProductionCount" -MemberType ScriptProperty -Value {
            return $this.Produced.Count
        } -Force

        # Add content Alias
        $this | Add-Member -Name "Produced" -MemberType AliasProperty -Value "_Content"

        # If required
        if ($includeProducedAlbums) { 

            # Initialise the collection
            $this.ProducedAlbums = [System.Collections.Generic.List[object]]::new()

            # Add Members to the ProducedAlbums Generic List
            Add-Member -InputObject $this.ProducedAlbums -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property) 
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.ProducedAlbums -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force
        }

        # If required
        if ($includeProducedSeries) { 

            # Initialise the collection
            $this.ProducedSeries = [System.Collections.Generic.List[object]]::new()

            # Add Members to the ProducedSeries Generic List
            Add-Member -InputObject $this.ProducedSeries -MemberType ScriptMethod -Name SortedBy -Value { 
                param ([String[]] $property) 
                return ($this | Sort-Object $property)
            } -Force

            Add-Member -InputObject $this.ProducedSeries -MemberType ScriptMethod -Name Matching -value {
                param ([String] $s)
                return ($this | Where-Object {$_.Name -match $s})
            } -Force
        }

        # Set the detault table column order
        $DefaultProps = [System.Collections.Generic.List[String]]@("Name", "ProductionCount", "Produced")
        if ($includeProducedAlbums) { $DefaultProps.Add("ProducedAlbums") }
        if ($includeProducedSeries) { $DefaultProps.Add("ProducedSeries") }
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