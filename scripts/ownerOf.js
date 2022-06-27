const fs = require('fs');
const {ethers} = require("hardhat");

async function main() {
    const NFT = await ethers.getContractFactory("MockNFT");
    const nft = await NFT.attach("0xe952708044A1E14A94a51Dbdec34D4a19E0f4d2a")

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
