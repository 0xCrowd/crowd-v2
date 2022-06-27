const fs = require('fs');
const {ethers} = require("hardhat");

async function main() {
    // const Vault = await ethers.getContractFactory("CrowdVault");
    const ExtensionManager = await ethers.getContractFactory("ExtensionManager");
    const LooksRare = await ethers.getContractFactory("LooksRare");
    const MockNFT = await ethers.getContractFactory("MockNFT");
    const Crowd = await ethers.getContractFactory("CrowdManager");
    const Gifter = await ethers.getContractFactory("NftGifter");
    const em = await ExtensionManager.deploy();
    const lr = await LooksRare.deploy();
    const nft = await MockNFT.deploy();
    const c = await Crowd.deploy();
    const g = await Gifter.deploy();
    await em.deployed();
    await lr.deployed();
    await nft.deployed();
    await c.deployed();
    await g.deployed();

    const deployer = (await ethers.getSigners())[0];
    console.log(deployer.address)
    let tx = await nft.awardItem(deployer.address);
    await tx.wait();
    tx = await nft.awardItem(deployer.address);
    await tx.wait();
    tx = await nft.awardItem(deployer.address);
    await tx.wait();

    const deploymentData = {
        ExtensionManager: em.address,
        LooksRareExtension: lr.address,
        MockNFT: nft.address,
        Crowd: c.address,
        NftGifter: g.address
    }
    console.log(await nft.ownerOf(1))

    fs.writeFileSync('./addresses.json', JSON.stringify(deploymentData, null, 4));
    console.log(deploymentData)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
