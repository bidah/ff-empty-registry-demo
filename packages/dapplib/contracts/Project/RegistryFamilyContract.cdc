import RegistryInterface from Project.RegistryInterface
import RegistryService from Project.RegistryService

pub contract RegistrySampleContract: RegistryInterface {

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

        init() {
    
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
    // The idea is to implement a packs module based on crypto dappies implementation
    // https://github.com/bebner/crypto-dappy/blob/master/cadence/contracts/DappyContract.cdc

  pub resource Family {
    pub let name: String
    pub let familyID: UInt32
    pub var templates: [UInt32]
    pub var price: UFix64
    
    init(name: String, price: UFix64) {
      pre {
        name.length > 0: "Could not create family: name is required."
        price > 0.00 : "Could not create family: price is required to be higher than 0."
      }
      self.name = name
      self.price = price
      self.familyID = RegistryFamilyContract.nextFamilyID
      self.templates = []
      self.lazy = {}
      RegistryFamilyContract.nextFamilyID = RegistryFamilyContract.nextFamilyID + 1
    }

    pub fun addTemplate(templateID: UInt32) {
      pre {
        RegistryFamilyContract.templates[templateID] != nil : "Could not add dappy to pack: template does not exist."
      }
      self.templates.append(templateID)
    }

    pub fun mintCollectible(templateID: UInt32): @Dappy {
      pre {
        self.templates.contains(templateID): "Could not mint collectible: template does not exist."
      }
      return <- create Collectible(templateID: templateID)
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

    init(templateID: UInt32) {
      pre {
        RegistryFamilyContract.templates[templateID] != nil : "Could not create collectible: template does not exist."
      }
      let colletible = RegistryFamilyContract.templates[templateID]!
      RegistryFamilyContract.totalCollectibles = RegistryFamilyContract.totalCollectibles + 1
      self.id = DappyContract.totalCollectibles
      self.data = Template(templateID: templateID, dna: collectible.dna, name: collectible.name)
    }
  }

  pub fun batchMintCollectibleFromFamily(familyID: UInt32, templateIDs: [UInt32], paymentVault: @FungibleToken.Vault): @Collection {
    pre {
      templateIDs.length > 0 : "Could not batch mint collectible from family: at least one templateID is required."
      templateIDs.length <= 5 : "Could not batch mint collectible from family: batch mint limit of 5 collectible exceeded."
      self.families[familyID] != nil : "Could not batch mint collectible from family: family does not exist."
    }

    let familyRef = &self.families[familyID] as! &Family
    if familyRef.price > paymentVault.balance {
      panic("Could not batch mint dappy from family: payment balance is not sufficient.")
    }
    let collection <- create Collection()

    for ID in templateIDs {
      if !self.familyContainsTemplate(familyID: familyID, templateID: ID) {
        continue
      }
      collection.deposit(token: <- create Dappy(templateID: ID))
    }
    destroy paymentVault
    return <-collection
  }
 
    init() {
        // Initialize clientTenants
        self.clientTenants = {}

        // Set Named paths
        self.TenantStoragePath = /storage/RegistrySampleContractTenant
        self.TenantPublicPath = /public/RegistrySampleContractTenant
    }
}