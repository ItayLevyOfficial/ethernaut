// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../helpers/uniswap/UniswapV2Pair.sol";
import "../helpers/uniswap/interfaces/IUniswapV2Pair.sol";
import "../helpers/uniswap/interfaces/IUniswapV2Factory.sol";
import "../helpers/uniswap/interfaces/IUniswapV2Router01.sol";

contract PriceIt {
  IUniswapV2Factory public constant uniFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
  IUniswapV2Router01 public constant uniRouter = IUniswapV2Router01(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
  IERC20 public token0;
  IERC20 public token1;
  IERC20 public token2;

  constructor(
    IERC20 _token0,
    IERC20 _token1,
    IERC20 _token2
  ) {
    (token0, token1, token2) = (_token0, _token1, _token2);
  }

  function buyToken(uint256 inputAmount, IERC20 inputToken) external {
    IERC20 outputToken = inputToken == token0 ? token1 : token0;
    uint256 outputAmount = getTokenPrice(inputAmount, address(inputToken));
    inputToken.transferFrom(msg.sender, address(this), inputAmount);
    outputToken.transfer(msg.sender, outputAmount);
  }

  function getTokenPrice(uint256 inputAmount, address inputToken) private view returns (uint256) {
    IUniswapV2Pair pair = IUniswapV2Pair(uniFactory.getPair(address(token0), address(token1)));
    (uint256 resA, uint256 resB, ) = pair.getReserves();
    (address tokenA, address tokenB) = (pair.token0(), pair.token1());
    if (inputToken == tokenA) {
      return uniRouter.getAmountOut(inputAmount, resA, resB);
    } else if (inputToken == tokenB) {
      return uniRouter.getAmountOut(inputAmount, resB, resA);
    } else {
      revert("Input token is not part of the token0/token1 pair.");
    }
  }
}