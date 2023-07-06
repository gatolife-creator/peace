import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { Peace } from "../../contract/typechain-types/contracts/Peace";
import abi from "../utils/Peace.json";
import { getEthereum } from "../utils/ethereum";

const CONTRACT_ADDRESS = "0x287be1834aB1D4E8020b8BeAc421279e4E440c71";
const CONTRACT_ABI = abi.abi;

type Props = {
  currentAccount: string | undefined;
};

export const usePeaceContract = ({ currentAccount }: Props) => {
  const [processing, setProcessing] = useState(false);
  const [peaceContract, setPeaceContract] = useState<Peace>();

  const ethereum = getEthereum();

  async function getPeaceContract() {
    try {
      if (ethereum) {
        // @ts-ignore: ethereum as ethers.providers.ExternalProvider
        const provider = new ethers.providers.Web3Provider(ethereum, "any");
        const signer = provider.getSigner();
        const PeaceContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          CONTRACT_ABI,
          signer
        ) as unknown;
        setPeaceContract(PeaceContract as Peace);
      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (err) {
      console.log(err);
    }
  }

  async function registerAsSupporter(name: string, intro: string) {
    if (!peaceContract) {
      return;
    }

    try {
      const tx = await peaceContract.registerAsSupporter(name, intro, {
        gasLimit: 100000,
      });
      setProcessing(true);
      await tx.wait();
      setProcessing(false);
    } catch (err) {
      console.log(err);
      alert("Failed to register");
    }
  }

  async function getSupporterInfo(id: number) {
    if (!peaceContract) {
      return;
    }
    try {
      setProcessing(true);
      const [name, intro] = await peaceContract.getSupporterInfo(id);
      setProcessing(false);
      return { name, intro };
    } catch (err) {
      console.log(err);
      alert("Failed to get info");
    }
  }

  async function registerAsProject(name: string, desc: string) {
    if (!peaceContract) {
      return;
    }

    try {
      const tx = await peaceContract.registerAsProject(name, desc);
      setProcessing(true);
      await tx.wait();
      setProcessing(false);
    } catch (err) {
      console.log(err);
      alert("Failed to register");
    }
  }

  async function changeOwner(address: string) {
    if (!peaceContract) {
      return;
    }

    try {
      const tx = await peaceContract.changeOwner(address);
      setProcessing(true);
      await tx.wait();
      setProcessing(false);
    } catch (err) {
      console.log(err);
      alert("Failed to change owner");
    }
  }

  useEffect(() => {
    getPeaceContract();
  }, [currentAccount, ethereum]);

  return {
    processing,
    registerAsSupporter,
    getSupporterInfo,
    registerAsProject,
    changeOwner,
  };
};
