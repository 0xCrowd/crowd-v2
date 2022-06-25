const fs = require('fs');
const {ethers} = require("hardhat");

async function main() {
    // const Vault = await ethers.getContractFactory("CrowdVault");
    const ExtensionManager = await ethers.getContractFactory("ExtensionManager");
    const LooksRare = await ethers.getContractFactory("LooksRare");
    const MockNFT = await ethers.getContractFactory("MockNFT");
    const Crowd = await ethers.getContractFactory("CrowdManager");
    // const v = await Vault.deploy();
    const em = await ExtensionManager.deploy();
    const lr = await LooksRare.deploy();
    const nft = await MockNFT.deploy();
    const c = await Crowd.deploy();
    // await v.deployed();
    await em.deployed();
    await lr.deployed();
    await nft.deployed();
    await c.deployed();

    // const deployer = (await ethers.getSigners())[0];
    // let tx = await nft.awardItem(deployer.address, v.address);
    // await tx.wait();

    const deploymentData = {
        ExtensionManager: em.address,
        LooksRareExtension: lr.address,
        MockNFT: nft.address,
        Crowd: c.address
    }
    console.log(JSON.stringify(deploymentData))
    fs.writeFileSync('./addresses.json', JSON.stringify(deploymentData, null, 4));

    console.log("ExtensionManager:", em.address);
    console.log("LooksRare Extension:", lr.address);
    console.log("Mock NFT:", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
