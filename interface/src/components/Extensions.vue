<template>
  <b-container>
    <a href="#" v-b-toggle.ne-collapse variant="primary">New Extension (Only Owner)</a>
    <b-collapse id="ne-collapse" class="mt-2">
      <b-input v-model="newExtensionAddress" style="width: 30vw; display: inline;" placeholder="New extension address"></b-input>
      <b-button @click="registerExtension" style="margin-left: 10px;">Register</b-button>
    </b-collapse>
    <b-row class="mt-4">
      <b-col xs="12">
        <div v-for="ext_row in parseInt((extensions.length/5).toFixed())+1" :key="ext_row">
          <b-card-group deck class="d-flex">
            <b-card border-variant="info" bg-variant="dark" style="max-width: 17vw; margin: 5px;" :header="ext.name" align="center" v-for="ext in extensions.slice((ext_row-1)*5, ext_row*5)" :key="ext.id">
              <b-card-text style="text-align: left">
                id: {{ ext.id }}<br/>
                Address: <a href="#">{{ ext.extension_address.slice(0, 7) }}...{{ ext.extension_address.slice(ext.extension_address.length-5) }}</a><br/>
                Proposals: {{ ext.proposals_count }}<br/>
                Workers: {{ ext.workers_count }}<br/>
              </b-card-text>
              <!--              <b-button :v-b-modal="`ext-modal-${ext.id}`">Launch</b-button>-->
              <button class="outline" v-b-modal="`ext-modal-${ext.id}`">Launch</button>
              <ExtensionModal
                  :address="address"
                  :web3="web3"
                  :extension="ext"
              />
            </b-card>
          </b-card-group>
        </div>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import ExtensionModal from "./ExtensionModal";
const emABI = require("../../../artifacts/contracts/Extensions/ExtensionManager.sol/ExtensionManager.json");
const contractsAt = require("../../../addresses.json");
export default {
  name: "Extensions",
  props: ['address', 'web3'],
  components: { ExtensionModal },
  data() {
    return {
      // Setup
      extensionManagerAddress: contractsAt.ExtensionManager,
      extensionManager: undefined,
      newExtensionAddress: contractsAt.LooksRareExtension,
      extensionsTotal: undefined,
      extensions: [],
    }
  },

  mounted() {
    this.setExtensionManager();
  },

  methods: {
    async setExtensionManager() {
      this.extensionManager = new this.web3.eth.Contract(emABI.abi, this.extensionManagerAddress)
      await this.getExtensionsCount()
      if (this.extensionsTotal === "0") {
        await this.registerExtension()
      }
      await this.getExtensions()
    },

    async getExtensionsCount() {
      if (this.extensionManager) {
        this.extensionsTotal = await this.extensionManager.methods.extensions_total().call()
      }
    },

    async registerExtension() {
      await this.extensionManager.methods.registerModule(this.newExtensionAddress).send({
        from: this.address,
        value: "0"
      })
      await this.getExtensionsCount()
      await this.getExtensions()
    },

    async getExtensions() {
      this.extensions = []
      for (let i = 0; i < this.extensionsTotal; i++) {
        console.log("HERE", i)
        this.extensions.push(await this.extensionManager.methods.getExtension(i).call());
      }
    },

  }
}
</script>

<style scoped>

</style>