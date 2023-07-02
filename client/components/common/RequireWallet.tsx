import { Button } from "@nextui-org/react";
import { FC, ReactNode } from "react";

type Props = {
  children: ReactNode;
  currentAccount: string | undefined;
  connectWallet: () => void;
};

const RequireWallet: FC<Props> = ({
  children,
  currentAccount,
  connectWallet,
}) => {
  return (
    <>
      {!currentAccount && (
        <div className="w-full">
          <Button onClick={connectWallet}>Connect Wallet</Button>
        </div>
      )}
      {currentAccount && <div>{children}</div>}
    </>
  );
};

export default RequireWallet;
