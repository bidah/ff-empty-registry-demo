
import RegistryFamilyContract from Project.RegistryFamilyContract

transaction(familyID: UInt32, templateID: UInt32) {

  var adminRef: &RegistryFamilyContract.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&RegistryFamilyContract.Admin>(from: RegistryFamilyContract.AdminStoragePath) ?? panic("Cannot borrow admin ref")
  }

  execute {
    let familyRef = self.adminRef.borrowFamily(familyID: familyID)
    familyRef.addTemplate(templateID: templateID)
  }
}