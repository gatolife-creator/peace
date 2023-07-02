// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./PeaceStorage.sol";
import "./PeacefulToken.sol";

contract Peace {
    using SafeMath for uint256;
    address public owner;
    PeaceStorage peaceStorage;
    PeacefulToken tokenContract;

    uint256 gasFee;

    event onRegisterAsSupporter(uint256 id, string name, string intro);
    event onRegisterAsProject(uint256 id, string name, string desc);
    event onFixSupporterInfo(uint256 id, string name, string intro);
    event onFixProjectInfo(uint256 id, string name, string desc);
    event onDonate(uint256 supporterId, uint256 projectId, uint256 amount);
    event onWithdraw(uint256 amount);

    constructor(address storageAddress, address tokenAddress) payable {
        owner = msg.sender;
        peaceStorage = PeaceStorage(storageAddress);
        tokenContract = PeacefulToken(tokenAddress);
    }

    function addGusFee() external payable {
        gasFee += msg.value;
    }

    function registerAsSupporter(
        string memory name,
        string memory intro
    ) external {
        peaceStorage.registerAsSupporter(name, intro, msg.sender);
        emit onRegisterAsSupporter(
            peaceStorage.getSupporterIdFromAddress(msg.sender),
            name,
            intro
        );
    }

    function getSupporterName(uint256 id) public view returns (string memory) {
        return peaceStorage.getSupporterName(id);
    }

    function getSupporterInfo(
        uint256 id
    ) public view returns (string memory, string memory) {
        return peaceStorage.getSupporterInfo(id);
    }

    function fixSupporterInfo(
        string memory name,
        string memory intro
    ) external {
        peaceStorage.fixSupporterInfo(name, intro, msg.sender);
        emit onFixSupporterInfo(
            peaceStorage.getSupporterIdFromAddress(msg.sender),
            name,
            intro
        );
    }

    function getNumOfSupporters() external view returns (uint256) {
        return peaceStorage.getNumOfSupporters();
    }

    function registerAsProject(
        string memory name,
        string memory desc
    ) external {
        peaceStorage.registerAsProject(name, desc, msg.sender);
        emit onRegisterAsProject(
            peaceStorage.getProjectIdFromAddress(msg.sender),
            name,
            desc
        );
    }

    function getProjectInfo(
        uint256 id
    ) public view returns (string memory, string memory) {
        return peaceStorage.getProjectInfo(id);
    }

    function fixProjectInfo(string memory name, string memory desc) external {
        peaceStorage.fixProjectInfo(name, desc, msg.sender);
        emit onFixProjectInfo(
            peaceStorage.getProjectIdFromAddress(msg.sender),
            name,
            desc
        );
    }

    function getNumOfProjects() external view returns (uint256) {
        return peaceStorage.getNumOfProjects();
    }

    function donate(uint256 id) public payable {
        peaceStorage.donate(id, msg.value, msg.sender);
        tokenContract.mint(msg.sender, msg.value);
        emit onDonate(
            peaceStorage.getSupporterIdFromAddress(msg.sender),
            id,
            msg.value
        );
    }

    function withdraw() external {
        uint256 amount = peaceStorage.getDonationAmountsForProject(
            peaceStorage.getProjectIdFromAddress(msg.sender)
        );
        peaceStorage.resetDonationAmountForProject(msg.sender);
        payable(msg.sender).transfer(amount);
        emit onWithdraw(amount);
    }

    // function defineNewNFT(string memory name, string memory symbol) external {
    //     nftContracts[projectIdFromAddress[msg.sender]] = new BaseNFT(
    //         name,
    //         symbol
    //     );
    // }

    // function mint(uint256 id) external {
    //     nftContracts[id].mint();
    // }
}
