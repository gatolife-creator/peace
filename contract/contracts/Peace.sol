// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Peace {
    using SafeMath for uint256;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Donation {
        address addr;
        uint256 amount;
    }

    struct Project {
        string name;
        string description;
    }

    uint256 supporterId = 0;
    mapping(address => bool) isSupporterRegistered;
    mapping(uint256 => address) supporters;
    mapping(address => uint256) supporterIdFromAddress;
    mapping(uint256 => string) supporterNames;
    mapping(uint256 => uint256) donationAmounts;

    uint256 projectId = 0;
    mapping(address => bool) isProjectRegistered;
    mapping(uint256 => address) projects;
    mapping(address => uint256) projectIdFromAddress;
    mapping(uint256 => Project) projectInfo;
    mapping(uint256 => Donation[]) donations;
    mapping(uint256 => uint256) donationAmountsForProject;

    function registerAsSupporter(string memory name) external {
        require(!isSupporterRegistered[msg.sender]);
        supporters[supporterId] = msg.sender;
        supporterIdFromAddress[msg.sender] = supporterId;
        supporterNames[supporterId] = name;
        isSupporterRegistered[msg.sender] = true;
        supporterId = supporterId.add(1);
    }

    function getSupporterName(uint256 id) public view returns (string memory) {
        require(isSupporterRegistered[supporters[id]]);
        console.log(supporterNames[id]);
        return supporterNames[id];
    }

    function changeSupporterName(string memory name) external {
        require(isSupporterRegistered[msg.sender]);
        supporterNames[supporterIdFromAddress[msg.sender]] = name;
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
        projectInfo[projectIdFromAddress[msg.sender]] = project;
    }

    function changeProjectName(string memory name) external {
        require(isProjectRegistered[msg.sender]);
        projectInfo[projectIdFromAddress[msg.sender]].name = name;
    }

    function changeProjectDescription(string memory description) external {
        require(isProjectRegistered[msg.sender]);
        projectInfo[projectIdFromAddress[msg.sender]].description = description;
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
            addr: msg.sender,
            amount: msg.value
        });
        donations[id].push(donation);
        donationAmountsForProject[id] = donationAmountsForProject[id].add(
            msg.value
        );
    }

    function withdraw() external {
        uint256 amount = donationAmountsForProject[
            projectIdFromAddress[msg.sender]
        ];
        donationAmountsForProject[projectIdFromAddress[msg.sender]] = 0;
        delete donations[projectIdFromAddress[msg.sender]];
        payable(msg.sender).transfer(amount);
    }
}
