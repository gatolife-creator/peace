import { Button } from "@nextui-org/react";
import { FC, ReactNode, useState } from "react";
import { usePeaceContract } from "../../hooks/usePeaceContract";
import { useWallet } from "../../hooks/useWallet";

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
  const { registerAsSupporter, registerAsProject } = usePeaceContract({
    currentAccount,
  });
  const [isRegistered, setIsRegistered] = useState(false);

  return (
    <>
      {currentAccount && (
        <div className="w-full">
          <Button
            onClick={async () => {
              await registerAsSupporter("gatolife", "I'm a good boy.");
            }}
          >
            register as supporter
          </Button>
        </div>
      )}
    </>
  );
};

export default RequireRegister;
