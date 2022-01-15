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
class IsAbstract {

    #region Properties
    #endregion Properties

    #region Constructors
    IsAbstract () {
        $this.AssertAsAbstract([IsAbstract])
    }
    #endregion Constructors
    
    #region Methods
    [Void] Hidden AssertAsAbstract([Type] $thisAbstractType) {
        
        # Throw if the current class is instantiated
        if ($this.GetType() -eq $thisAbstractType) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an abstract class"
        } 
    }
    #endregion Methods
}

#endregion Abstract Definition