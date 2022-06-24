<template>
  <b-container fluid>
<!--        <Logo/>-->
    <a href="#" @click="connect">{{ address === undefined ? "Connect" : address }}</a><br><br>
    <!-- Balances are stored and processed in 1/(10^18) of currency since Ethereum doesn't support float numbers -->
    <!-- Here we use web3.utils.fromWei to format Wei balance (1/(10^18) of currency) to pretty numbers  -->
    <div>ETH balance: {{ web3.utils.fromWei(balance) }}</div>


    <h3>Extension Manager</h3><br>
    <input v-model="extensionManagerAddress" style="width: 30vw" placeholder="ExtensionManager address">
    <b-button @click="setExtensionManager" style="margin-left: 10px;">Update</b-button>
    <br><br>

    <input v-model="newExtensionAddress" style="width: 30vw" placeholder="New extension address">
    <b-button @click="registerExtension" style="margin-left: 10px;">Register</b-button>
    <br><br>

    Extensions Total: {{ extensionsTotal }}<br>
    Extensions:<br>
    <b-row>
      <b-col xs="12">
        <div v-for="ext_row in parseInt((extensions.length/5).toFixed())+1" :key="ext_row">
          <b-card-group deck class="d-flex">
            <b-card border-variant="info" style="max-width: 20vw; margin: 5px;" :header="ext.name" align="center" v-for="ext in extensions.slice((ext_row-1)*5, ext_row*5)" :key="ext.id">
              <b-card-text style="text-align: left">
                id: {{ ext.id }}<br/>
                Address: <a href="#">{{ ext.extension_address.slice(0, 7) }}...{{ ext.extension_address.slice(ext.extension_address.length-5) }}</a><br/>
                Proposals: {{ ext.proposals_count }}<br/>
                Workers: {{ ext.workers_count }}<br/>
              </b-card-text>
<!--              <b-button :v-b-modal="`ext-modal-${ext.id}`">Launch</b-button>-->
              <b-button v-b-modal="`ext-modal-${ext.id}`">Launch</b-button>
              <ExtensionModal
                  :address="address"
                  :web3="web3"
                  :extensionABI="extensionABI"
                  :extension="ext"
              />
            </b-card>
          </b-card-group>
        </div>
      </b-col>
    </b-row>


    <!-- Here we'll display all DAI transfer transactions during the session -->
    <!-- With a nice link to block explorer, where we'll be able to discover the receipt -->
    <h3>Transactions:</h3><br>
    <div v-for="tx in sessionTxs" v-bind:key="tx.transactionHash">
      <a :href="`https://rinkeby.etherscan.io/tx/${tx.transactionHash}`"
         target="_blank">
        {{ tx.transactionHash }}
      </a>
    </div>
  </b-container>
</template>

<script>
import Web3 from "web3"
// import Logo from "./Logo";
import ExtensionModal from "./ExtensionModal";
const emABI = require("../../../artifacts/contracts/ExtensionManager.sol/ExtensionManager.json");
const extABI = require("../../../artifacts/contracts/ExtensionInterfaces.sol/IExtension.json");
export default {
  name: 'Demo',
  components: {ExtensionModal},
  props: {
    msg: String
  },

  data() {
    return {
      web3: undefined,

      address: undefined,
      balance: "",

      // Setup
      extensionManagerAddress: "0xD034e186Cce07B9c20595Db343b7618eB938F78E",
      extensionManager: undefined,
      newExtensionAddress: "",
      extensionsTotal: undefined,
      extensions: [],

      sessionTxs: [],

      extensionABI: extABI.abi
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

      await this.getBalanceEth()
    },

    async getBalanceEth() {
      this.balance = await this.web3.eth.getBalance(this.address)
    },

    async setExtensionManager() {
      this.extensionManager = new this.web3.eth.Contract(emABI.abi, this.extensionManagerAddress)
      await this.getExtensionsCount()
      await this.getExtensions()
    },

    async getExtensionsCount() {
      if (this.extensionManager) {
        this.extensionsTotal = await this.extensionManager.methods.extensions_total().call()
      }
    },

    async registerExtension() {
      const tx = await this.extensionManager.methods.registerModule(this.newExtensionAddress).send({
        from: this.address,
        value: "0"
      })
      this.sessionTxs.push(tx)
      await this.getExtensionsCount()
      await this.getExtensions()
    },

    async getExtensions() {
      for (let i = 0; i < this.extensionsTotal; i++) {
        console.log("HERE", i)
        this.extensions.push(await this.extensionManager.methods.getExtension(i).call());
      }
    },

    // async getDaiBalance() {
    //   this.daiBalance = await this.daiContract.methods.balanceOf(this.address).call({ from: this.address })
    // },
    //
    // async transferDai() {
    //   const amount = this.web3.utils.toWei(this.daiAmountToSend, 'ether');
    //   const tx = await this.daiContract.methods.transfer(this.daiRecipient, amount).send({ from: this.address, value: "0" })
    //   this.sessionTxs.push(tx)
    //   console.log(this.sessionTxs)
    // }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
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

a {
  color: #42b983;
}
</style>
