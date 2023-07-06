import { Button } from "@nextui-org/react";
import { FC, ReactNode, useState } from "react";
import { usePeaceContract } from "../../hooks/usePeaceContract";

type Props = {
  children: ReactNode;
  currentAccount: string | undefined;
  connectWallet: () => void;
};

const RequireRegister: FC<Props> = ({
  children,
  currentAccount,
  connectWallet,
}) => {
  const {
    registerAsSupporter,
    registerAsProject,
    getSupporterInfo,
    changeOwner,
  } = usePeaceContract({
    currentAccount,
  });
  const [isRegistered, setIsRegistered] = useState(false);

  return (
    <>
      {currentAccount && (
        <div className="w-full">
          <Button
            onPress={async () => {
              await registerAsSupporter("gatolife", "I'm a good boy.");
            }}
          >
            register as supporter
          </Button>
          <Button
            onPress={async () => {
              console.log("test:", await getSupporterInfo(0));
            }}
          >
            get supporter info
          </Button>
          <Button
            onPress={async () => {
              await changeOwner("0x45CC7136713A0783D7fd8e3b8C514C00557e5bBE");
            }}
          >
            change owner
          </Button>
        </div>
      )}
    </>
  );
};

export default RequireRegister;
