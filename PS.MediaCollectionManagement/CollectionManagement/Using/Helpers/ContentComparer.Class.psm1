#region Header
#
# About: ModuleSettings class for PS.MediaCollectionManagement Module 
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
class ContentComparer : System.Collections.Generic.IComparer[Object]
{
    #region Properties
    [string]$PropertyName
    [bool]$Descending = $false
    #endregion Properties


    #region Constructors
    ContentComparer([string]$property) {
        $this.PropertyName = $property
    }

    ContentComparer([string]$property, [bool]$descending) {
        $this.PropertyName = $property
        $this.Descending = $descending
    }
    #endregion Constructors


    #region Methods
    [int]Compare([Object]$a, [Object]$b) {

        $res = if($a.$($this.PropertyName) -eq $b.$($this.PropertyName))
        {
            0
        }
        elseif($a.$($this.PropertyName) -lt $b.$($this.PropertyName))
        {
            -1
        }
        else
        {
            1
        }

        if($this.Descending){
            $res *= -1
        }

        return $res 
    }
    #endregion Methods

}
#endregion Class Definition