const { expect, assert } = require('chai');
const BigNumber = require("bignumber.js");
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/bsc.json")));

const CONSOLE_LOG = true;
const ETH = "10";

describe("BasicManager", async () => {
		let signers, manager;

		before(async () => {
				signers = await ethers.getSigners();
				Manager = await ethers.getContractFactory("BasicManager");
				manager = await Manager.deploy(
					networkData.Contracts.ExchangeRouter,
					networkData.Contracts.Assets,
					networkData.Contracts.Assets[0]);
		});

		it("should deploy manager contract correctly", async () => {
      if (CONSOLE_LOG)
        console.log(`BasicManager Address: ${manager.address}`);
			assert(manager.address != undefined && manager.address != '');
		});

		it("should query price | rate from contract correctly", async () => {
			const price = await manager.queryPrice();
			if (CONSOLE_LOG) {
				console.log(`Price or Rate: ${price}`);
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
				console.log(`Pair Address: ${pairAddress}`);
			assert(pairAddress != '' || pairAddress != networkData.ZeroAddress);
		});

		it(`should update the DSR token address correctly`, async () => {
			const oldDsrAddress = await manager.getDsrTokenAddress();
			const dsrAddress = "0xD99D1c33F9fC3444f8101754aBC46c52416550D1";
			await manager.setDsrTokenAddress(dsrAddress);
			const newDsrAddress = await manager.getDsrTokenAddress();
			if (CONSOLE_LOG)
				console.log(`DSR Token Address: ${newDsrAddress}`);
      await manager.setDsrTokenAddress(networkData.ZeroAddress);
			assert(oldDsrAddress != newDsrAddress);
		});

		it(`must buy two different assets for investment, right after it receives some ETH amount`, async () => {
      const tx = await signers[0].sendTransaction({to: manager.address, value: ethers.utils.parseEther(ETH)});
			const exposure = await manager.getExposureOfAccounts();
			if (CONSOLE_LOG) {
				console.log(`Exposure Asset #1: ${exposure[0]}`);
				console.log(`Exposure Asset #2: ${exposure[1]}`);
			}
			assert(exposure[0] > 0 && exposure[1] > 0 && exposure[0] != undefined && exposure[1] != undefined);
		});

		it(`should adjust the exposure according to the price movement`, async () => {
			const BasicManagerMOCK = await ethers.getContractFactory("BasicManagerMOCK");
      const managerMock = await BasicManagerMOCK.deploy(
        networkData.Contracts.ExchangeRouter,
        networkData.Contracts.Assets,
        networkData.Contracts.Assets[0]);

			await signers[0].sendTransaction({to: managerMock.address, value: ethers.utils.parseEther(ETH)});
			const oldPrice = await managerMock.queryPrice();
			const previousExposure = await managerMock.getExposureOfAccounts();
      const previousBalances = await managerMock.getBalances();
			const previousBalanceOwner = await ethers.provider.getBalance(signers[0].address);

      const previousBalanceAccount01 = await managerMock.getBalanceOfAsset(networkData.Contracts.Assets[0]);
      const previousBalanceAccount02 = await managerMock.getBalanceOfAsset(networkData.Contracts.Assets[1]);
      const previousCBalanceAccount01 = await managerMock.getConvertedBalanceOfAsset(networkData.Contracts.Assets[0]);
      const previousCBalanceAccount02 = await managerMock.getConvertedBalanceOfAsset(networkData.Contracts.Assets[1]);

			await managerMock.checkForProfit();
			await managerMock.setPercentage(10);
			await managerMock.checkForProfit();

      const currentBalanceAccount01 = await managerMock.getBalanceOfAsset(networkData.Contracts.Assets[0]);
      const currentBalanceAccount02 = await managerMock.getBalanceOfAsset(networkData.Contracts.Assets[1]);
      const currentCBalanceAccount01 = await managerMock.getConvertedBalanceOfAsset(networkData.Contracts.Assets[0]);
      const currentCBalanceAccount02 = await managerMock.getConvertedBalanceOfAsset(networkData.Contracts.Assets[1]);

			const currentBalanceOwner = await ethers.provider.getBalance(signers[0].address);
			const newPrice = await managerMock.queryPrice();
			const currentExposure = await managerMock.getExposureOfAccounts();
      const currentBalances = await managerMock.getBalances();
			if (CONSOLE_LOG) {
        console.log(`Previous Balance Asset #1: ${previousBalanceAccount01} | ${previousCBalanceAccount01}`);
        console.log(`Previous Balance Asset #2: ${previousBalanceAccount02} | ${previousCBalanceAccount02}`);
        console.log(`Current Balance Asset #1: ${currentBalanceAccount01} | ${currentCBalanceAccount01}`);
        console.log(`Current Balance Asset #2: ${currentBalanceAccount02} | ${currentCBalanceAccount02}`);
        console.log(previousBalances);
        console.log(currentBalances);
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
