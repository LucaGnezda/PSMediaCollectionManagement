#region Header
#
# About: Pseudo Interface Baseclass
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
#endregion Using


#region Interface Definition
#---------------------------
class IsInterface {

    #region Properties
    #endregion Properties

    #region Constructors
    IsInterface () {
        $this.AssertAsInterface([IsInterface])
    }
    #endregion Constructors
    
    #region Methods
    [Void] Hidden AssertAsInterface ([Type] $thisInterfaceType) {
        
        # Throw if the current class is instantiated
        if ($this.GetType() -eq $thisInterfaceType) {
            throw [System.NotSupportedException] "System.NotSupportedException: Cannot instantiate an interface"
        } 
        
        # Throw if any of the interface prototypes have not been overridden
        foreach ($method in $this.GetType().GetMethods()) {
            if (($method.DeclaringType.Name -eq $thisInterfaceType.Name) -and 
                ($method.Name -ne "AssertAsInterface")){
                throw [System.MissingMemberException] ("System.MissingMemberException: Could not find implementation of prototype: " + $method.Name + " as defined in " + $thisInterfaceType.Name)
            }
        }
    }
    #endregion Methods
}

#endregion Interface Definition