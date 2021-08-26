import RegistryInterface from Project.RegistryInterface
import RegistryService from Project.RegistryService
import FungibleToken from Flow.FungibleToken

pub contract RegistryFamilyContract: RegistryInterface {

  // Module related logic
  //
  // Maps an address (of the customer/DappContract) to the amount
  // of tenants they have for a specific RegistryContract.
  access(contract) var clientTenants: {Address: UInt64}
  
  // Tenant
  //
  // Requirement that all conforming multitenant smart contracts have
  // to define a resource called Tenant to store all data and things
  // that would normally be saved to account storage in the contract's
  // init() function
  // 
  pub resource Tenant {

    // access(self) var templates: {UInt32: Template}
    // access(self) var families: @{UInt32: Family}
    pub(set) var templates: {UInt32: Template}
    pub(set) var families: @{UInt32: Family}
    pub let admin: @Admin 

    pub(set) var nextTemplateID: UInt32
    pub(set) var nextFamilyID: UInt32
    pub(set) var totalCollectibles: UInt64
    
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let AdminStoragePath: StoragePath

      init() {
        self.templates = {}
        self.totalCollectibles = 0
        self.nextTemplateID = 1
        self.nextFamilyID = 1
        self.CollectionStoragePath = /storage/CollectibleCollection
        self.CollectionPublicPath = /public/CollectibleCollectionPublic
        self.AdminStoragePath = /storage/CollectibleAdmin
        self.admin <- create Admin()
        self.families <- {}
      }
  }

  // instance
  // instance returns an Tenant resource.
  //
  pub fun instance(authNFT: &RegistryService.AuthNFT): @Tenant {
      let clientTenant = authNFT.owner!.address
      if let count = self.clientTenants[clientTenant] {
          self.clientTenants[clientTenant] = self.clientTenants[clientTenant]! + (1 as UInt64)
      } else {
          self.clientTenants[clientTenant] = (1 as UInt64)
      }

      return <-create Tenant()
  }

  // getTenants
  // getTenants returns clientTenants.
  //
  pub fun getTenants(): {Address: UInt64} {
      return self.clientTenants
  }

  // Named Paths
  //
  pub let TenantStoragePath: StoragePath
  pub let TenantPublicPath: PublicPath

  ////////////////////////////////////////////////////////////////////////
  //
  // IDEA
  // To implement a packs module based on crypto dappies implementation
  // https://github.com/bebner/crypto-dappy/blob/master/cadence/contracts/DappyContract.cdc

  pub fun createEmptyCollection(): @Collection {
    return <-create self.Collection()
  }

  pub resource interface CollectionPublic {
    pub fun deposit(token: @Collectible)
    pub fun getIDs(): [UInt64]
    pub fun listCollectibles(): {UInt64: Template}
  }

  pub resource interface Provider {
    pub fun withdraw(withdrawID: UInt64): @Collectible
  }

  pub resource interface Receiver{
    pub fun deposit(token: @Collectible)
    pub fun batchDeposit(collection: @Collection)
  }

  pub resource Collection: CollectionPublic, Provider, Receiver {
    pub var ownedCollectibles: @{UInt64: Collectible}

    pub fun withdraw(withdrawID: UInt64): @Collectible {
      let token <- self.ownedCollectibles.remove(key: withdrawID) 
        ?? panic("Could not withdraw collectible: collectible does not exist in collection")
      return <-token
    }

    pub fun deposit(token: @Collectible) {
      let oldToken <- self.ownedCollectibles[token.id] <- token
      destroy oldToken
    }

    pub fun batchDeposit(collection: @Collection) {
      let keys = collection.getIDs()
      for key in keys {
        self.deposit(token: <-collection.withdraw(withdrawID: key))
      }
      destroy collection
    }

    pub fun getIDs(): [UInt64] {
      return self.ownedCollectibles.keys
    }

    pub fun listCollectibles(): {UInt64: Template} {
      var collectibleTemplates: {UInt64:Template} = {}
      for key in self.ownedCollectibles.keys {
        let el = &self.ownedCollectibles[key] as &Collectible
        collectibleTemplates.insert(key: el.id, el.data)
      }
      return collectibleTemplates
    }

    destroy() {
      destroy self.ownedCollectibles
    }

    init() {
      self.ownedCollectibles<- {}
    }
  }

  pub resource Admin {
    pub fun createTemplate(tenant: &Tenant, dna: String, name: String): UInt32 {
      pre {
        dna.length > 0 : "Could not create template: dna is required."
        name.length > 0 : "Could not create template: name is required."
      }
      let newCollectibleID = tenant.nextTemplateID
      tenant.templates[newCollectibleID] = Template(templateID: newCollectibleID, dna: dna, name: name)
      tenant.nextTemplateID = tenant.nextTemplateID + 1
      return newCollectibleID
    }

    pub fun destroyTemplate(tenant: &Tenant, collectibleID: UInt32) {
      pre {
        tenant.templates[collectibleID] != nil : "Could not delete template: template does not exist."
      }
      tenant.templates.remove(key: collectibleID)
    }

    pub fun createFamily(tenant: &Tenant, name: String, price: UFix64) {
      let newFamily <- create Family(tenant: tenant, name: name, price: price)
      tenant.families[newFamily.familyID] <-! newFamily
    }

    pub fun borrowFamily(tenant: &Tenant, familyID: UInt32): &Family {
      pre {
        tenant.families[familyID] != nil : "Could not borrow family: family does not exist."
      }
      return &tenant.families[familyID] as &Family
    }

    pub fun destroyFamily(tenant: &Tenant, familyID: UInt32) {
      pre {
        tenant.families[familyID] != nil : "Could not borrow family: family does not exist."
      }
      let familyToDelete <- tenant.families.remove(key: familyID)!
      destroy familyToDelete
    }

  }

  pub struct Template {
    pub let templateID: UInt32
    pub let dna: String
    pub let name: String
    pub let price: UFix64

    init(templateID: UInt32, dna: String, name: String) {
      self.templateID = templateID
      self.dna = dna
      self.name = name
      self.price = self._calculatePrice(dna: dna.length)
    }

    access(self) fun _calculatePrice(dna: Int): UFix64 {
      if dna >= 31 {
        return 21.0
      } else if dna >= 25 {
        return 14.0
      } else {
        return 7.0
      }
    }
  }

  pub resource Family {
    pub let tenant: &Tenant
    pub let name: String
    pub let familyID: UInt32
    pub var templates: [UInt32]
    pub var price: UFix64
    
    init(tenant: &Tenant, name: String, price: UFix64) {
      pre {
        name.length > 0: "Could not create family: name is required."
        price > 0.00 : "Could not create family: price is required to be higher than 0."
      }
      self.tenant = tenant
      self.name = name
      self.price = price
      self.familyID = tenant.nextFamilyID
      self.templates = []
      self.tenant.nextFamilyID = tenant.nextFamilyID + 1
    }

    pub fun addTemplate(templateID: UInt32) {
      pre {
        self.tenant.templates[templateID] != nil : "Could not add collectible to pack: template does not exist."
      }
      self.templates.append(templateID)
    }

    pub fun mintCollectible(templateID: UInt32): @Collectible {
      pre {
        self.templates.contains(templateID): "Could not mint collectible: template does not exist."
      }
      return <- create Collectible(tenant: tenant, templateID: templateID)
    }
  }

  pub struct FamilyReport {
    pub let name: String
    pub let familyID: UInt32
    pub var templates: [UInt32]
    pub var price: UFix64
    
    init(name: String, familyID: UInt32, templates: [UInt32], price: UFix64) {
      self.name = name
      self.familyID = familyID
      self.templates = []
      self.price = price
    }
  }

  pub resource Collectible {
    pub let id: UInt64
    pub let data: Template

    init(tenant: &Tenant, templateID: UInt32) {
      pre {
        tenant.templates[templateID] != nil : "Could not create collectible: template does not exist."
      }
      let collectible = tenant.templates[templateID]!
      tenant.totalCollectibles = tenant.totalCollectibles + 1
      self.id = tenant.totalCollectibles
      self.data = Template(templateID: templateID, dna: collectible.dna, name: collectible.name)
    }
  }

  // pub fun batchMintCollectibleFromFamily(familyID: UInt32, templateIDs: [UInt32], paymentVault: @FungibleToken.Vault): @Collection {
  pub fun batchMintCollectibleFromFamily(tenant: &Tenant, familyID: UInt32, templateIDs: [UInt32]): @Collection {
    pre {
      templateIDs.length > 0 : "Could not batch mint collectible from family: at least one templateID is required."
      templateIDs.length <= 5 : "Could not batch mint collectible from family: batch mint limit of 5 collectible exceeded."
      tenant.families[familyID] != nil : "Could not batch mint collectible from family: family does not exist."
    }

    let familyRef = &tenant.families[familyID] as! &Family
    // if familyRef.price > paymentVault.balance {
    //   panic("Could not batch mint collectible from family: payment balance is not sufficient.")
    // }
    let collection <- create Collection()

    for ID in templateIDs {
      if !RegistryFamilyContract.familyContainsTemplate(tenant: tenant, familyID: familyID, templateID: ID) {
        continue
      }
      log("depositing collectible to collection")
      collection.deposit(token: <- create Collectible(tenant: tenant, templateID: ID))
    }
      log("done depositing")
    // destroy paymentVault
    return <-collection
  }

  pub fun listFamilies(tenant: &Tenant): [FamilyReport] {
    var families: [FamilyReport] = []
    for key in tenant.families.keys {
      let el = &tenant.families[key] as &Family
      families.append(FamilyReport(
        name: el.name, 
        familyID: el.familyID, 
        templates: el.templates, 
        price: el.price
      ))
    }
    return families
  }

  pub fun listFamilyTemplates(tenant: &Tenant, familyID: UInt32): [UInt32] {
    pre {
      tenant.families[familyID] != nil : "Could not list family templates: family does not exist."
    }
    var report: [UInt32] = []
    let el = &tenant.families[familyID] as! &Family
    for temp in el.templates {
      report.append(temp)
    }
    return report
  }

  pub fun getFamily(tenant: &Tenant, familyID: UInt32): FamilyReport {
    pre {
      tenant.families[familyID] != nil : "Could not get family: family does not exist."
    }
    let el = &tenant.families[familyID] as! &Family
    let report = FamilyReport(
      name: el.name, 
      familyID: el.familyID, 
      templates: el.templates, 
      price: el.price
    )
    return report
  }

  pub fun familyContainsTemplate(tenant: &Tenant, familyID: UInt32, templateID: UInt32): Bool {
    pre {
      tenant.families[familyID] != nil : "Family does not exist"
    }
    let el = &tenant.families[familyID] as! &Family
    return el.templates.contains(templateID)
  }
 
  init() {
    // Initialize clientTenants
    self.clientTenants = {}

    // Set Named paths
    self.TenantStoragePath = /storage/RegistrySampleContractTenant
    self.TenantPublicPath = /public/RegistrySampleContractTenant

    /////////////////////////
  }
}