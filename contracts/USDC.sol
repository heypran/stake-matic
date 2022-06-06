// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/access/Ownable.sol";

contract DevUSDC is ERC20, Ownable {
    
    constructor(string memory _tokenName,string memory _tokenSymbol) ERC20(_tokenName, _tokenSymbol) {}

    function mint(uint256 amount, address receiver) external onlyOwner {
        _mint(receiver, amount);
    }

}