<template>
  <b-container fluid>
    <b-row>
      <b-col>
        <a href="#" v-b-toggle.register-collapse variant="primary">Add asset</a>
        <b-collapse id="register-collapse" class="mt-2">
          <b-input v-model="newAssetAddress" name="NFT address" placeholder="NFT address"
                   style="width: 30%; display: inline-block; margin-right: 10px;"></b-input>
          <b-button class="outline" @click="register_asset">Add asset</b-button>
        </b-collapse>
      </b-col>
    </b-row>

    <b-row>
      <b-col>

        <b-card-group deck class="d-flex">
          <b-card border-variant="info"
                  bg-variant="dark"
                  style="max-width: 17vw; margin: 5px;"
                  align="center"
                  v-for="(data, key) in assets"
                  :key="key">
            <img :src="data.uri" style="width: 100%">
            <h5 style="margin-top: 25px">{{data.name}}</h5>
          </b-card>
        </b-card-group>

      </b-col>
    </b-row>

  </b-container>
</template>

<script>
const nftABI = require("../../../artifacts/contracts/Extensions/INonFungible.sol/INonFungible.json");
export default {
  name: "Vault",
  props: ['address', 'web3', 'crowd'],
  data() {
    return {
      newAssetAddress: undefined,
      assets: {},
      qwe: [1,2,3,4],
      nftABI: nftABI.abi
    }
  },

  watch: {
    crowd(o, n) {
      console.log(o, n);
      this.assets = {};
    }
  },

  methods: {
    async register_asset(){
      const nft = new this.web3.eth.Contract(this.nftABI, this.newAssetAddress);
      const balance = await nft.methods.balanceOf(this.crowd.vault).call();
      let found = 0;
      let item = 0;
      while (found < balance && item < 5) {
        try {
          const owner = await nft.methods.ownerOf(item).call();
          if (owner === this.crowd.vault) {
            console.log("FOUND", item)
            this.assets[this.newAssetAddress+":"+item] = {
              name: (await nft.methods.name().call()) + ` #${item}`,
              uri: await nft.methods.tokenURI(item).call()
            }
            found++;
          }
        } catch {
          item++;
          continue;
        }
        item++;
      }
      this.$forceUpdate();
      console.log(this.assets);
    }
  }
}
</script>

<style scoped>

</style>