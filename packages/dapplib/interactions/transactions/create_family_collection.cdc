import RegistryFamilyContract from Project.RegistryFamilyContract
import RegistryService from Project.RegistryService
  
  transaction {
    prepare(acct: AuthAccount) {
      let collection <- RegistryFamilyContract.createEmptyCollection()
      acct.save<@RegistryFamilyContract.Collection>(<-collection, to: RegistryFamilyContract.CollectionStoragePath)
      acct.link<&{RegistryFamilyContract.CollectionPublic}>(RegistryFamilyContract.CollectionPublicPath, target: RegistryFamilyContract.CollectionStoragePath)
    }

    execute {
      log("created/saved/linked a new collection for families")
    }
  }
