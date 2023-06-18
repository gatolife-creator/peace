import React from "react";
import Link from "next/link";
import { Navbar, Button, Text, Card, Radio } from "@nextui-org/react";
import { AcmeLogo } from "./AcmeLogo";
import { useLocale } from "../../hooks/useLocale";

export const CustomNavbar = () => {
  const { t } = useLocale();

  return (
    <Navbar isBordered variant="floating">
      <Navbar.Brand>
        <AcmeLogo />
        <Text b color="inherit" hideIn="xs">
          <Link href="/">PEACE</Link>
        </Text>
      </Navbar.Brand>
      <Navbar.Content hideIn="xs">
        <Link href="/">{t.HOME_LINK}</Link>
        <Link href="/ranking">{t.RANKING_LINK}</Link>
        <Link href="/support">{t.SUPPORT_LINK}</Link>
      </Navbar.Content>
      <Navbar.Content>
        <Navbar.Link color="inherit" href="#">
          Login
        </Navbar.Link>
        <Navbar.Item>
          <Button auto flat as={Link} href="#">
            Sign Up
          </Button>
        </Navbar.Item>
      </Navbar.Content>
    </Navbar>
  );
};
