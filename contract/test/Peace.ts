import { expect } from 'chai';
import { ethers } from 'hardhat';

describe("Peace", () => {
    it("Register as supporter", async () => {
        const [person] = await ethers.getSigners();
        const Peace = await ethers.getContractFactory("Peace");
        const peace = await Peace.deploy();

        await peace.connect(person).registerAsSupporter("gatolife");

        expect(await peace.getSupporterName(0)).to.equal("gatolife");
    })

    it("Register as project", async () => {
        const [project] = await ethers.getSigners();
        const Peace = await ethers.getContractFactory("Peace");
        const peace = await Peace.deploy();

        await peace.connect(project).registerAsProject("superProject", "This is the best project ever.");
        const { name, description } = await peace.getProjectInfo(0);

        expect(name === "superProject" && description === "This is the best project ever.").to.equal(true);
    })

    it("Number of registered supporters", async () => {
        const [person1, person2, person3, person4] = await ethers.getSigners();
        const Peace = await ethers.getContractFactory("Peace");
        const peace = await Peace.deploy();

        await peace.connect(person1).registerAsSupporter("person1");
        await peace.connect(person2).registerAsSupporter("person2");
        await peace.connect(person3).registerAsSupporter("person3");
        await peace.connect(person4).registerAsSupporter("person4");

        expect(await peace.getNumOfSupporters()).to.equal(4);
    })

    it("Number of registered projects", async () => {
        const [project1, project2, project3, project4] = await ethers.getSigners();
        const Peace = await ethers.getContractFactory("Peace");
        const peace = await Peace.deploy();

        await peace.connect(project1).registerAsProject("project1", "This is the best project ever.");
        await peace.connect(project2).registerAsProject("project2", "This is the best project ever.");
        await peace.connect(project3).registerAsProject("project3", "This is the best project ever.");
        await peace.connect(project4).registerAsProject("project4", "This is the best project ever.");

        expect(await peace.getNumOfProjects()).to.equal(4);
    })
})