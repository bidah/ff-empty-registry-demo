import RegistryFamilyContract from Project.RegistryFamilyContract
  
pub fun main(addr: Address): Bool {
  let ref = getAccount(addr).getCapability<&{RegistryFamilyContract.CollectionPublic}>(RegistryFamilyContract.CollectionPublicPath).check()
  return ref
}