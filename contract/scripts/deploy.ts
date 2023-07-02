import { ethers } from "hardhat";

const main = async () => {
  const PeaceStorageFactory = await ethers.getContractFactory("PeaceStorage");
  const PeaceStorage = await PeaceStorageFactory.deploy();
  console.log("PeaceStorage: ");
  console.log("deployed at: " + PeaceStorage.getAddress());

  const PeacefulTokenFactory = await ethers.getContractFactory("PeacefulToken");
  const PeacefulToken = await PeacefulTokenFactory.deploy();
  console.log("PeacefulToken: ");
  console.log("deployed at: " + PeacefulToken.getAddress());

  const PeaceFactory = await ethers.getContractFactory("Peace");
  const Peace = await PeaceFactory.deploy(PeaceStorage.getAddress(), PeacefulToken.getAddress());
  console.log("Peace: ");
  console.log("deployed at: " + Peace.getAddress());
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

runMain();