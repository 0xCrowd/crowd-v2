<template>
  <b-container fluid>
    <b-row>
      <b-col>
        <h3>Crowd Vault</h3>
      </b-col>
    </b-row>
    <b-row>
      <b-col>
        <b-input v-model="mockNftAddress" name="Mock NFT address"></b-input>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
const contractsAt = require("../../../addresses.json");
export default {
  name: "Vault",
  props: ['address', 'web3'],
  data() {
    return {
      mockNftAddress: contractsAt.MockNFT
    }
  }
}
</script>

<style scoped>

</style>