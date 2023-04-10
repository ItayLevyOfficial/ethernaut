// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./base/Level.sol";
import "./PriceIt.sol";
import {ERC20} from "openzeppelin-contracts-08/token/ERC20/ERC20.sol";

contract TestingERC20 is Ownable, ERC20 {
  constructor(string memory _name, string memory _symbol) Ownable() ERC20(_name, _symbol) {}

  function mint(address account, uint256 amount) external onlyOwner {
    _mint(account, amount);
  }
}
// contract MockedUniswapV2Factory {
//   mapping(address => mapping(address => address)) public getPair;
//   address public feeTo;

//   constructor(address _feeTo) {
//     feeTo = _feeTo;
//   }

//   function createPair(address tokenA, address tokenB) external returns (address pair) {
//     (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
//     bytes memory bytecode = type(UniswapV2Pair).creationCode;
//     bytes32 salt = keccak256(abi.encodePacked(token0, token1));
//     assembly {
//       pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
//     }
//     UniswapV2Pair(pair).initialize(token0, token1);
//     getPair[token0][token1] = pair;
//     getPair[token1][token0] = pair;
//     return pair;
//   }
// }

// contract MockedUniswapV2Router {
//   address public immutable factory;

//   constructor(address _factory) {
//     factory = _factory;
//   }

//   function addLiquidity(
//     address tokenA,
//     address tokenB,
//     uint256 amountADesired,
//     uint256 amountBDesired,
//     address to,
//     address pair
//   ) external virtual {
//     IERC20(tokenA).transferFrom(msg.sender, pair, amountADesired);
//     IERC20(tokenB).transferFrom(msg.sender, pair, amountBDesired);
//     IUniswapV2Pair(pair).mint(to);
//   }

//   function getAmountOut(
//     uint256 amountIn,
//     uint256 reserveIn,
//     uint256 reserveOut
//   ) public pure virtual returns (uint256 amountOut) {
//     uint256 amountInWithFee = amountIn * 997;
//     uint256 numerator = amountInWithFee * reserveOut;
//     uint256 denominator = (reserveIn * 1000) + (amountInWithFee);
//     amountOut = numerator / denominator;
//   }
// }
