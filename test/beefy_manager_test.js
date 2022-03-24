const { expect, assert } = require('chai');
const BigNumber = require("bignumber.js");
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/bsc.json")));

const CONSOLE_LOG = true;
const ETH = "10";

describe("BeefyManager", async () => {
		let signers, manager;
		const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

		beforeEach(async () => {
				signers = await ethers.getSigners();
				Manager = await ethers.getContractFactory("BeefyManager");
				manager = await Manager.deploy(
					networkData.Contracts.ExchangeRouter,
					networkData.Contracts.Comptroller,
					networkData.Contracts.PriceFeed,
					networkData.Contracts.Assets,
					networkData.Contracts.CAssets,
					networkData.Contracts.Assets[0],
          networkData.Contracts.BeefyVaults[0]);
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
			const price = await manager.queryPriceFromAsset(networkData.Contracts.CAssets[0]);
			if (CONSOLE_LOG) {
				console.log(`Price ETH: ${price}`);
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
				console.log(`ETH|USD Pair Address: ${pairAddress}`);
			assert(pairAddress != '' || pairAddress != networkData.ZeroAddress);
		});

		it(`should query price of assets correctly`, async () => {
			const price = await manager.queryPrice();
			if (CONSOLE_LOG)
				console.log(`ETH|USD Price: ${price}`);
			assert(price != 0);
		});

		it(`should update the DSR token address correctly`, async () => {
			const oldDsrAddress = await manager.getDsrTokenAddress();
			const dsrAddress = "0xD99D1c33F9fC3444f8101754aBC46c52416550D1";
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
			assert(account0 != networkData.ZeroAddress && account0 != '' && account1 != networkData.ZeroAddress && account1 != '');
		});

		it(`should pass the comptroller address to created accounts`, async() => {
			const comptrollerAddress = await manager.getComptrollerAddress();
			if (CONSOLE_LOG)
				console.log(`Comptroller Address: ${comptrollerAddress}`);
			assert(comptrollerAddress == networkData.Contracts.Comptroller);
		});

		it(`should invest resources automatically, right after it receives some ETH amount`, async () => {
			const tx = await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther(ETH)});
			const exposure = await manager.getExposureOfAccounts();
			if (CONSOLE_LOG)
				console.log(exposure);
			assert(exposure[0] > 0 && exposure[1] > 0);
		});

		it(`should adjust the exposure according to the price movement`, async () => {
			const BeefyManagerMOCK = await ethers.getContractFactory("BeefyManagerMOCK");
			const managerMock = await BeefyManagerMOCK.deploy(
				networkData.Contracts.ExchangeRouter,
				networkData.Contracts.Comptroller,
				networkData.Contracts.PriceFeed,
				networkData.Contracts.Assets,
				networkData.Contracts.CAssets,
				networkData.Contracts.Assets[0],
				networkData.Contracts.BeefyVaults[0]);

			await signers[0].sendTransaction({to: managerMock.address, value: ethers.utils.parseEther(ETH)});
			const oldPrice = await managerMock.queryPrice();
			const previousExposure = await managerMock.getExposureOfAccounts();
			const previousBalanceOwner = await ethers.provider.getBalance(signers[0].address);
			await managerMock.checkForProfit();
			await managerMock.setPercentage(10);
			await managerMock.checkForProfit();
			const currentBalanceOwner = await ethers.provider.getBalance(signers[0].address);
			const newPrice = await managerMock.queryPrice();
			const currentExposure = await managerMock.getExposureOfAccounts();
			if (CONSOLE_LOG) {
				console.log(`Old Price: ${oldPrice}`);
				console.log(`New Price: ${newPrice}`);
				console.log(previousExposure);
				console.log(currentExposure);
				console.log(`Previous Balance: ${previousBalanceOwner}`);
				console.log(`Current Balance: ${currentBalanceOwner}`);
			}
			assert(previousExposure[0] > currentExposure[0] && previousExposure[1] < currentExposure[1]);
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
