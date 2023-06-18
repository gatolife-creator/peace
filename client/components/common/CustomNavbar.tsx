import React, { ReactEventHandler } from "react";
import Link from "next/link";
import { useRouter } from "next/router";
import { Navbar, Button, Text, Dropdown, Avatar } from "@nextui-org/react";
import { AcmeLogo } from "./AcmeLogo";
import { useLocale } from "../../hooks/useLocale";

export const CustomNavbar = () => {
  const { t } = useLocale();
  const router = useRouter();

  const moveTo = (e: TransitionEvent, link: string) => {
    e.preventDefault();
    router.push(link);
  };

  const links = ["/", "/projects", "/ranking", "/support"];
  const texts = [t.HOME_LINK, t.PROJECTS_LINK, t.RANKING_LINK, t.SUPPORT_LINK];

  return (
    <Navbar isBordered variant="floating">
      <Navbar.Brand>
        <AcmeLogo />
        <Text b color="inherit" hideIn="xs">
          <Link href="/">PEACE</Link>
        </Text>
        <small style={{ fontSize: "0.7em" }}>&nbsp;beta</small>
      </Navbar.Brand>
      <Navbar.Content hideIn="xs" activeColor="success" variant="underline-rounded">
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
        <Dropdown placement="bottom-right">
          <Navbar.Item>
            <Dropdown.Trigger>
              <Avatar
                bordered
                as="button"
                color="success"
                size="md"
                src="https://i.pravatar.cc/150?u=a042581f4e29026704d"
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
                zoey@example.com
              </Text>
            </Dropdown.Item>
            <Dropdown.Item key="settings" withDivider>
              My Settings
            </Dropdown.Item>
            <Dropdown.Item key="analytics" withDivider>
              Analytics
            </Dropdown.Item>
            <Dropdown.Item key="system">System</Dropdown.Item>
            <Dropdown.Item key="configurations">Configurations</Dropdown.Item>
            <Dropdown.Item key="help_and_feedback" withDivider>
              Help & Feedback
            </Dropdown.Item>
            <Dropdown.Item key="logout" withDivider color="error">
              Log Out
            </Dropdown.Item>
          </Dropdown.Menu>
        </Dropdown>
      </Navbar.Content>
    </Navbar>
  );
};
