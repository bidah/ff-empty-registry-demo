import RegistryFamilyContract from Project.RegistryFamilyContract

  pub fun main(addr: Address): {UInt64: RegistryFamilyContract.Template}? {
    let account = getAccount(addr)
    
    if let ref = account.getCapability<&{RegistryFamilyContract.CollectionPublic}>(RegistryFamilyContract.CollectionPublicPath).borrow() {
      let collection = ref.listCollectibles()
      return collection
    }
    
    return nil

  }