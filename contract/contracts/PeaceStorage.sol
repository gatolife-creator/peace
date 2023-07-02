// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./BaseNFT.sol";

contract PeaceStorage {
    using SafeMath for uint256;

    address contractAddress;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier isValidContract() {
        require(msg.sender == contractAddress, "invalid contract address");
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner, "invalid owner address");
        _;
    }

    struct Donation {
        address account;
        uint256 amount;
    }

    struct Supporter {
        string name;
        string intro;
    }

    struct Project {
        string name;
        string desc;
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

    function registerAsSupporter(
        string memory name,
        string memory intro,
        address sender
    ) external isValidContract {
        require(!isSupporterRegistered[sender]);
        supporters[supporterId] = sender;
        supporterIdFromAddress[sender] = supporterId;
        isSupporterRegistered[sender] = true;
        supporterInfo[supporterId] = Supporter({name: name, intro: intro});
        supporterId = supporterId.add(1);
    }

    function getSupporterName(uint256 id) public view returns (string memory) {
        require(isSupporterRegistered[supporters[id]]);
        return supporterInfo[supporterId].name;
    }

    function getSupporterIdFromAddress(
        address _address
    ) external view isValidContract returns (uint256) {
        return supporterIdFromAddress[_address];
    }

    function getSupporterInfo(
        uint256 id
    ) public view returns (string memory, string memory) {
        return (supporterInfo[id].name, supporterInfo[id].intro);
    }

    function fixSupporterInfo(
        string memory name,
        string memory intro,
        address sender
    ) external isValidContract {
        require(isSupporterRegistered[sender]);

        uint256 id = supporterIdFromAddress[sender];
        supporterInfo[id] = Supporter({name: name, intro: intro});
    }

    function getNumOfSupporters() external view returns (uint256) {
        return supporterId;
    }

    function registerAsProject(
        string memory name,
        string memory desc,
        address sender
    ) external isValidContract {
        require(!isProjectRegistered[sender]);
        projects[projectId] = sender;
        projectIdFromAddress[sender] = projectId;
        projectInfo[projectId] = Project({name: name, desc: desc});
        isProjectRegistered[sender] = true;
        projectId = projectId.add(1);
    }

    function getProjectInfo(
        uint256 id
    ) public view returns (string memory, string memory) {
        require(isProjectRegistered[projects[id]]);
        return (projectInfo[id].name, projectInfo[id].desc);
    }

    function getProjectIdFromAddress(
        address _address
    ) external view isValidContract returns (uint256) {
        return projectIdFromAddress[_address];
    }

    function fixProjectInfo(
        string memory name,
        string memory desc,
        address sender
    ) external isValidContract {
        require(isProjectRegistered[sender]);
        uint256 id = projectIdFromAddress[sender];
        projectInfo[id] = Project({name: name, desc: desc});
    }

    function getNumOfProjects() external view returns (uint256) {
        return projectId;
    }

    function donate(uint256 id, uint256 amount, address sender) public payable {
        require(
            isSupporterRegistered[sender] && isProjectRegistered[projects[id]]
        );
        Donation memory donation = Donation({account: sender, amount: amount});
        donations[id].push(donation);
        donationAmountsForProject[id] = donationAmountsForProject[id].add(
            amount
        );
    }

    function getDonationAmountsForProject(
        uint256 id
    ) external view returns (uint256) {
        return donationAmountsForProject[id];
    }

    function resetDonationAmountForProject(
        address sender
    ) external isValidContract {
        donationAmountsForProject[projectIdFromAddress[sender]] = 0;
        delete donations[projectIdFromAddress[msg.sender]];
    }

    function updateContract(address _address) external isOwner {
        contractAddress = _address;
    }

    function updateOwner(address _address) external isOwner {
        owner = _address;
    }
}
