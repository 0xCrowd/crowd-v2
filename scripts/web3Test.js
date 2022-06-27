const fs = require('fs');
const {ethers} = require("hardhat");

async function main() {
    const Gifter = await ethers.getContractFactory("NftGifter");
    const g = await Gifter.deploy()
    await g.deployed()

    const data = ethers.utils.defaultAbiCoder.encode(
        ["address", "uint256"],
        ["0x2eB0D5d6b4378E08161EE8d20f5622728fb8c9E7", 12345]
    )
    const tx = await g.execute("0xC91f9203feB50447fDC4A17CCbbC1AACce56Af0d", 1, data);
    await tx.wait();
    console.log(await g.test());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
