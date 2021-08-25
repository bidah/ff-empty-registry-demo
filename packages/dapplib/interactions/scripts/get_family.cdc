import RegistryFamilyContract from Project.RegistryFamilyContract

pub fun main(familyID: UInt32): RegistryFamilyContract.FamilyReport {
  let family = RegistryFamilyContract.getFamily(familyID: familyID)
  return family
}
