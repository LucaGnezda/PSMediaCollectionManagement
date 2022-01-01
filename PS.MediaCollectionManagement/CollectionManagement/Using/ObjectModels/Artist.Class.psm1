#region Header
#
# About: Artist class for PS.MediaCollectionManagement Module 
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
class Artist : ContentSubjectBase {

    #region Properties
    #endregion Properties


    #region Constructors
    Artist() : base() {
        $this.Init()
    }

    Artist([String] $name) : base($name) {
        $this.Init()
    }

    [Void] Hidden Init() {

        # Add an accessor (getter)
        $this | Add-Member -Name "PerformanceCount" -MemberType ScriptProperty -Value {
            return $this.Performed.Count
        } -Force

        # Add content Alias
        $this | Add-Member -Name "Performed" -MemberType AliasProperty -Value "_Content"

        # Set the detault table column order
        $DefaultProps = @("Name", "PerformanceCount", "Performed")
        $DefaultDisplay = New-Object System.Management.Automation.PSPropertySet("DefaultDisplayPropertySet",[string[]]$DefaultProps)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($DefaultDisplay)
        $this | Add-Member MemberSet PSStandardMembers $PSStandardMembers
    }

    #endregion Constructors


    #region Methods
    #endregion Methods
}

#endregion Class Definition