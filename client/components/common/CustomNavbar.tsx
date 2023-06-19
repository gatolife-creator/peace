import React from "react";
import Link from "next/link";
import { useRouter } from "next/router";
import { Navbar, Text, Dropdown, Button, Avatar } from "@nextui-org/react";
import { AcmeLogo } from "./AcmeLogo";
import { useLocale } from "../../hooks/useLocale";
import { useWallet } from "../../hooks/useWallet";

export const CustomNavbar = () => {
  const { t } = useLocale();
  const router = useRouter();

  const moveTo = (e: TransitionEvent, link: string) => {
    e.preventDefault();
    router.push(link);
  };

  const links = ["/", "/projects", "/ranking", "/support"];
  const texts = [t.HOME_LINK, t.PROJECTS_LINK, t.RANKING_LINK, t.SUPPORT_LINK];

  const { currentAccount, connectWallet } = useWallet();

  return (
    <Navbar isBordered variant="floating">
      <Navbar.Brand>
        <AcmeLogo />
        <Text b color="inherit" hideIn="xs">
          <Link href="/">PEACE</Link>
        </Text>
        <small style={{ fontSize: "0.7em" }}>&nbsp;beta</small>
      </Navbar.Brand>
      <Navbar.Content
        hideIn="xs"
        activeColor="success"
        variant="underline-rounded"
      >
        {links.map((link, i) => (
          <Navbar.Link
            key={link}
            href={link}
            onClick={(e: any) => moveTo(e, link)}
            isActive={link === router.asPath ? true : false}
          >
            {texts[i]}
          </Navbar.Link>
        ))}
      </Navbar.Content>
      <Navbar.Content>
        {currentAccount && (
          <>
            <Dropdown placement="bottom-right">
              <Navbar.Item>
                <Dropdown.Trigger>
                  <Avatar
                    bordered
                    as="button"
                    color="success"
                    size="md"
                    src={`https://source.boringavatars.com/marble/120/${currentAccount}?colors=264653,2a9d8f,e9c46a,f4a261,e76f51`}
                  />
                </Dropdown.Trigger>
              </Navbar.Item>
              <Dropdown.Menu
                aria-label="User menu actions"
                color="success"
                onAction={(actionKey) => console.log({ actionKey })}
              >
                <Dropdown.Item key="profile" css={{ height: "$18" }}>
                  <Text b color="inherit" css={{ d: "flex" }}>
                    Signed in as
                  </Text>
                  <Text b color="inherit" css={{ d: "flex" }}>
                    {currentAccount.slice(0, 6) +
                      "......" +
                      currentAccount.slice(
                        currentAccount.length - 7,
                        currentAccount.length - 1
                      )}
                  </Text>
                </Dropdown.Item>
                <Dropdown.Item key="settings" withDivider>
                  <Link href="/setting">My Settings</Link>
                </Dropdown.Item>
                <Dropdown.Item key="analytics" withDivider>
                  Analytics
                </Dropdown.Item>
                <Dropdown.Item key="system">System</Dropdown.Item>
                <Dropdown.Item key="configurations">
                  Configurations
                </Dropdown.Item>
                <Dropdown.Item key="help_and_feedback" withDivider>
                  Help & Feedback
                </Dropdown.Item>
                <Dropdown.Item key="logout" withDivider color="error">
                  Log Out
                </Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
          </>
        )}
        {!currentAccount && (
          <Navbar.Item>
            <Button auto flat onPress={connectWallet}>
              Sign Up
            </Button>
          </Navbar.Item>
        )}
      </Navbar.Content>
    </Navbar>
  );
};
