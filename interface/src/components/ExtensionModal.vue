<template>
  <b-modal :id="`ext-modal-${extension.id}`" size="md" hide-footer>

    <template #modal-header>
      <h5>{{ extension.name }}</h5><br>
      <a href="#">{{ extension.extension_address.slice(0, 7) }}...{{ extension.extension_address.slice(extension.extension_address.length-5) }}</a>
    </template>

    <div v-for="(proposal, i) in proposals" :key="i">
      <span class="badge alert-info" style="margin-bottom: 10px">{{proposal.proposal_type}}</span>
      <h5>{{proposal.title}}</h5>
      <span style="color: grey; font-weight: lighter">{{proposal.description}}</span>
      <b-form :disabled="proposal.active" style="margin-top: 15px">
        <div v-for="(type, j) in proposal.params_types" :key="j" style="margin-top: 10px">
          {{ proposal.params_names[j] }}
          <b-form-input
              v-model="workers_data[i][j]"
              :name="proposal.params_names[j]"
              v-if="type === 'address'"></b-form-input>
          <b-form-input
              v-model="workers_data[i][j]"
              :name="proposal.params_names[j]"
              v-else-if="type === 'uint256'"
              type="number"></b-form-input>
        </div>
        <div style="text-align: center" class="mt-3">
          <b-button class="outline" @click="approve">Approve</b-button>
          <b-button class="outline" @click="run_extension(i)">Run</b-button>
        </div>

      </b-form>

      <hr style="color: grey; margin-top: 30px; margin-bottom: 30px;" v-if="i % 2 === 0 && i !== proposals.length-1 ">
    </div>

    <template #modal-footer="{ ok }">
      <b-button size="md" variant="success" @click="ok()">Done</b-button>
    </template>
  </b-modal>
</template>

<script>
const extABI = require("../../../artifacts/contracts/Extensions/IExtension.sol/IExtension.json");
const nftABI = require("../../../artifacts/contracts/Extensions/INonFungible.sol/INonFungible.json");
export default {
  name: "ExtensionModal",
  props: ['address', 'web3', 'extension', 'crowd'],
  data() {
    return {
      proposals: [],
      extensionABI: extABI.abi,
      nftABI: nftABI.abi,
      workers_data: []
    }
  },

  mounted() {
    console.log(this.extension)
    this.extensionContract = new this.web3.eth.Contract(this.extensionABI, this.extension[2])
    this.getWorkers()
  },

  methods: {

    async approve() {
      const nft = new this.web3.eth.Contract(this.nftABI, this.workers_data[0][0]);
      await nft.methods.approve(this.extension.extension_address, this.workers_data[0][1]).send( {from: this.address} );
    },

    async run_extension(worker_id) {
      const types = this.proposals[worker_id].params_types
      const parameters = this.workers_data[worker_id]
      const data = this.web3.eth.abi.encodeParameters(types, parameters);
      this.$emit("execute", this.extension.id, worker_id, data)
    },

    async getWorkers() {
      for (let i = 0; i < this.extension[3]; i++) { // iterate over workers (proposals)
        this.proposals.push(await this.extensionContract.methods.getProposalTypes(i).call())
        this.workers_data.push([])
      }

      for (let i = 0; i < this.extension[4]; i++) { // iterate over workers (proposals)
        this.proposals.push(await this.extensionContract.methods.getWorkerTypes(i).call())
        this.workers_data.push([])
      }
    }
  }
}
</script>

<style scoped>

</style>