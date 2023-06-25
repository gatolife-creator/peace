// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./BaseNFT.sol";

contract Peace is ERC20 {
    using SafeMath for uint256;
    address public owner;

    constructor() ERC20("PeacefulToken", "PFT") {
        owner = msg.sender;
    }

    event onRegisterAsSupporter(uint256 id, string name, string introduction);
    event onRegisterAsProject(uint256 id, string name, string description);
    event onChangeSupporterInfo(uint256 id, string name, string introduction);
    event onChangeProjectInfo(uint256 id, string name, string description);
    event onDonate(uint256 supporterId, uint256 projectId, uint256 amount);
    event onWithdraw(uint256 amount);

    struct Donation {
        address account;
        uint256 amount;
    }

    struct Supporter {
        string name;
        string introduction;
    }

    struct Project {
        string name;
        string description;
    }

    uint256 supporterId = 0;
    mapping(address => bool) isSupporterRegistered;
    mapping(uint256 => address) supporters;
    mapping(address => uint256) supporterIdFromAddress;
    mapping(uint256 => Supporter) supporterInfo;
    mapping(uint256 => uint256) donationAmounts;

    uint256 projectId = 0;
    mapping(address => bool) isProjectRegistered;
    mapping(uint256 => address) projects;
    mapping(address => uint256) projectIdFromAddress;
    mapping(uint256 => Project) projectInfo;
    mapping(uint256 => Donation[]) donations;
    mapping(uint256 => uint256) donationAmountsForProject;
    mapping(uint256 => BaseNFT) nftContracts;

    function registerAsSupporter(
        string memory name,
        string memory introduction
    ) external {
        require(!isSupporterRegistered[msg.sender]);
        supporters[supporterId] = msg.sender;
        supporterIdFromAddress[msg.sender] = supporterId;
        Supporter memory supporter = Supporter({
            name: name,
            introduction: introduction
        });
        supporterInfo[supporterId] = supporter;
        isSupporterRegistered[msg.sender] = true;
        emit onRegisterAsSupporter(supporterId, name, introduction);
        supporterId = supporterId.add(1);
    }

    function getSupporterName(uint256 id) public view returns (string memory) {
        require(isSupporterRegistered[supporters[id]]);
        return supporterInfo[id].name;
    }

    function getSupporterInfo(
        uint256 id
    ) public view returns (Supporter memory) {
        return supporterInfo[id];
    }

    function changeSupporterName(string memory name) external {
        require(isSupporterRegistered[msg.sender]);
        uint id = supporterIdFromAddress[msg.sender];
        supporterInfo[id].name = name;
        emit onChangeSupporterInfo(id, name, supporterInfo[id].introduction);
    }

    function changeSupporterInfo(
        string memory name,
        string memory introduction
    ) external {
        require(isSupporterRegistered[msg.sender]);
        Supporter memory supporter = Supporter({
            name: name,
            introduction: introduction
        });
        uint256 id = supporterIdFromAddress[msg.sender];
        supporterInfo[id] = supporter;
        emit onChangeSupporterInfo(id, name, introduction);
    }

    function getNumOfSupporters() external view returns (uint256) {
        return supporterId;
    }

    function registerAsProject(
        string memory name,
        string memory description
    ) external {
        require(!isProjectRegistered[msg.sender]);
        projects[projectId] = msg.sender;
        projectIdFromAddress[msg.sender] = projectId;
        Project memory project = Project({
            name: name,
            description: description
        });
        projectInfo[projectId] = project;
        isProjectRegistered[msg.sender] = true;
        emit onRegisterAsProject(projectId, name, description);
        projectId = projectId.add(1);
    }

    function getProjectInfo(uint256 id) public view returns (Project memory) {
        require(isProjectRegistered[projects[id]]);
        return projectInfo[id];
    }

    function changeProjectInfo(
        string memory name,
        string memory description
    ) external {
        require(isProjectRegistered[msg.sender]);
        Project memory project = Project({
            name: name,
            description: description
        });
        uint256 id = projectIdFromAddress[msg.sender];
        projectInfo[id] = project;
        emit onChangeProjectInfo(id, name, description);
    }

    function changeProjectName(string memory name) external {
        require(isProjectRegistered[msg.sender]);
        uint256 id = projectIdFromAddress[msg.sender];
        projectInfo[id].name = name;
        emit onChangeProjectInfo(id, name, projectInfo[id].description);
    }

    function changeProjectDescription(string memory description) external {
        require(isProjectRegistered[msg.sender]);
        uint256 id = projectIdFromAddress[msg.sender];
        projectInfo[id].description = description;
        emit onChangeProjectInfo(id, projectInfo[id].name, description);
    }

    function getNumOfProjects() external view returns (uint256) {
        return projectId;
    }

    function donate(uint256 id) public payable {
        require(
            isSupporterRegistered[msg.sender] &&
                isProjectRegistered[projects[id]]
        );
        Donation memory donation = Donation({
            account: msg.sender,
            amount: msg.value
        });
        donations[id].push(donation);
        donationAmountsForProject[id] = donationAmountsForProject[id].add(
            msg.value
        );

        emit onDonate(supporterIdFromAddress[msg.sender], id, msg.value);
        _mint(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 amount = donationAmountsForProject[
            projectIdFromAddress[msg.sender]
        ];
        donationAmountsForProject[projectIdFromAddress[msg.sender]] = 0;
        delete donations[projectIdFromAddress[msg.sender]];
        payable(msg.sender).transfer(amount);
        emit onWithdraw(amount);
    }

    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account);
    }

    function defineNewNFT(string memory name, string memory symbol) external {
        BaseNFT baseNFT = new BaseNFT(name, symbol);
        nftContracts[projectIdFromAddress[msg.sender]] = baseNFT;
    }

    function mint(uint256 id) external {
        BaseNFT baseNFT = nftContracts[id];
        baseNFT.mint();
    }
}
