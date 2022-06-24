<template>
  <div>
    <b-row style="text-align: left" class="p-3">
      <h3>
        <span v-if="crowd">Crowd</span>
        <span id="popover-switch-crowd" style="cursor: pointer;">
          <span class="gradient-text" v-if="crowd">{{ crowd.title }}</span>
          <span class="gradient-text" v-else>Choose Crowd</span>
          <b-icon-arrow-left-right style="margin-left: 10px;"></b-icon-arrow-left-right>
        </span>
      </h3>

      <b-popover target="popover-switch-crowd"
                 triggers="hover"
                 placement="bottom">
        <template #title>Switch Crowd</template>

        <b-row>
          <b-col style="text-align: center">
            <b-form-input
                v-model="newCrowdTitle"
                placeholder="New Crowd title"
                :class="newCrowdTitleWrongInput ? 'wrong-input' : ''"
                @focusin="newCrowdTitleWrongInput = false"
            />
            <b-button class="mt-2 outline" @click="createCrowd">Create</b-button>
          </b-col>
        </b-row>
        <b-row v-for="option in crowds" :key="option.id" class="crowd-option">
          <b-col>
              {{ option.id}}.
              <h5 class="crowd-title"
                  style="display: inline; margin-left: 10px;">
                {{ option.title }}
              </h5>
          </b-col>
        </b-row>


      </b-popover>

    </b-row>
  </div>
</template>

<script>
const contractsAt = require("../../../addresses.json");
const crowdABI = require("../../../artifacts/contracts/Crowd.sol/Crowd.json");
export default {
  name: "Crowd",
  props: ['address', 'web3'],
  data() {
    return {
      crowdAddress: contractsAt.Crowd,
      crowdContract: undefined,
      mockNftAddress: contractsAt.MockNFT,
      crowd: undefined,
      crowdsAmount: 0,
      newCrowdTitle: "",
      newCrowdTitleWrongInput: false,
      crowds: []
    }
  },

  mounted() {
    this.crowdContract = new this.web3.eth.Contract(crowdABI.abi, this.crowdAddress);
    this.getCrowdsAmount();
  },

  methods: {
    async getCrowdsAmount() {
      this.crowdsAmount = parseInt(await this.crowdContract.methods.totalCrowds().call());
      await this.getCrowdsBunch();
    },

    async getCrowdsBunch() {
      for (let i = this.crowdsAmount; i > 0 && i > this.crowdsAmount - 10; i--) {
        this.crowds.push(await this.crowdContract.methods.getCrowd(i).call());
      }
    },

    async createCrowd() {
      if (this.newCrowdTitle.length < 3) {
        this.newCrowdTitleWrongInput = true
        return
      }
      await this.crowdContract.methods.newCrowd(this.newCrowdTitle, contractsAt.ExtensionManager).send({
        from: this.address,
        value: "0"
      })
      await this.getCrowdsBunch()
    }

  }

}
</script>

<style scoped>
  .wrong-input {
    border-color: red !important;
  }

  .crowd-option {
    cursor: pointer;
    text-align: left;
    margin-top: 10px;
    padding-top: 5px;
    padding-bottom: 5px;
    border-radius: 0.5em;
    background: transparent;
  }

  .crowd-option:hover {
    color: black;
    background: linear-gradient(90deg, #00F0FF, #FF1CF7);
  }

  .crowd-option .crowd-title {
    background: linear-gradient(90deg, #00F0FF, #FF1CF7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .crowd-option:hover .crowd-title {
    background: #263238;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
</style>