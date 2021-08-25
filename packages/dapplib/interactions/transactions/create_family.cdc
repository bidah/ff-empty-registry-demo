import RegistryFamilyContract from Project.RegistryFamilyContract

transaction(name: String, price: UFix64) {

  var adminRef: &RegistryFamilyContract.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&RegistryFamilyContract.Admin>(from: RegistryFamilyContract.AdminStoragePath) ?? panic("Cannot borrow admin ref")
  }

  execute {
    self.adminRef.createFamily(name: name, price: price)
  }
}
 