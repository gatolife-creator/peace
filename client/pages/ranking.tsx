import { NextPage } from "next";
import { Card, Text } from "@nextui-org/react";
import { CustomNavbar } from "../components/common/CustomNavbar";
import { CustomContainer } from "../components/common/CustomContainer";

const ranking: NextPage = () => {
  return (
    <>
      <CustomNavbar />
      <CustomContainer>
        <Card isPressable isHoverable variant="bordered">
          <Card.Body>
            <Text>A pressable card.</Text>
          </Card.Body>
        </Card>
        <Card isPressable isHoverable variant="bordered">
          <Card.Body>
            <Text>A pressable card.</Text>
          </Card.Body>
        </Card>
        <Card isPressable isHoverable variant="bordered">
          <Card.Body>
            <Text>A pressable card.</Text>
          </Card.Body>
        </Card>
      </CustomContainer>
    </>
  );
};

export default ranking;
