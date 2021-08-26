// 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
// ⚠️ THIS FILE IS AUTO-GENERATED WHEN packages/dapplib/interactions CHANGES
// DO **** NOT **** MODIFY CODE HERE AS IT WILL BE OVER-WRITTEN
// 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨

const fcl = require("@onflow/fcl");

module.exports = class DappTransactions {

	static add_template_to_family() {
		return fcl.transaction`
				
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				
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
		`;
	}

	static create_family_collection() {
		return fcl.transaction`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				import RegistryService from 0x01cf0e2f2f715450
				  
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
				
		`;
	}

	static batch_mint_collectible_from_family() {
		return fcl.transaction`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				import FungibleToken from 0xee82856bf20e2aa6
				import FlowToken from 0x0ae53cb6e3f42a79
				
				transaction(familyID: UInt32, templateIDs: [UInt32], amount: UFix64 ) {
				  let receiverReference: &RegistryFamilyContract.Collection{RegistryFamilyContract.Receiver}
				  let sentVault: @FungibleToken.Vault
				
				  prepare(acct: AuthAccount) {
				    self.receiverReference = acct.borrow<&RegistryFamilyContract.Collection>(from: RegistryFamilyContract.CollectionStoragePath)
				        ?? panic("Cannot borrow receiverReference")
				    let vaultRef = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault) ?? panic("Could not borrow Flow vault")
				    self.sentVault <- vaultRef.withdraw(amount: amount) as! @FungibleToken.Vault
				  }
				
				  execute {
				    let collection <- RegistryFamilyContract.batchMintCollectibleFromFamily(familyID: familyID, templateIDs: templateIDs, paymentVault: <-self.sentVault)
				    self.receiverReference.batchDeposit(collection: <-collection)
				  }
				}
				
		`;
	}

	static create_template() {
		return fcl.transaction`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				
				transaction(dna: String, name: String) {
				
				  var adminRef: &RegistryFamilyContract.Admin
				
				  prepare(acct: AuthAccount) {
				    self.adminRef = acct.borrow<&RegistryFamilyContract.Admin>(from: RegistryFamilyContract.AdminStoragePath) ?? panic("Cannot borrow admin ref")
				  }
				
				  execute {
				    self.adminRef.createTemplate(dna: dna, name: name)
				  }
				}
				 
		`;
	}

	static create_family() {
		return fcl.transaction`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				
				transaction(name: String, price: UFix64) {
				
				  var adminRef: &RegistryFamilyContract.Admin
				
				  prepare(acct: AuthAccount) {
				    self.adminRef = acct.borrow<&RegistryFamilyContract.Admin>(from: RegistryFamilyContract.AdminStoragePath) ?? panic("Cannot borrow admin ref")
				  }
				
				  execute {
				    self.adminRef.createFamily(name: name, price: price)
				  }
				}
				 
		`;
	}

	static registry_receive_auth_nft() {
		return fcl.transaction`
				import RegistryService from 0x01cf0e2f2f715450
				
				// Allows a Tenant to register with the RegistryService. It will
				// save an AuthNFT to account storage. Once an account
				// has an AuthNFT, they can then get Tenant Resources from any contract
				// in the Registry.
				//
				// Note that this only ever needs to be called once per Tenant
				
				transaction() {
				
				    prepare(signer: AuthAccount) {
				        // if this account doesn't already have an AuthNFT...
				        if signer.borrow<&RegistryService.AuthNFT>(from: RegistryService.AuthStoragePath) == nil {
				            // save a new AuthNFT to account storage
				            signer.save(<-RegistryService.register(), to: RegistryService.AuthStoragePath)
				
				            // we only expose the IAuthNFT interface so all this does is allow us to read
				            // the authID inside the AuthNFT reference
				            signer.link<&RegistryService.AuthNFT{RegistryService.IAuthNFT}>(RegistryService.AuthPublicPath, target: RegistryService.AuthStoragePath)
				        }
				    }
				
				    execute {
				
				    }
				}
		`;
	}

	static registry_receive_tenant() {
		return fcl.transaction`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				import RegistryService from 0x01cf0e2f2f715450
				
				// This transaction allows any Tenant to receive a Tenant Resource from
				// RegistryFamilyContract. It saves the resource to account storage.
				//
				// Note that this can only be called by someone who has already registered
				// with the RegistryService and received an AuthNFT.
				
				transaction() {
				
				  prepare(signer: AuthAccount) {
				    // save the Tenant resource to the account if it doesn't already exist
				    if signer.borrow<&RegistryFamilyContract.Tenant>(from: RegistryFamilyContract.TenantStoragePath) == nil {
				      // borrow a reference to the AuthNFT in account storage
				      let authNFTRef = signer.borrow<&RegistryService.AuthNFT>(from: RegistryService.AuthStoragePath)
				                        ?? panic("Could not borrow the AuthNFT")
				      
				      // save the new Tenant resource from RegistrySampleContract to account storage
				      signer.save(<-RegistryFamilyContract.instance(authNFT: authNFTRef), to: RegistryFamilyContract.TenantStoragePath)
				
				      // link the Tenant resource to the public
				      //
				      // NOTE: this is commented out for now because it is dangerous to link
				      // our Tenant to the public without any resource interfaces restricting it.
				      // If you add resource interfaces that Tenant must implement, you can
				      // add those here and then uncomment the line below.
				      // 
				      // signer.link<&RegistrySampleContract.Tenant>(RegistrySampleContract.TenantPublicPath, target: RegistrySampleContract.TenantStoragePath)
				    }
				  }
				
				  execute {
				    log("Registered a new Tenant for RegistryFamilyContract.")
				  }
				}
				
		`;
	}

}
