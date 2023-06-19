import { NextPage } from "next";
import { Container, Grid } from "@nextui-org/react";
import { CustomNavbar } from "../components/common/CustomNavbar";
import { CustomCard } from "../components/projects/CustomCard";

const projects: NextPage = () => {
  return (
    <>
      <CustomNavbar />
      <Container>
        <Grid.Container gap={2} justify="center">
          <Grid xs={4}>
            <CustomCard />
          </Grid>
          <Grid xs={4}>
            <CustomCard />
          </Grid>
          <Grid xs={4}>
            <CustomCard />
          </Grid>
        </Grid.Container>
      </Container>
    </>
  );
};

export default projects;
