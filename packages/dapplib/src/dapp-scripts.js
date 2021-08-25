// 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
// ⚠️ THIS FILE IS AUTO-GENERATED WHEN packages/dapplib/interactions CHANGES
// DO **** NOT **** MODIFY CODE HERE AS IT WILL BE OVER-WRITTEN
// 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨

const fcl = require("@onflow/fcl");

module.exports = class DappScripts {

	static check_collection() {
		return fcl.script`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				  
				pub fun main(addr: Address): Bool {
				  let ref = getAccount(addr).getCapability<&{RegistryFamilyContract.CollectionPublic}>(RegistryFamilyContract.CollectionPublicPath).check()
				  return ref
				}
		`;
	}

	static list_templates_of_family() {
		return fcl.script`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				
				pub fun main(familyID: UInt32): [UInt32] {
				  let templates = RegistryFamilyContract.listFamilyTemplates(familyID: familyID)
				  return templates
				}
		`;
	}

	static get_family() {
		return fcl.script`
				import RegistryFamilyContract from 0x01cf0e2f2f715450
				
				pub fun main(familyID: UInt32): RegistryFamilyContract.FamilyReport {
				  let family = RegistryFamilyContract.getFamily(familyID: familyID)
				  return family
				}
				
		`;
	}

	static registry_has_auth_nft() {
		return fcl.script`
				import RegistryService from 0x01cf0e2f2f715450
				
				// Checks to see if an account has an AuthNFT
				
				pub fun main(tenant: Address): Bool {
				    let hasAuthNFT = getAccount(tenant).getCapability(RegistryService.AuthPublicPath)
				                        .borrow<&RegistryService.AuthNFT{RegistryService.IAuthNFT}>()
				
				    if hasAuthNFT == nil {
				        return false
				    } else {
				        return true
				    }
				}
		`;
	}

	static flowtoken_get_balance() {
		return fcl.script`
				import FungibleToken from 0x01cf0e2f2f715450
				import FlowToken from 0x0ae53cb6e3f42a79
				
				pub fun main(account: Address): UFix64 {
				
				    let vaultRef = getAccount(account)
				        .getCapability(/public/flowTokenBalance)
				        .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
				        ?? panic("Could not borrow Balance reference to the Vault")
				
				    return vaultRef.balance
				}  
		`;
	}

}
