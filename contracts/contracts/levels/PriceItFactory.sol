// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "./PriceItFactoryHelpers.sol";
import { UniswapV2Factory } from "../helpers/uniswap/UniswapV2Factory.sol";
import "hardhat/console.sol";

contract PriceItFactory is Level {
  uint256 private constant amount = 100000 ether;
  IUniswapV2Factory uniFactory;
  IUniswapV2Router uniRouter;

  constructor() {
    uniFactory = new UniswapV2Factory(address(this));
    uniFactory.setFeeTo(address(this));
    uniRouter = new UniswapV2Router(address(uniFactory), address(this));
  }

  function createInstance(address) public payable override returns (address) {
    // log it started running
    console.log("PriceItFactory.createInstance() started");
    TestingERC20 token0 = new TestingERC20("Token 0", "TZERO");
    TestingERC20 token1 = new TestingERC20("Token 1", "TONE");
    TestingERC20 token2 = new TestingERC20("Token 2", "TTWO");
    PriceIt level = new PriceIt(token0, token1, token2, address(uniFactory), address(uniRouter));
    // log it got here
    console.log("PriceItFactory.createInstance() got here");
    token0.mint(address(level), amount);
    token1.mint(address(level), amount);
    console.log("PriceItFactory.createInstance() got there");
    createPair(token0, token1);
    console.log("adfnsjlkd");
    createPair(token0, token2);
    // log it finished running
    console.log("PriceItFactory.createInstance() finished");
    return address(level);
  }

  function validateInstance(address payable _instance, address _player) public view override returns (bool) {
    IERC20 token0 = PriceIt(_instance).token0();
    return token0.balanceOf(_player) > 9000 ether;
  }

  function createPair(TestingERC20 _token0, TestingERC20 _token1) private {
    // log it started running with a number
    console.log("PriceItFactory.createPair() started with 1");
    address pair = uniFactory.createPair(address(_token0), address(_token1));
    console.log("PriceItFactory.createPair() started with 2");
    _token0.mint(address(this), amount);
    _token1.mint(address(this), amount);
    console.log("PriceItFactory.createPair() started with 3");
    _token0.approve(address(uniRouter), amount);
    _token1.approve(address(uniRouter), amount);
    console.log("PriceItFactory.createPair() started with 4");
    uniRouter.addLiquidity(
      address(_token0),
      address(_token1),
      amount,
      amount,
      amount,
      amount,
      msg.sender,
      block.timestamp
    );
    console.log("PriceItFactory.createPair() started with 5");
  }
}
