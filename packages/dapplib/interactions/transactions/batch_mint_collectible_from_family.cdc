import RegistryFamilyContract from Project.RegistryFamilyContract
import FungibleToken from Flow.FungibleToken
import FlowToken from Flow.FlowToken

transaction(familyID: UInt32, templateIDs: [UInt32], amount: UFix64 ) {
  let receiverReference: &RegistryFamilyContract.Collection{RegistryFamilyContract.Receiver}
  let sentVault: @FungibleToken.Vault

  prepare(acct: AuthAccount) {
    self.receiverReference = acct.borrow<&RegistryFamilyContract.Collection>(from: RegistryFamilyContract.CollectionStoragePath) 
        ?? panic("Cannot borrow receiverReference")
    // let vaultRef = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault) ?? panic("Could not borrow Flow vault")
    // self.sentVault <- vaultRef.withdraw(amount: amount) as! @FungibleToken.Vault
  }

  execute {
    // let collection <- RegistryFamilyContract.batchMintCollectibleFromFamily(familyID: familyID, templateIDs: templateIDs, paymentVault: <-self.sentVault)
    let collection <- RegistryFamilyContract.batchMintCollectibleFromFamily(familyID: familyID, templateIDs: templateIDs)
    self.receiverReference.batchDeposit(collection: <-collection)
  }
}