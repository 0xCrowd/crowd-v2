<template>
  <div>
    <b-row style="text-align: left" class="p-3">
      <div>
        <h3 style="display: inline-block; width: 50%;">
          <span id="popover-switch-crowd" style="cursor: pointer;">
            <span v-if="crowd">Crowd</span>
            <span class="gradient-text" v-if="crowd"> {{ crowd.title }}</span>
            <span class="gradient-text" v-else>Choose Crowd</span>
            <b-icon-arrow-left-right style="margin-left: 10px;"></b-icon-arrow-left-right>
          </span>
        </h3>
        <h5 style="display: inline-block; text-align: right; width: 50%;" v-if="crowd">
          <a href="#">{{ crowd.vault.slice(0, 7) }}...{{ crowd.vault.slice(crowd.vault.length-5) }}</a>
        </h5>
      </div>


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
        <b-row v-for="option in crowds" :key="option.id" class="crowd-option" @click="switchCrowd(option)">
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
const crowdABI = require("../../../artifacts/contracts/CrowdManager.sol/CrowdManager.json");
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
    },

    async switchCrowd(option) {
      this.crowd = option;
      this.$emit("crowd-changed", option)
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
    margin-top: 20px;
    padding-top: 5px;
    padding-bottom: 5px;
    border-radius: 0.5em;
    border: 1px solid transparent;
  }

  .crowd-option:hover {
    color: black;
    border: 1px solid white;
  }

  .crowd-option .crowd-title {
    background: linear-gradient(90deg, #00F0FF, #FF1CF7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
</style>