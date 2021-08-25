# RegistryFamilyContract

The idea is to implement a module for creating and minting packs of NFTs.
Will be based on logic from CryptoDappies <https://github.com/bebner/crypto-dappy/blob/master/cadence/contracts/DappyContract.cdc>

# TODO

**Roadmap:** Will build the contract and cards without composability. With that working turn into composable contract.

- [x] first draft of dappy contract extracting the packs (family) funcitonality
- [x] action card: create collection for families
- [x] action card: check if we have a collection
- [x] action card: create family
- [x] action card: get family
- [x] action card: create template
- [ ] action card: list collectibles in family
- [ ] action card: list collectible templates
- [ ] action card: mint collectibles from family

# KNOWN ERRORS For Windows Users

A few windows participants have struggled with a `throw Missing contract address for ${contractRef}. Perhaps it wasn't deployed?` error upon running yarn start. Thanks to KR, a participant in the bootcamp, we have discovered the issue is with the /packages/dapplib/src/rythm.js file. If you make the following changes to that file, it should work...

![image](https://user-images.githubusercontent.com/15198786/128912975-cca3498a-054b-4b2b-a39d-018c6da3d5ec.png)

# My Dapp

This project is for the blockchain application My Dapp. It contains code for the Smart Contract, web-based dapp and NodeJS server.

# Pre-requisites

In order to develop and build "My Dapp," the following pre-requisites must be installed:

- [Visual Studio Code](https://code.visualstudio.com/download) (or any IDE for editing Javascript)
- [NodeJS](https://nodejs.org/en/download/)
- [Yarn](https://classic.yarnpkg.com/en/docs/install) (DappStarter uses [Yarn Workspaces](https://classic.yarnpkg.com/en/docs/workspaces))
- [Flow CLI](https://docs.onflow.org/flow-cli/install) (https://docs.onflow.org/flow-cli/install) (after installation run `flow cadence install-vscode-extension` to enable code highlighting for Cadence source files)

### Windows Users

Before you proceed with installation, it's important to note that many blockchain libraries either don't work or generate errors on Windows. If you try installation and can't get the startup scripts to completion, this may be the problem. In that case, it's best to install and run DappStarter using Windows Subsystem for Linux (WSL). Here's a [guide to help you install WSL](https://docs.decentology.com/guides/windows-subsystem-for-linux-wsl).

# Installation

Using a terminal (or command prompt), change to the folder containing the project files and type: `yarn` This will fetch all required dependencies. The process will take 1-3 minutes and while it is in progress you can move on to the next step.

# Yarn Errors

You might see failures related to the `node-gyp` package when Yarn installs dependencies.
These failures occur because the node-gyp package requires certain additional build tools
to be installed on your computer. Follow the [instructions](https://www.npmjs.com/package/node-gyp) for adding build tools and then try running `yarn` again.

# Build, Deploy and Test

Using a terminal (or command prompt), change to the folder containing the project files and type: `yarn start` This will run all the dev scripts in each project package.json.

## File Locations

Here are the locations of some important files:

- Contract Code: [packages/dapplib/contracts](packages/dapplib/contracts)
- Dapp Library: [packages/dapplib/src/dapp-lib.js](packages/dapplib/src/dapp-lib.js)
- Blockchain Interactions: [packages/dapplib/src/blockchain.js](packages/dapplib/src/blockchain.js)
- Unit Tests: [packages/dapplib/tests](packages/dapplib/tests)
- UI Test Harnesses: [packages/client/src/dapp/harness](packages/client/src/dapp/harness)

To view your dapp, open your browser to http://localhost:5000 for the DappStarter Workspace.

We ♥️ developers and want you to have an awesome experience. You should be experiencing Dappiness at this point. If not, let us know and we will help. Join our [Discord](https://discord.gg/XdtJfu8W) or hit us up on Twitter [@Decentology](https://twitter.com/decentology).
