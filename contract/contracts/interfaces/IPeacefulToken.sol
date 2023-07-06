// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IPeacefulToken {
    function mint(address sender, uint256 amount) external payable;

    function balanceOf(address _address) external view returns (uint256);

    function updateContract(address _address) external;

    function updateOwner(address _address) external;
}
