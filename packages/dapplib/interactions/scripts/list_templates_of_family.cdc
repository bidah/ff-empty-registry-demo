import RegistryFamilyContract from Project.RegistryFamilyContract

pub fun main(familyID: UInt32): [UInt32] {
  let templates = RegistryFamilyContract.listFamilyTemplates(familyID: familyID)
  return templates
}