#region Header
#
# About: Pseudo Interface 
#
# Author: Luca Gnezda 
#
# Circa:  2021 
#
#endregion Header


#region Using
#------------
using module .\IBase.Interface.psm1
#endregion Using


#region Interface Definition
#-----------------------
class IModelPersistenceService : IBase {
    IModelPersistenceService () {
        $this.AssertAsInterface([IModelPersistenceService])
    }
}