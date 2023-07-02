import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { Peace } from "../../contract/typechain-types/contracts/Peace";
import abi from "../utils/Peace.json";
import { getEthereum } from "../utils/ethereum";

const CONTRACT_ADDRESS = "0xDC543B90ABE5Ed935C0c44B88040b13eff290B66";
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
      const tx = await peaceContract.registerAsSupporter(name, intro);
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

  useEffect(() => {
    getPeaceContract();
  }, [currentAccount, ethereum]);

  return {
    processing,
    registerAsSupporter,
    getSupporterInfo,
    registerAsProject,
  };
};
