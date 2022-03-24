// https://trufflesuite.com/blog/introducing-ganache-7/index.html#5-mine-blocks-instantly-at-interval-or-on-demand
// npx ganache --fork https://api.avax.network/ext/bc/C/rpc --miner.blockTime 0 --fork.requestsPerSecond 0 --wallet.mnemonic "pudding party palace jazz august scissors fog knock enjoy direct matrix spot"
// npx hardhat node --show-stack-traces --fork https://api.avax.network/ext/bc/C/rpc
const { expect, assert } = require('chai');
const BigNumber = require("bignumber.js");
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/avalanche.json")));

const UNISWAP_ROUTER_ADDRESS = "0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106"; // "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D" ETH -- "0xD99D1c33F9fC3444f8101754aBC46c52416550D1" BSC_TESTNET;
const COMPTROLLER_ADDRESS = "0x2eE80614Ccbc5e28654324a66A396458Fa5cD7Cc"; // "0xfD36E2c2a6789Db23113685031d7F16329158384" - Comptroller Venus;
const PRICE_FEED_ADDRESS = "0x0980f2F0D2af35eF2c4521b2342D59db575303F7";
const ASSETS = ["0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7", "0xc7198437980c041c805A1EDcbA50c1Ce5db95118"]; // ETH & USDC
const INVERTED_ASSETS = ["0xc7198437980c041c805A1EDcbA50c1Ce5db95118", "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7"];
const C_ASSETS = ["0xb3c68d69E95B095ab4b33B4cB67dBc0fbF3Edf56", "0xCEb1cE674f38398432d20bc8f90345E91Ef46fd3"];
const CONSOLE_LOG = true;
const ETH = "500";

