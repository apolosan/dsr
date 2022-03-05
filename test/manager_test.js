const { expect, assert } = require('chai');
const BigNumber = require("bignumber.js");

const UNISWAP_ROUTER_ADDRESS = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"; // "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D" ETH -- "0xD99D1c33F9fC3444f8101754aBC46c52416550D1" BSC_TESTNET;
const COMPTROLLER_ADDRESS = "0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B";
const ASSETS = ["0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"]; // ETH & USDC
const INVERTED_ASSETS = ["0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"];
const C_ASSETS = ["0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5", "0x39AA39c021dfbaE8faC545936693aC917d5E7563"];
const CONSOLE_LOG = true;

// TEST FUNCTIONS ON Manager.sol
// function testGetAccount(uint256 index) public view returns(address) {
// 	return _accounts[index];
// }
//
// function testGetComptrollerAddress() public view returns(address) {
// 	return InvestmentAccount(payable(_accounts[0])).testGetComptrollerAddress();
// }

// TEST FUNCTIONS ON InvestmentAccount.sol
// function testGetComptrollerAddress() public view returns(address) {
// 	return comptrollerAddress;
// }

describe("Manager", async () => {
		let signers, manager;
		const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

		beforeEach(async () => {
				signers = await ethers.getSigners();
				Manager = await ethers.getContractFactory("Manager");
				manager = await Manager.deploy(UNISWAP_ROUTER_ADDRESS, COMPTROLLER_ADDRESS, ASSETS, C_ASSETS);
				const IUniswapV2Router02 = await artifacts.readArtifact("IUniswapV2Router02");
				const exchangeRouter_ = new ethers.Contract(UNISWAP_ROUTER_ADDRESS, IUniswapV2Router02.abi, ethers.provider);
				const exchangeRouter = exchangeRouter_.connect(ethers.provider.getSigner(signers[0].address));
				await exchangeRouter.swapExactETHForTokensSupportingFeeOnTransferTokens(0, ASSETS, signers[0].address, 200000000000000, {value: ethers.utils.parseEther("50.0")});
		});

		it("should deploy manager contract correctly", async () => {
			assert(manager.address != undefined && manager.address != '');
		});

		it(`owner address should be the same address from deployment`, async () => {
			const owner = await manager.owner();
			assert(owner == signers[0].address);
		});

		it(`should show the assets pair address obtained from exchange router`, async () => {
			const pairAddress = await manager._pair();
			if (CONSOLE_LOG)
				console.log(`ETH|USD Pair Address: ${pairAddress}`);
			assert(pairAddress != '' || pairAddress != ZERO_ADDRESS);
		});

		it(`should query price of assets correctly`, async () => {
			const price = await manager.queryPrice();
			if (CONSOLE_LOG)
				console.log(`ETH|USD Price: ${price}`);
			assert(price != 0);
		});

		it(`should update the DSR token address correctly`, async () => {
			const oldDsrAddress = await manager._dsrTokenAddress();
			const dsrAddress = "0xD99D1c33F9fC3444f8101754aBC46c52416550D1";
			await manager.setDsrTokenAddresss(dsrAddress);
			const newDsrAddress = await manager._dsrTokenAddress();
			if (CONSOLE_LOG)
				console.log(`DSR Token Address: ${newDsrAddress}`);
			assert(oldDsrAddress != newDsrAddress);
		});

		it(`must create two accounts for investment`, async () => {
			const account0 = await manager.testGetAccount(0);
			const account1 = await manager.testGetAccount(1);
			if (CONSOLE_LOG) {
				console.log(account0);
				console.log(account1);
			}
			assert(account0 != ZERO_ADDRESS && account0 != '' && account1 != ZERO_ADDRESS && account1 != '');
		});

		it(`should pass the comptroller address to created accounts`, async() => {
			const comptrollerAddress = await manager.testGetComptrollerAddress();
			if (CONSOLE_LOG)
				console.log(`Comptroller Address: ${comptrollerAddress}`);
			assert(comptrollerAddress == COMPTROLLER_ADDRESS);
		});

		it(`should invest resources automatically, right after it receives some ETH amount`, async () => {
			const account01 = await manager.testGetAccount(0);
			const account02 = await manager.testGetAccount(1);
			const tx = await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther("1.0")});
			const IERC20 = await artifacts.readArtifact("IERC20");
			const InvestmentAccount = await artifacts.readArtifact("InvestmentAccount");
			const cEth = new ethers.Contract(C_ASSETS[0], IERC20.abi, ethers.provider);
			const cUsd = new ethers.Contract(C_ASSETS[1], IERC20.abi, ethers.provider);
			const A01 = new ethers.Contract(account01, InvestmentAccount.abi, ethers.provider);
			const A02 = new ethers.Contract(account02, InvestmentAccount.abi, ethers.provider);
			const balance_cETH = await cEth.balanceOf(account01);
			const balance_cUSD = await cUsd.balanceOf(account02);
			const borrowedBalanceAccount01 = await A01.balanceETH();
			const borrowedBalanceAccount02 = await A02.balanceUSD();
			if (CONSOLE_LOG) {
				const exposure = await manager.getExposureOfAccounts();
				console.log(exposure);
				console.log(`Balance of Account #1 - ${account01}: ${balance_cETH}`);
				console.log(`Balance of Account #2 - ${account02}: ${balance_cUSD}`);
				console.log(`Borrow Balance of Account #1 - ${account01}: ${borrowedBalanceAccount01}`);
				console.log(`Borrow Balance of Account #2 - ${account02}: ${borrowedBalanceAccount02}`);
			}
			assert(balance_cETH != 0 && balance_cUSD != 0 && borrowedBalanceAccount01 != 0 && borrowedBalanceAccount02 != 0);
		});

		it(`should adjust the exposure according to the price movement`, async () => {
			await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther("1.0")});
			const previousExposure = await manager.getExposureOfAccounts();
			const IUniswapV2Router02 = await artifacts.readArtifact("IUniswapV2Router02");
			const exchangeRouter_ = new ethers.Contract(UNISWAP_ROUTER_ADDRESS, IUniswapV2Router02.abi, ethers.provider);
			const exchangeRouter = exchangeRouter_.connect(ethers.provider.getSigner(signers[0].address));
			await exchangeRouter.swapExactETHForTokensSupportingFeeOnTransferTokens(0, ASSETS, signers[0].address, 200000000000000, {value: ethers.utils.parseEther("2.0")});
			const currentExposure = await manager.getExposureOfAccounts();
			if (CONSOLE_LOG) {
				console.log(previousExposure);
				console.log(currentExposure);
			}
			assert(previousExposure[0] < currentExposure[0] && previousExposure[1] > currentExposure[1]);
		});

		it(`should rebalance positions and charge comission if the exposure difference gets greater than the maximum allowed (1%)`, async () => {
			await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther("1.0")});
			const previousExposure = await manager.getExposureOfAccounts();
			const IUniswapV2Router02_ = await artifacts.readArtifact("IUniswapV2Router02");
			const router_ = new ethers.Contract(UNISWAP_ROUTER_ADDRESS, IUniswapV2Router02_.abi, ethers.provider);
			const router = router_.connect(ethers.provider.getSigner(signers[0].address));
			const IERC20 = await artifacts.readArtifact("IERC20");
			const usd = new ethers.Contract(ASSETS[1], IERC20.abi, ethers.provider);
			const balanceUSD = await usd.balanceOf(signers[0].address);
			await usd.connect(ethers.provider.getSigner(signers[0].address)).approve(router.address, balanceUSD);
			await router.swapExactTokensForETHSupportingFeeOnTransferTokens(balanceUSD, 0, INVERTED_ASSETS, signers[0].address, 200000000000000);
			const currentExposure = await manager.getExposureOfAccounts();
			await manager.testSetExposureDifference(1);
			const previousBalance = await ethers.provider.getBalance(signers[0].address);
			await manager.checkForProfit();
			const currentBalance = await ethers.provider.getBalance(signers[0].address);
			const rebalancedExposure = await manager.getExposureOfAccounts();
			if (CONSOLE_LOG) {
				console.log(`USD Balance: ${balanceUSD}`);
				console.log(previousExposure);
				console.log(currentExposure);
				console.log(rebalancedExposure);
				console.log(previousBalance);
				console.log(currentBalance);
			}
			assert(previousExposure[0] < currentExposure[0] &&
				currentExposure[0].toString() != rebalancedExposure[0].toString() &&
				previousExposure[1] > currentExposure[1] &&
				currentExposure[1].toString() != rebalancedExposure[1].toString() &&
				currentBalance > previousBalance);
		});

		// it(`should rebalance positions and charge comission in USD as well (FORCED)`, async () => {
		// 	await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther("2")});
		// 	const account01 = await manager.testGetAccount(0);
		// 	const previousExposure = await manager.getExposureOfAccounts();
		// 	const InvestmentAccount = await artifacts.readArtifact("InvestmentAccount");
		// 	const A01 = new ethers.Contract(account01, InvestmentAccount.abi, ethers.provider);
		// 	await A01.connect(ethers.provider.getSigner(signers[0].address)).testReduceBorrowedUSD();
		// 	const currentExposure = await manager.getExposureOfAccounts();
		// 	await manager.testSetExposureDifference(2);
		// 	const previousBalance = await ethers.provider.getBalance(signers[0].address);
		// 	await manager.checkForProfit();
		// 	const currentBalance = await ethers.provider.getBalance(signers[0].address);
		// 	const rebalancedExposure = await manager.getExposureOfAccounts();
		// 	if (CONSOLE_LOG) {
		// 		console.log(previousExposure);
		// 		console.log(currentExposure);
		// 		console.log(rebalancedExposure);
		// 		console.log(previousBalance);
		// 		console.log(currentBalance);
		// 	}
		// 	assert(currentBalance > previousBalance);
		// });

		// it(`should rebalance positions and charge comission if one exposure gets greater than the maximum allowed (70% and FORCED)`, async () => {
		// 	await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther("1.0")});
		// 	const previousExposure = await manager.getExposureOfAccounts();
		// 	const InvestmentAccount = await artifacts.readArtifact("InvestmentAccount");
		// 	const account01 = await manager.testGetAccount(0);
		// 	const A01 = new ethers.Contract(account01, InvestmentAccount.abi, ethers.provider);
		// 	await A01.connect(ethers.provider.getSigner(signers[0].address)).testIncreaseBorrowedUSD();
		// 	const currentExposure = await manager.getExposureOfAccounts();
		// 	const previousBalance = await ethers.provider.getBalance(signers[0].address);
		// 	await manager.checkForProfit();
		// 	const currentBalance = await ethers.provider.getBalance(signers[0].address);
		// 	const rebalancedExposure = await manager.getExposureOfAccounts();
		// 	if (CONSOLE_LOG) {
		// 		console.log(previousExposure);
		// 		console.log("INCREASE");
		// 		console.log(currentExposure);
		// 		console.log("REBALANCE #1");
		// 		console.log(rebalancedExposure);
		// 		console.log(previousBalance);
		// 		console.log(currentBalance);
		// 	}
		// 	assert(previousExposure[0] < currentExposure[0] &&
		// 		currentExposure[0].toString() != rebalancedExposure[0].toString() &&
		// 		previousExposure[1] > currentExposure[1] &&
		// 		currentExposure[1].toString() != rebalancedExposure[1].toString() &&
		// 		currentBalance > previousBalance);
		// });

		it(`should be able to reset positions and withdraw all the investment`, async () => {
			await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther("2")});
			const previousExposure = await manager.getExposureOfAccounts();
			await manager.withdrawInvestment();
			const currentExposure = await manager.getExposureOfAccounts();
			if (CONSOLE_LOG) {
				console.log(previousExposure);
				console.log(currentExposure);
			}
			assert(previousExposure[0] > 0 && previousExposure[1] > 0 && currentExposure[0] == 0 && currentExposure[1] == 0);
		});
});
