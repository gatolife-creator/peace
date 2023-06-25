// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

contract Project {
    string public name;
    string public desc;

    constructor(string memory _name, string memory _desc) {
        name = _name;
        desc = _desc;
    }

    function fixInfo(
        string memory _name,
        string memory _desc
    ) external {
        name = _name;
        desc = _desc;
    }
}