describe("ManagerAvaxMOCK", async () => {
		let signers, manager;
		const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

		beforeEach(async () => {
				signers = await ethers.getSigners();
				ManagerAvaxMOCK = await ethers.getContractFactory("ManagerAvaxMOCK");
				manager = await ManagerAvaxMOCK.deploy(UNISWAP_ROUTER_ADDRESS, COMPTROLLER_ADDRESS, PRICE_FEED_ADDRESS, ASSETS, C_ASSETS, ASSETS[0]);
		});

		it("should deploy manager contract correctly", async () => {
			assert(manager.address != undefined && manager.address != '');
		});

		it("should set price feed address correctly", async () => {
			const priceFeedAddress = await manager.getPriceFeedAddress();
			if (CONSOLE_LOG) {
				console.log(`Price Feed Address: ${priceFeedAddress}`)
			}
			assert(priceFeedAddress != undefined && priceFeedAddress != '');
		});

		it("should query price from price feed contract correctly", async () => {
			const price = await manager.queryPriceFromAsset(C_ASSETS[0]);
			if (CONSOLE_LOG) {
				console.log(`Price AVAX: ${price}`);
			}
			assert(price != undefined && price != 0);
		});

		it(`owner address should be the same address from deployment`, async () => {
			const owner = await manager.owner();
			assert(owner == signers[0].address);
		});

		it(`should show the assets pair address obtained from exchange router`, async () => {
			const pairAddress = await manager.getPairAddress();
			if (CONSOLE_LOG)
				console.log(`AVAX|USD Pair Address: ${pairAddress}`);
			assert(pairAddress != '' || pairAddress != ZERO_ADDRESS);
		});

		it(`should query price of assets correctly`, async () => {
			const price = await manager.queryPrice();
			if (CONSOLE_LOG)
				console.log(`AVAX|USD Price: ${price}`);
			assert(price != 0);
		});

		it(`should update the DSR token address correctly`, async () => {
			const oldDsrAddress = await manager.getDsrTokenAddress();
			const dsrAddress = "0x94d1820b2D1c7c7452A163983Dc888CEC546b77D";
			await manager.setDsrTokenAddress(dsrAddress);
			const newDsrAddress = await manager.getDsrTokenAddress();
			if (CONSOLE_LOG)
				console.log(`DSR Token Address: ${newDsrAddress}`);
			assert(oldDsrAddress != newDsrAddress);
		});

		it(`must create two accounts for investment`, async () => {
			const account0 = await manager.getAccount(0);
			const account1 = await manager.getAccount(1);
			if (CONSOLE_LOG) {
				console.log(account0);
				console.log(account1);
			}
			assert(account0 != ZERO_ADDRESS && account0 != '' && account1 != ZERO_ADDRESS && account1 != '');
		});

		it(`should pass the comptroller address to created accounts`, async() => {
			const comptrollerAddress = await manager.getComptrollerAddress();
			if (CONSOLE_LOG)
				console.log(`Comptroller Address: ${comptrollerAddress}`);
			assert(comptrollerAddress == COMPTROLLER_ADDRESS);
		});

		it(`should invest resources automatically, right after it receives some AVAX amount`, async () => {
			const account01 = await manager.getAccount(0);
			const account02 = await manager.getAccount(1);
			const tx = await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther(ETH)});
			const IERC20 = await artifacts.readArtifact("IERC20");
			const InvestmentAccount = await artifacts.readArtifact("InvestmentAccount");
			const cEth = new ethers.Contract(C_ASSETS[0], IERC20.abi, ethers.provider);
			const cUsd = new ethers.Contract(C_ASSETS[1], IERC20.abi, ethers.provider);
			const A01 = new ethers.Contract(account01, InvestmentAccount.abi, ethers.provider);
			const A02 = new ethers.Contract(account02, InvestmentAccount.abi, ethers.provider);
			const balance_cETH = await cEth.balanceOf(account01);
			const balance_cUSD = await cUsd.balanceOf(account02);
			// const borrowedBalanceAccount01 = await A01.balanceETH();
			// const borrowedBalanceAccount02 = await A02.balanceUSD();
			if (CONSOLE_LOG) {
				const exposure = await manager.getExposureOfAccounts();
				console.log(exposure);
				console.log(`Balance of Account #1 - ${account01}: ${balance_cETH}`);
				console.log(`Balance of Account #2 - ${account02}: ${balance_cUSD}`);
				// console.log(`Borrow Balance of Account #1 - ${account01}: ${borrowedBalanceAccount01}`);
				// console.log(`Borrow Balance of Account #2 - ${account02}: ${borrowedBalanceAccount02}`);
			}
			// assert(balance_cETH != 0 && balance_cUSD != 0 && borrowedBalanceAccount01 != 0 && borrowedBalanceAccount02 != 0);
			assert(balance_cETH != 0 && balance_cUSD != 0);
		});

		it(`should adjust the exposure according to the price movement`, async () => {
			await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther(ETH)});
			const previousExposure = await manager.getExposureOfAccounts();
			const IUniswapV2Router02 = await artifacts.readArtifact("IUniswapV2Router02");
			const exchangeRouter_ = new ethers.Contract(UNISWAP_ROUTER_ADDRESS, IUniswapV2Router02.abi, ethers.provider);
			const exchangeRouter = exchangeRouter_.connect(ethers.provider.getSigner(signers[0].address));
			await exchangeRouter.swapExactAVAXForTokensSupportingFeeOnTransferTokens(0, ASSETS, signers[0].address, 200000000000000, {value: ethers.utils.parseEther(ETH)});
			await manager.adjustExposureOfAccounts(5);
			const currentExposure = await manager.getExposureOfAccounts();
			if (CONSOLE_LOG) {
				console.log(previousExposure);
				console.log(currentExposure);
			}
			assert(previousExposure[0] < currentExposure[0] && previousExposure[1] > currentExposure[1]);
		});

		it(`should rebalance positions and charge comission if the exposure difference gets greater than the maximum allowed (4%)`, async () => {
			await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther(ETH)});
			const previousExposure = await manager.getExposureOfAccounts();
			const IUniswapV2Router02_ = await artifacts.readArtifact("IUniswapV2Router02");
			const router_ = new ethers.Contract(UNISWAP_ROUTER_ADDRESS, IUniswapV2Router02_.abi, ethers.provider);
			const router = router_.connect(ethers.provider.getSigner(signers[0].address));
			await router.swapExactAVAXForTokensSupportingFeeOnTransferTokens(0, ASSETS, signers[0].address, 200000000000000, {value: ethers.utils.parseEther(ETH)});
			await manager.adjustExposureOfAccounts(5);
			const currentExposure = await manager.getExposureOfAccounts();
			const previousBalance = await ethers.provider.getBalance(signers[0].address);
			await manager.checkForProfit();
			const currentBalance = await ethers.provider.getBalance(signers[0].address);
			const rebalancedExposure = await manager.getExposureOfAccounts();
			if (CONSOLE_LOG) {
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

		it(`should be able to reset positions and withdraw all the investment`, async () => {
			await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther(ETH)});
			const previousExposure = await manager.getExposureOfAccounts();
			const previousBalance = await ethers.provider.getBalance(signers[0].address);
			await manager.withdrawInvestment();
			const currentExposure = await manager.getExposureOfAccounts();
			const currentBalance = await ethers.provider.getBalance(signers[0].address);
			if (CONSOLE_LOG) {
				console.log(previousExposure);
				console.log(currentExposure);
				console.log(previousBalance);
				console.log(currentBalance);
			}
			assert(previousExposure[0] > 0 && previousExposure[1] > 0 && currentExposure[0] == 0 && currentExposure[1] == 0);
		});
});
