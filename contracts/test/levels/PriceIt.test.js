const PriceIt = artifacts.require('./levels/PriceIt.sol');
const PriceItFactory = artifacts.require('./levels/PriceItFactory.sol');
const IUniswapV2Factory = artifacts.require('./helpers/uniswap/interfaces/IUniswapV2Factory.sol');
const IUniswapV2Pair = artifacts.require('./helpers/uniswap/interfaces/IUniswapV2Pair.sol');
const PriceItAttack = artifacts.require('./attacks/PriceItAttack');
const { BN, constants, expectEvent, expectRevert } = require('openzeppelin-test-helpers');
const utils = require('../utils/TestUtils');

contract('PriceIt', function (accounts) {
  let ethernaut;
  let level;
  let owner = accounts[1];
  let player = accounts[0];
  let instance;

  before(async function () {
    ethernaut = await utils.getEthernautWithStatsProxy();
    level = await PriceItFactory.new();
    // log the factory address
    console.log('factory address: ', level.address);
    await ethernaut.registerLevel(level.address);
  });

  it('should fail if the player did not solve the level', async function () {
    // log the test startes
    console.log('test started');

    instance = await utils.createLevelInstance(ethernaut, level.address, player, PriceIt);
    // log the instance created
    console.log('instance created');
    
    const completed = await utils.submitLevelInstance(ethernaut, level.address, instance.address, player);
    assert.isFalse(completed);
  });

  // it("should fail if the pairs didn't create", async function () {
  //   const instance = await utils.createLevelInstance(ethernaut, level.address, player, PriceIt);
  //   const [token0, token1, token2, uniFactoryAddress] = await Promise.all([
  //     instance.token0(),
  //     instance.token1(),
  //     instance.token2(),
  //     instance.uniFactory(),
  //   ]);
  //   const uniFactory = await IUniswapV2Factory.at(uniFactoryAddress);
  //   const token0_token1 = await uniFactory.getPair(token0, token1);
  //   const token0_token2 = await uniFactory.getPair(token0, token2);
  //   assert.notEqual(token0_token1, constants.ZERO_ADDRESS);
  //   assert.notEqual(token0_token2, constants.ZERO_ADDRESS);

  //   const token1_token2 = await uniFactory.getPair(token1, token2);
  //   assert.equal(token1_token2, constants.ZERO_ADDRESS);
  // });

  // it("should fail if the pools are not loaded with the correct liquidity amount", async function () {
  //   const instance = await utils.createLevelInstance(ethernaut, level.address, player, PriceIt);
  //   const [token0, token1, token2, uniFactoryAddress] = await Promise.all([
  //     instance.token0(),
  //     instance.token1(),
  //     instance.token2(),
  //     instance.uniFactory(),
  //   ]);
  //   const expectedAmount = '100000000000000000000000';
  //   const uniFactory = await IUniswapV2Factory.at(uniFactoryAddress);
  //   async function verifyPair(firstToken, secondToken) {
  //     const pairAddress = await uniFactory.getPair(firstToken, secondToken);
  //     const pairContract = await IUniswapV2Pair.at(pairAddress);
  //     const reserves = await pairContract.getReserves();
  //     assert.equal(reserves.reserve0.toString(), expectedAmount);
  //     assert.equal(reserves.reserve1.toString(), expectedAmount);
  //   }
  //   await verifyPair(token0, token1);
  //   await verifyPair(token0, token2);
  // });

  // it('should allow the player to solve the level', async function () {
  //   const instance = await utils.createLevelInstance(ethernaut, level.address, player, PriceIt);
  //   const attacker = await PriceItAttack.new();
  //   await attacker.doYourThing(instance.address);
  //   const completed = await utils.submitLevelInstance(ethernaut, level.address, instance.address, player);
  //   assert.isTrue(completed);
  // });
});
