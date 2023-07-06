// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IPeaceStorage {
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

    function registerAsSupporter(
        string calldata name,
        string calldata intro,
        address sender
    ) external;

    function getSupporterName(uint256 id) external view returns (string memory);

    function getSupporterIdFromAddress(
        address _address
    ) external view returns (uint256);

    function getSupporterInfo(
        uint256 id
    ) external view returns (string memory, string memory);

    function fixSupporterInfo(
        string calldata name,
        string calldata intro,
        address sender
    ) external;

    function getNumOfSupporters() external view returns (uint256);

    function registerAsProject(
        string calldata name,
        string calldata desc,
        address sender
    ) external;

    function getProjectInfo(
        uint256 id
    ) external view returns (string memory, string memory);

    function getProjectIdFromAddress(
        address _address
    ) external view returns (uint256);

    function fixProjectInfo(
        string calldata name,
        string calldata desc,
        address sender
    ) external;

    function getNumOfProjects() external view returns (uint256);

    function donate(
        uint256 id,
        uint256 amount,
        address sender
    ) external payable;

    function getDonationAmountsForProject(
        uint256 id
    ) external view returns (uint256);

    function resetDonationAmountForProject(address sender) external;

    function updateContract(address _address) external;

    function updateOwner(address _address) external;
}
