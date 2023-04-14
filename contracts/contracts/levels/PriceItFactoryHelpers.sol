// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import { ERC20 } from "openzeppelin-contracts-05/token/ERC20/ERC20.sol";
import { ERC20Detailed } from "openzeppelin-contracts-05/token/ERC20/ERC20Detailed.sol";
import { Ownable } from "openzeppelin-contracts-05/ownership/Ownable.sol";

contract TestingERC20 is Ownable, ERC20, ERC20Detailed {
  constructor(string memory _name, string memory _symbol) public Ownable() ERC20Detailed(_name, _symbol, 18) {}

  function mint(address account, uint256 amount) external onlyOwner {
    _mint(account, amount);
  }
}
