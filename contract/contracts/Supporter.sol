// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

contract Supporter {
    string public name;
    string public intro;

    constructor(string memory _name, string memory _intro) {
        name = _name;
        intro = _intro;
    }

    function fixSupporterInfo(
        string memory _name,
        string memory _intro
    ) external {
        name = _name;
        intro = _intro;
    }
}
