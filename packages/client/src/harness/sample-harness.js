import "../components/page-panel.js";
import "../components/page-body.js";
import "../components/action-card.js";
import "../components/account-widget.js";
import "../components/text-widget.js";
import "../components/number-widget.js";
import "../components/switch-widget.js";

import DappLib from "@decentology/dappstarter-dapplib";
import { LitElement, html, customElement, property } from "lit-element";

@customElement("sample-harness")
export default class SampleHarness extends LitElement {
  @property()
  title;
  @property()
  category;
  @property()
  description;

  createRenderRoot() {
    return this;
  }

  constructor(args) {
    super(args);
  }

  render() {
    let content = html`
      <page-body
        title="${this.title}"
        category="${this.category}"
        description="${this.description}"
      >
        <!-- Registry -->

        <action-card
          title="Registry - Get Auth NFT"
          description="Register a Tenant with the RegistryService to get an AuthNFT"
          action="receiveAuthNFT"
          method="post"
          fields="signer"
        >
          <account-widget field="signer" label="Account"> </account-widget>
        </action-card>

        <action-card
          title="Registry - Has Auth NFT"
          description="Checks to see if an account has an AuthNFT"
          action="hasAuthNFT"
          method="get"
          fields="tenant"
        >
          <account-widget field="tenant" label="Tenant Account">
          </account-widget>
        </action-card>

        <action-card
          title="RegistrySampleContract - Get Tenant"
          description="Get an instance of a Tenant from RegistrySampleContract to have your own data"
          action="receiveTenant"
          method="post"
          fields="signer"
        >
          <account-widget field="signer" label="Account"> </account-widget>
        </action-card>

        <!-- Flow Token -->
        <action-card
          title="Get Balance"
          description="Get the Flow Token balance of an account"
          action="getBalance"
          method="get"
          fields="account"
        >
          <account-widget field="account" label="Account"> </account-widget>
        </action-card>

        <!-- Flow Token -->
        <action-card
          title="Get Balance"
          description="Get the Flow Token balance of an account"
          action="getBalance"
          method="get"
          fields="account"
        >
          <account-widget field="account" label="Account"> </account-widget>
        </action-card>

        <div
          style="background: papayawhip; border-radius: 5px; padding: 10px; margin-bottom: 10px"
        >
          <h1>
            [WIP]: The idea is to first test the contract pieces and then turn
            into module
          </h1>
        </div>
        <!-- Start Family Contract -->
        <action-card
          title="Create Family Collection"
          description="create a family collection for families (packs)"
          action="createFamilyCollection"
          method="post"
          fields="account"
        >
          <account-widget field="account" label="Account"> </account-widget>
        </action-card>

        <action-card
          title="Check Collection"
          description="check if we have a collection"
          action="checkCollection"
          method="get"
          fields="account"
        >
          <account-widget field="account" label="Account"> </account-widget>
        </action-card>

        <action-card
          title="Get Family"
          description="Gets back the FamilyReport struct"
          action="getFamily"
          method="get"
          fields="familyID"
        >
          <text-widget field="familyID" label="Family ID"></text-widget>
        </action-card>

        <action-card
          title="Create Family"
          description="creates a family resource"
          action="createFamily"
          method="post"
          fields="name price account"
        >
          <account-widget field="account" label="Account"> </account-widget>
          <text-widget field="name" label="Name"></text-widget>
          <text-widget field="price" label="Price"> </text-widget>
        </action-card>

        <action-card
          title="Create Template"
          description="creates template struct and returns collectible ID"
          action="createTemplate"
          method="post"
          fields="name dna account"
        >
          <account-widget field="account" label="Account"> </account-widget>
          <text-widget field="name" label="Name"></text-widget>
          <text-widget field="dna" label="DNA string"></text-widget>
        </action-card>

        <action-card
          title="Add Template To Family"
          description="adds template to family"
          action="addTemplateToFamily"
          method="post"
          fields="familyID templateID account"
        >
          <account-widget field="account" label="Account"> </account-widget>
          <text-widget field="familyID" label="Family ID: "></text-widget>
          <text-widget field="templateID" label="Template ID: "></text-widget>
        </action-card>

        <action-card
          title="List Templates Of Family"
          description="list template IDs of family"
          action="listTemplatesOfFamily"
          method="get"
          fields="familyID account"
        >
          <account-widget field="account" label="Account"> </account-widget>
          <text-widget field="familyID" label="Family ID: "></text-widget>
        </action-card>

        <action-card
          title="Batch Mint Collectible From Family"
          description="mints collectibles from a Family"
          action="batchMintCollectibleFromFamily"
          method="post"
          fields="familyID templateIDs amount account"
        >
          <account-widget field="account" label="Account"> </account-widget>
          <text-widget field="familyID" label="Family ID: "></text-widget>
          <text-widget
            field="templateIDs"
            label="Template ID: "
            placeholder="e.g 1 2 3"
          ></text-widget>
          <text-widget field="amount" label="Amount: "></text-widget>
        </action-card>

        <action-card
          title="List User Collectibles"
          description="list collectibles after pack buy"
          action="listUserCollectibles"
          method="get"
          fields="account"
        >
          <account-widget field="account" label="Account"> </account-widget>
        </action-card>
        <!-- End Family Contract -->
      </page-body>
      <page-panel id="resultPanel"></page-panel>
    `;

    return content;
  }
}
