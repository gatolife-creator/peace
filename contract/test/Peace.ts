import { expect } from 'chai';
import { ethers } from 'hardhat';

describe("Peace", () => {
    const getContracts = async () => {
        const [owner] = await ethers.getSigners();
        const Storage = await ethers.getContractFactory("PeaceStorage");
        const storage = await Storage.connect(owner).deploy();

        const PeacefulToken = await ethers.getContractFactory("PeacefulToken");
        const peacefulToken = await PeacefulToken.deploy();

        const Peace = await ethers.getContractFactory("Peace");
        const peace = await Peace.deploy(storage.getAddress(), peacefulToken.getAddress(), { value: 10000 });

        await storage.connect(owner).updateContract(peace.getAddress());
        await peacefulToken.connect(owner).updateContract(peace.getAddress());

        return { owner, storage, peacefulToken, peace };
    }

    it("Register as supporter", async () => {
        const { peace } = await getContracts();
        const [person] = await ethers.getSigners();

        await peace.connect(person).registerAsSupporter("person", "I'm a good boy.");
        const [name, introduction] = await peace.getSupporterInfo(0);

        expect(name).to.equal("person");
        expect(introduction).to.equal("I'm a good boy.");
    })

    it("Register as project", async () => {
        const { peace } = await getContracts();
        const [project] = await ethers.getSigners();

        await peace.connect(project).registerAsProject("superProject", "This is the best project ever.");
        const [name, description] = await peace.getProjectInfo(0);

        expect(name).to.equal("superProject");
        expect(description).to.equal("This is the best project ever.");
    })

    it("Number of registered supporters", async () => {
        const { peace } = await getContracts();
        const [person1, person2, person3, person4] = await ethers.getSigners();

        await peace.connect(person1).registerAsSupporter("person1", "I'm a good boy.");
        await peace.connect(person2).registerAsSupporter("person2", "I'm a good boy.");
        await peace.connect(person3).registerAsSupporter("person3", "I'm a good boy.");
        await peace.connect(person4).registerAsSupporter("person4", "I'm a good boy.");

        expect(await peace.getNumOfSupporters()).to.equal(4);
    })

    it("Number of registered projects", async () => {
        const { peace } = await getContracts();
        const [project1, project2, project3, project4] = await ethers.getSigners();

        await peace.connect(project1).registerAsProject("project1", "This is the best project ever.");
        await peace.connect(project2).registerAsProject("project2", "This is the best project ever.");
        await peace.connect(project3).registerAsProject("project3", "This is the best project ever.");
        await peace.connect(project4).registerAsProject("project4", "This is the best project ever.");

        expect(await peace.getNumOfProjects()).to.equal(4);
    })

    it("Get balance of peacefulToken", async () => {
        const { peacefulToken, peace } = await getContracts();
        const [person, project] = await ethers.getSigners();

        await peace.connect(project).registerAsProject("project", "This is the best project ever.");
        await peace.connect(person).registerAsSupporter("person", "I'm a good boy.");
        await peace.connect(person).donate(0, { value: 20000 });

        expect(await peacefulToken.balanceOf(person.address)).to.equal(20000);
    })

    it("On donate", async () => {
        const { peace } = await getContracts();
        const [person, project] = await ethers.getSigners();

        await peace.connect(project).registerAsProject("project", "This is the best project ever.");
        await peace.connect(person).registerAsSupporter("person", "I'm a good boy.");

        await expect(peace.connect(person).donate(0, { value: 20000 }))
            .to.emit(peace, "onDonate").withArgs(0, 0, 20000);
    })

    it("On register as supporter", async () => {
        const { peace } = await getContracts();
        const [person] = await ethers.getSigners();

        await expect(peace.connect(person).registerAsSupporter("person", "I'm a good boy."))
            .to.emit(peace, "onRegisterAsSupporter").withArgs(0, "person", "I'm a good boy.");
    })

    it("On change supporter info", async () => {
        const { peace } = await getContracts();
        const [person] = await ethers.getSigners();

        await peace.connect(person).registerAsSupporter("person", "I'm a good boy.");

        await expect(peace.connect(person).fixSupporterInfo("person", "I'm a bad boy."))
            .to.emit(peace, "onFixSupporterInfo").withArgs(0, "person", "I'm a bad boy.");
    })

    // it("Define new NFT", async () => {
    //     const [projects] = await ethers.getSigners();
    //     const Peace = await ethers.getContractFactory("Peace");
    //     const peace = await Peace.deploy();

    //     await peace.connect(projects).registerAsProject("project", "This is the best project ever.");
    //     await peace.connect(projects).defineNewNFT("BestProjectEver", "BPE");

    //     await peace.connect(projects).mint(0);
    // })
})