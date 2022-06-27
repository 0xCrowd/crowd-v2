<template>
  <b-container fluid>
    <a href="#" v-if="!address" @click="connect">Connect Metamask</a>
    <div v-else>
      <b-row class="pt-4 pb-4" style="background-color: #263238; color: white;">
        <b-col style="text-align: left; padding-left: 20px">
          <img src="../assets/logo.svg" style="height: 3em"/>
        </b-col>
        <b-col style="text-align: right; padding-right: 20px; padding-top: 0.8em">
          <div>
            <a href="#" @click="connect" style="color: white; font-weight: bold; text-decoration: none;">{{ address.slice(0, 7) }}...{{ address.slice(address.length-5) }}</a>
<!--            <img src="https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/svg/icon/eth.svg"/>-->
<!--            {{ web3.utils.fromWei(balance).split(".")[0] }}.{{ web3.utils.fromWei(balance).split(".")[1].slice(0, 2) }}-->
          </div>
        </b-col>
      </b-row>

      <!--        <Logo/>-->

      <Crowd :address="address" :web3="web3" @crowd-changed="function(option) {crowd = option}" />

      <b-row v-if="crowd">
        <b-col>
          <button href="#" v-b-toggle.vault-collapse class="outline mt-5 mb-3">Vault</button>
          <b-collapse id="vault-collapse" class="mt-2">
            <Vault :address="address" :web3="web3" :crowd="crowd"/>
          </b-collapse>
        </b-col>
      </b-row>

      <b-row v-if="crowd">
        <b-col>
          <button href="#" v-b-toggle.extensions-collapse class="outline mt-5 mb-3">Extensions</button>
          <b-collapse id="extensions-collapse" class="mt-2">
            <Extensions :address="address" :web3="web3" :crowd="crowd" />
          </b-collapse>
        </b-col>
      </b-row>

    </div>
  </b-container>
</template>

<script>
import Web3 from "web3"
// import Logo from "./Logo";
import Vault from "./Vault";
import Extensions from "./Extensions";
import Crowd from "./Crowd";
export default {
  name: 'Demo',
  components: {Crowd, Extensions, Vault},
  props: {
    msg: String
  },

  data() {
    return {
      web3: undefined,
      address: undefined,
      balance: "",

      crowd: undefined,

      sessionTxs: [],
    }
  },

  beforeMount() {
    if (typeof window.ethereum !== 'undefined') {
      this.web3 = new Web3(window.ethereum);
    }
  },

  mounted() {
    this.connect();
  },

  methods: {
    // Setup
    async connect() {
      const accounts = await window.ethereum.request({method: 'eth_requestAccounts'});
      this.address = accounts[0];
      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{chainId: '0x539'}], // Ganache network
      });

      await this.getBalanceEth();
    },

    async getBalanceEth() {
      this.balance = await this.web3.eth.getBalance(this.address)
    },
  }
}
</script>

<style scoped>
h3 {
  margin: 40px 0 0;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}
</style>
