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
        
        # Throw if any of the interface method prototypes have not been overridden
        foreach ($method in $this.GetType().GetMethods()) {
            
            # Ignore this method and any SpecialName methods
            if (($method.Name -ne "AssertAsInterface") -and 
                (($method.Attributes -band [System.Reflection.MethodAttributes]::SpecialName) -ne [System.Reflection.MethodAttributes]::SpecialName)) { 
                
                # throw if any method is still defined by the Interface   
                if ($method.DeclaringType.Name -eq $thisInterfaceType.Name) {
                    throw [System.MissingMemberException] ("System.MissingMemberException: Could not find implementation of prototype method: " + $method.Name + " as defined in " + $thisInterfaceType.Name)
                }
            }
        }

        # Throw if any of the interface property prototypes have not been overridden
        foreach ($property in $this.GetType().GetProperties()) {
                
            # throw if any property is still defined by the Interface   
            if ($property.DeclaringType.Name -eq $thisInterfaceType.Name) {
                throw [System.MissingMemberException] ("System.MissingMemberException: Could not find implementation of prototype property: " + $property.Name + " as defined in " + $thisInterfaceType.Name)
            }
        }
    }
    #endregion Methods
}

#endregion Interface Definition