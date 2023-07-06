import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

if (process.env.PRIVATE_KEY === undefined) {
  console.log('private key is missing');
}

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_API_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
    mumbai: {
      url: process.env.ALCHEMY_API_URL,
      accounts: [process.env.PRIVATE_KEY as string]
    },
  }
};

export default config;
