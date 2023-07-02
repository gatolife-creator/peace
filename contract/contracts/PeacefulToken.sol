// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PeacefulToken is ERC20 {
    address owner;
    address contractAddress;

    modifier isValidContract() {
        require(msg.sender == contractAddress);
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() ERC20("PeacefulToken", "PFT") {
        owner = msg.sender;
    }

    function mint(address sender, uint256 amount) public payable {
        return _mint(sender, amount);
    }

    function balanceOf(address _address) public view override returns (uint256) {
        return super.balanceOf(_address);
    }

    function updateContract(address _address) external isOwner {
        contractAddress = _address;
    }

    function updateOwner(address _address) external isOwner {
        owner = _address;
    }
}
