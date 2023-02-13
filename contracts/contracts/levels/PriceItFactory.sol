// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "./PriceItFactoryHelpers.sol";

contract PriceItFactory is Level {
  uint256 private constant amount = 100000 ether;
  MockedUniswapV2Factory uniFactory;
  MockedUniswapV2Router uniRouter;

  constructor() {
    uniFactory = new MockedUniswapV2Factory();
    uniRouter = new MockedUniswapV2Router(address(uniFactory));
  }

  function createInstance(address) public payable override returns (address) {
    TestingERC20 token0 = new TestingERC20("Token 0", "TZERO");
    TestingERC20 token1 = new TestingERC20("Token 1", "TONE");
    TestingERC20 token2 = new TestingERC20("Token 2", "TTWO");
    PriceIt level = new PriceIt(token0, token1, token2);
    token0.mint(address(level), amount);
    token1.mint(address(level), amount);
    createPair(token0, token1);
    createPair(token0, token2);
    return address(level);
  }

  function validateInstance(address payable _instance, address _player) public view override returns (bool) {
    IERC20 token0 = PriceIt(_instance).token0();
    return token0.balanceOf(_player) > 9000 ether;
  }

  function createPair(
    TestingERC20 _token0,
    TestingERC20 _token1
  ) private {
    address pair = uniFactory.createPair(address(_token0), address(_token1));
    _token0.mint(address(this), amount);
    _token1.mint(address(this), amount);
    _token0.approve(address(uniRouter), amount);
    _token1.approve(address(uniRouter), amount);
    uniRouter.addLiquidity(address(_token0), address(_token1), amount, amount, amount, amount, pair, block.timestamp);
  }
}

