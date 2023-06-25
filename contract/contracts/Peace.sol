// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Supporter.sol";
import "./Project.sol";
import "./BaseNFT.sol";

contract Peace is ERC20 {
    using SafeMath for uint256;
    address public owner;

    constructor() ERC20("PeacefulToken", "PFT") {
        owner = msg.sender;
    }

    event onRegisterAsSupporter(uint256 id, string name, string intro);
    event onRegisterAsProject(uint256 id, string name, string desc);
    event onFixSupporterInfo(uint256 id, string name, string intro);
    event onFixProjectInfo(uint256 id, string name, string desc);
    event onDonate(uint256 supporterId, uint256 projectId, uint256 amount);
    event onWithdraw(uint256 amount);

    struct Donation {
        address account;
        uint256 amount;
    }

    uint256 supporterId = 0;
    mapping(address => bool) private isSupporterRegistered;
    mapping(uint256 => address) supporters;
    mapping(address => uint256) supporterIdFromAddress;
    mapping(uint256 => Supporter) supporterInfo;
    mapping(uint256 => uint256) donationAmounts;

    uint256 projectId = 0;
    mapping(address => bool) isProjectReged;
    mapping(uint256 => address) projects;
    mapping(address => uint256) projectIdFromAddress;
    mapping(uint256 => Project) projectInfo;
    mapping(uint256 => Donation[]) donations;
    mapping(uint256 => uint256) donationAmountsForProject;
    mapping(uint256 => BaseNFT) nftContracts;

    function registerAsSupporter(
        string memory name,
        string memory intro
    ) external {
        require(!isSupporterRegistered[msg.sender]);
        supporters[supporterId] = msg.sender;
        supporterIdFromAddress[msg.sender] = supporterId;
        isSupporterRegistered[msg.sender] = true;
        supporterInfo[supporterId] = new Supporter(name, intro);
        emit onRegisterAsSupporter(supporterId, name, intro);
        supporterId = supporterId.add(1);
    }

    function getSupporterName(uint256 id) public view returns (string memory) {
        require(isSupporterRegistered[supporters[id]]);
        return supporterInfo[supporterId].name();
    }

    function getSupporterInfo(
        uint256 id
    ) public view returns (string memory, string memory) {
        return (supporterInfo[id].name(), supporterInfo[id].intro());
    }

    function fixSupporterInfo(
        string memory name,
        string memory intro
    ) external {
        require(isSupporterRegistered[msg.sender]);

        uint256 id = supporterIdFromAddress[msg.sender];
        supporterInfo[id] = new Supporter(name, intro);
        emit onFixSupporterInfo(id, name, intro);
    }

    function getNumOfSupporters() external view returns (uint256) {
        return supporterId;
    }

    function registerAsProject(
        string memory name,
        string memory desc
    ) external {
        require(!isProjectReged[msg.sender]);
        projects[projectId] = msg.sender;
        projectIdFromAddress[msg.sender] = projectId;
        projectInfo[projectId] = new Project(name, desc);
        isProjectReged[msg.sender] = true;
        emit onRegisterAsProject(projectId, name, desc);
        projectId = projectId.add(1);
    }

    function getProjectInfo(
        uint256 id
    ) public view returns (string memory, string memory) {
        require(isProjectReged[projects[id]]);
        return (projectInfo[id].name(), projectInfo[id].desc());
    }

    function fixProjectInfo(string memory name, string memory desc) external {
        require(isProjectReged[msg.sender]);
        uint256 id = projectIdFromAddress[msg.sender];
        projectInfo[id] = new Project(name, desc);
        emit onFixProjectInfo(id, name, desc);
    }

    function getNumOfProjects() external view returns (uint256) {
        return projectId;
    }

    function donate(uint256 id) public payable {
        require(
            isSupporterRegistered[msg.sender] && isProjectReged[projects[id]]
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
