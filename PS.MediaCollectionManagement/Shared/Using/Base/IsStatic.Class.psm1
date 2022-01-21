#region Header
#
# About: Pseudo Abstract Baseclass
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
#endregion Using


#region Abstract Definition
#---------------------------
class IsStatic {

    #region Properties
    #endregion Properties

    #region Constructors
    IsStatic () {
        $this.AssertAsStatic([IsStatic])
    }
    #endregion Constructors
    
    #region Methods
    [Void] Hidden AssertAsStatic([Type] $thisStaticType) {
        
        # Throw if the current class is instantiated
        if ($this.GetType() -eq $thisStaticType) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate a static class"
        }
        else {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot inherit from a static class"
        } 
    }
    #endregion Methods
}

#endregion Abstract Definition