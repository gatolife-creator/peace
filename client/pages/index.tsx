import React from "react";
import Layout from "../components/common/Layout";
import RequireWallet from "../components/common/RequireWallet";
import { useWallet } from "../hooks/useWallet";
import RequireRegister from "../components/common/RequireRegister";

const App = () => {
  const { currentAccount, connectWallet } = useWallet();
  return (
    <>
      <Layout>
        <RequireRegister
          currentAccount={currentAccount}
          connectWallet={connectWallet}
        >
          test
        </RequireRegister>
      </Layout>
    </>
  );
};

export default App;
