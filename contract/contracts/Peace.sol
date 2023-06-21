// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "hardhat/console.sol";

contract Peace {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Donation {
        address addr;
        uint256 amount;
    }

    uint256 supporterId = 0;
    mapping(address => bool) isSupporterRegistered;
    mapping(uint256 => address) supporters;
    mapping(address => string) supporterNames;
    mapping(uint256 => uint256) donationAmounts;

    uint256 projectId = 0;
    mapping(address => bool) isProjectRegistered;
    mapping(uint256 => address) projects;
    mapping(address => uint256) projectIdFromAddress;
    mapping(address => string) projectNames;
    mapping(uint256 => Donation[]) donations;

    function registerAsSupporter(string memory name) external {
        require(!isSupporterRegistered[msg.sender]);
        supporters[supporterId] = msg.sender;
        supporterNames[msg.sender] = name;
        isSupporterRegistered[msg.sender] = true;
        supporterId += 1;
    }

    function getSupporterName(
        address addr
    ) public view returns (string memory) {
        require(isSupporterRegistered[msg.sender]);
        return supporterNames[addr];
    }

    function changeSupporterName(string memory name) external {
        require(isSupporterRegistered[msg.sender]);
        supporterNames[msg.sender] = name;
    }

    function registerProject(string memory name) external {
        require(!isProjectRegistered[msg.sender]);
        projects[projectId] = msg.sender;
        projectIdFromAddress[msg.sender] = projectId;
        projectNames[msg.sender] = name;
        isProjectRegistered[msg.sender] = true;
        projectId += 1;
    }

    function getProjectName(address addr) public view returns (string memory) {
        require(isProjectRegistered[msg.sender]);
        return projectNames[addr];
    }

    function changeProjectName(string memory name) external {
        supporterNames[msg.sender] = name;
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
    }

    function withdraw() external {
        payable(msg.sender).transfer(
            getDonationAmount(projectIdFromAddress[msg.sender])
        );
        delete donations[projectIdFromAddress[msg.sender]];
    }

    function getDonationAmount(uint256 id) public view returns (uint256) {
        require(id <= projectId);
        uint256 amount = 0;
        for (uint256 i = 0; i < donations[id].length; i++) {
            console.log(donations[id][i].amount);
            amount += donations[id][i].amount;
        }
        return amount;
    }
}
