const { expect, assert } = require('chai');
const BigNumber = require("bignumber.js");

const UNISWAP_ROUTER_ADDRESS = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"; // "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D" ETH -- "0xD99D1c33F9fC3444f8101754aBC46c52416550D1" BSC_TESTNET;
const COMPTROLLER_ADDRESS = "0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B";
const ASSETS = ["0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"]; // ETH & USDC
const C_ASSETS = ["0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5", "0x39AA39c021dfbaE8faC545936693aC917d5E7563"];

describe("Manager", async () => {
		let signers, manager;
		const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

		beforeEach(async () => {
				signers = await ethers.getSigners();
				Manager = await ethers.getContractFactory("Manager");
				manager = await Manager.deploy(UNISWAP_ROUTER_ADDRESS, COMPTROLLER_ADDRESS, ASSETS, C_ASSETS);
		});

		// it("should deploy manager contract correctly", async () => {
		// 	assert(manager.address != undefined && manager.address != '');
		// });
		//
		// it(`owner address should be the same address from deployment`, async () => {
		// 	const owner = await manager.owner();
		// 	assert(owner == signers[0].address);
		// });
		//
		// it(`should show the assets pair address obtained from exchange router`, async () => {
		// 	const pairAddress = await manager._pair();
		// 	// console.log(`ETH|USD Pair Address: ${pairAddress}`);
		// 	assert(pairAddress != '' || pairAddress != ZERO_ADDRESS);
		// });
		//
		// it(`should query price of assets correctly`, async () => {
		// 	const price = await manager.queryPrice();
		// 	// console.log(`ETH|USD Price: ${price}`);
		// 	assert(price != 0);
		// });
		//
		// it(`should update the DSR token address correctly`, async () => {
		// 	const oldDsrAddress = await manager._dsrTokenAddress();
		// 	const dsrAddress = "0xD99D1c33F9fC3444f8101754aBC46c52416550D1";
		// 	await manager.setDsrTokenAddresss(dsrAddress);
		// 	const newDsrAddress = await manager._dsrTokenAddress();
		// 	// console.log(`DSR Token Address: ${newDsrAddress}`);
		// 	assert(oldDsrAddress != newDsrAddress);
		// });
		//
		// it(`must create two accounts for investment`, async () => {
		// 	const account0 = await manager.testGetAccount(0);
		// 	const account1 = await manager.testGetAccount(1);
		// 	// console.log(account0);
		// 	// console.log(account1);
		// 	assert(account0 != ZERO_ADDRESS && account0 != '' && account1 != ZERO_ADDRESS && account1 != '');
		// });
		//
		// it(`should pass the comptroller address to created accounts`, async() => {
		// 	const comptrollerAddress = await manager.testGetComptrollerAddress();
		// 	// console.log(`Comptroller Address: ${comptrollerAddress}`);
		// 	assert(comptrollerAddress == COMPTROLLER_ADDRESS);
		// });

		it(`should invest resources automatically, right after receives some ETH amount`, async () => {
			const tx = await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther("1.0")});
			console.log(tx);
		});
});
