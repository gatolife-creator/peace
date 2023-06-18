// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

contract Peace {
    uint256 supporterID = 0;
    mapping(uint256 => address) supporters;

    function registerAsSupporter() external {
        supporters[supporterID] = msg.sender;
        supporterID += 1;
    }
}
