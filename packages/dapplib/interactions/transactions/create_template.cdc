import RegistryFamilyContract from Project.RegistryFamilyContract

transaction(dna: String, name: String) {

  var adminRef: &RegistryFamilyContract.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&RegistryFamilyContract.Admin>(from: RegistryFamilyContract.AdminStoragePath) ?? panic("Cannot borrow admin ref")
  }

  execute {
    self.adminRef.createTemplate(dna: dna, name: name)
  }
}
 