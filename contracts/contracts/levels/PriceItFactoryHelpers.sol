// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./base/Level-05.sol";
import "./PriceIt.sol";
import { ERC20 } from "openzeppelin-contracts-05/token/ERC20/ERC20.sol";

contract TestingERC20 is Ownable, ERC20 {
  constructor(string memory _name, string memory _symbol) Ownable() ERC20(_name, _symbol) {}

  function mint(address account, uint256 amount) external onlyOwner {
    _mint(account, amount);
  }
}