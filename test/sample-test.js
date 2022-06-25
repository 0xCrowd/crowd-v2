const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {

  it("Should return the new greeting once it's changed", async function () {
    // const LooksRareExt = await ethers.getContractFactory("LooksRare");
    // const lr = await LooksRareExt.deploy()
    // await lr.deployed()
    // const accounts = await ethers.getSigners();

    const ex = await ethers.getContractAt("IExtension", "0x5979de2AE6d07796248660da814227d97ee9a3E7")

    // let tx = await mn.awardItem(accounts[0].address, ct.address);
    console.log(await ex.name());

  });
});
