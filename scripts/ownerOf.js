const fs = require('fs');
const {ethers} = require("hardhat");

async function main() {
    const NFT = await ethers.getContractFactory("MockNFT");
    const nft = await NFT.attach("0xF8226F00cbB68179163C40c81C1F9F150056f710")

    console.log(await nft.ownerOf(1));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
