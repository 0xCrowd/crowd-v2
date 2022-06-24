<template>
  <b-modal :id="`ext-modal-${extension.id}`" size="md" cancel-disabled :title="`${extension.name}`">
    <div v-for="(proposal, i) in proposals" :key="i">
      <span class="badge alert-info" style="margin-bottom: 10px">{{proposal.proposal_type}}</span>
      <h5>{{proposal.title}}</h5>
      <span style="color: grey; font-weight: lighter">{{proposal.description}}</span>
      <b-form :disabled="proposal.active" style="margin-top: 15px">
        <div v-for="(type, j) in proposal.params_types" :key="j" style="margin-top: 10px">
          {{ proposal.params_names[j] }}
          <b-form-input :name="proposal.params_names[j]" v-if="type === 'address'"></b-form-input>
          <b-form-input :name="proposal.params_names[j]" v-else-if="type === 'uint256'" type="number"></b-form-input>
        </div>
        <b-button style="margin-top: 20px" variant="outline-primary">Create Proposal</b-button>

      </b-form>

      <hr style="color: grey; margin-top: 30px; margin-bottom: 30px;" v-if="i % 2 === 0">
    </div>

    <template #modal-footer="{ ok }">
      <b-button size="md" variant="success" @click="ok()">Done</b-button>
    </template>
  </b-modal>
</template>

<script>
export default {
  name: "ExtensionModal",
  props: ['address', 'web3', 'extensionABI', 'extension'],
  data() {
    return {
      extensionContract: undefined,
      proposals: []
    }
  },

  mounted() {
    console.log(this.extension)
    this.extensionContract = new this.web3.eth.Contract(this.extensionABI, this.extension[2])
    this.getProposals()
  },

  methods: {
    async getProposals() {
      for (let i = 0; i < this.extension[3]; i++) { // iterate over workers (proposals)
        this.proposals.push(await this.extensionContract.methods.getProposalTypes(i).call())
      }
    }
  }
}
</script>

<style scoped>

</style>