import { writeFileSync } from "fs";
import { ethers } from "hardhat";

const main = async () => {
  const PeaceStorageFactory = await ethers.getContractFactory("PeaceStorage");
  const PeaceStorage = await PeaceStorageFactory.deploy({ value: ethers.parseEther("0.01") });
  console.log("PeaceStorage: ");
  console.log("deployed at: " + await PeaceStorage.getAddress());

  const PeacefulTokenFactory = await ethers.getContractFactory("PeacefulToken");
  const PeacefulToken = await PeacefulTokenFactory.deploy();
  console.log("PeacefulToken: ");
  console.log("deployed at: " + await PeacefulToken.getAddress());

  const PeaceFactory = await ethers.getContractFactory("Peace");
  const Peace = await PeaceFactory.deploy(await PeaceStorage.getAddress(), await PeacefulToken.getAddress(), { value: ethers.parseEther("0.01") });
  console.log("Peace: ");
  console.log("deployed at: " + await Peace.getAddress());

  await PeaceStorage.updateContract(await Peace.getAddress());
  await PeacefulToken.updateContract(await Peace.getAddress());

  writeFileSync("address.txt", `Peace: ${await Peace.getAddress()}\nPeaceStorage: ${await PeaceStorage.getAddress()}\nPeacefulToken: ${await PeacefulToken.getAddress()}`);
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