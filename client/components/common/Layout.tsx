import { ReactNode } from "react";
import Head from "next/head";
import { CustomNavbar } from "./CustomNavbar";

type Props = {
  children: ReactNode;
};

export default function Layout({ children }: Props) {
  return (
    <>
      <Head>
        <title>ChatApp</title>
        <meta name="description" content="ChatApp" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <CustomNavbar />
      <main>{children}</main>
    </>
  );
}
