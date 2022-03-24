// npx ganache --fork https://bsc-dataseed3.binance.org --miner.blockTime 0 --fork.requestsPerSecond 0 --wallet.mnemonic "pudding party palace jazz august scissors fog knock enjoy direct matrix spot"
// npx hardhat node --show-stack-traces --fork https://bsc-dataseed3.binance.org
const { expect, assert } = require('chai');
const BigNumber = require("bignumber.js");
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/bsc.json")));

const CONSOLE_LOG = true;
const ALREADY_DEPLOYED_RSD = false;
const ALREADY_DEPLOYED_MANAGER = false;
const ETH = "10.0";

describe("DeFiSystemReference", async () => {
  let dsr, dsrHelper, signers, devComission, RSD, rsd, RSD_ADDRESS;

  before(async () => {
    signers = await ethers.getSigners();
    const DSR = await ethers.getContractFactory("DeFiSystemReference");

    if (ALREADY_DEPLOYED_RSD) {
      RSD = await artifacts.readArtifact("IReferenceSystemDeFi");
      rsd = new ethers.Contract(networkData.Contracts.ReferenceSystemDeFi, RSD.abi, ethers.provider);
      RSD_ADDRESS = networkData.Contracts.ReferenceSystemDeFi;
    } else {
      RSD = await ethers.getContractFactory("ReferenceSystemDeFiMOCK");
      rsd = await RSD.deploy("Reference System for DeFi", "RSD", signers[5].address);
      RSD_ADDRESS = rsd.address;
    }

    const DsrHelper = await ethers.getContractFactory("DsrHelper");
    dsr = await DSR.deploy("DeFi System For Reference", "DSR");
    dsrHelper = await DsrHelper.deploy(dsr.address, networkData.Contracts.ExchangeRouter, RSD_ADDRESS, networkData.Contracts.SystemDeFiReference);
    devComission = await DsrHelper.deploy(networkData.ZeroAddress, networkData.ZeroAddress, networkData.ZeroAddress, networkData.ZeroAddress);
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).initializeTokenContract(
      dsrHelper.address,
      devComission.address,
      networkData.Contracts.ExchangeRouter,
      RSD_ADDRESS,
      networkData.Contracts.SystemDeFiReference,
      {gasLimit: 12000000});

    if (CONSOLE_LOG) {
      console.log(`RSD Address: ${RSD_ADDRESS}`);
    }
  });

  it('should deploy and initialize DSR token correctly', async () => {
    const dsr_address = await dsr.address;
    const dev_address = await dsr.developerComissionAddress();
    if (CONSOLE_LOG) {
      console.log(`DSR Address: ${dsr.address}`);
      console.log(`DSR Helper Address: ${dsrHelper.address}`);
      console.log(`Dev Address for Comission: ${dev_address}`);
    }
    assert(dsr_address != undefined && dsr_address != networkData.ZeroAddress && dev_address != networkData.ZeroAddress);
  });

  it('should set DSR address for the first deployed manager', async () => {
    const Manager = await ethers.getContractFactory("BasicManager");
    const manager = await Manager.deploy(
      networkData.Contracts.ExchangeRouter,
      networkData.Contracts.Assets,
      networkData.Contracts.Assets[0]);
    await manager.setDsrTokenAddress(dsr.address);
    const dsr_address = await manager.getDsrTokenAddress();
    if (CONSOLE_LOG) {
      console.log(`DSR Address Set into the Manager: ${dsr_address}`);
    }
    assert(dsr_address != networkData.ZeroAddress && dsr_address != undefined);
  });

  it(`must obtain a random wallet on demand`, async () => {
    const randomWalletAddress = await dsr.obtainRandomWalletAddress(Math.round(Math.random() * 100000000000));
    if (CONSOLE_LOG) {
      console.log(`Random Wallet: ${randomWalletAddress}`);
    }
    assert(randomWalletAddress != undefined && randomWalletAddress != '' && randomWalletAddress != networkData.ZeroAddress);
  });

  it(`can call the PoBet function of RSD token contract and receive the prize (FORCED)`, async () => {
    const dsrRsdPair = await dsr.dsrRsdPair();
    const previousBalanceDSR = await dsr.balanceOf(dsrRsdPair);
    const previousBalanceRSD = await rsd.balanceOf(dsrRsdPair);
    const tx = await dsr.tryPoBet(4);
    const currentBalanceDSR = await dsr.balanceOf(dsrRsdPair);
    const currentBalanceRSD = await rsd.balanceOf(dsrRsdPair);
    if (CONSOLE_LOG) {
      console.log(`DSR/RSD LP Pair Address: ${dsrRsdPair}`);
      console.log(`DSR/RSD LP Previous Balance in DSR: ${previousBalanceDSR}`);
      console.log(`DSR/RSD LP Previous Balance in RSD: ${previousBalanceRSD}`);
      console.log(`DSR/RSD LP Current Balance in DSR: ${currentBalanceDSR}`);
      console.log(`DSR/RSD LP Current Balance in RSD: ${currentBalanceRSD}`);
    }
    assert((tx.hash != undefined || tx.hash != '') && previousBalanceDSR < currentBalanceDSR && previousBalanceRSD < currentBalanceRSD);
  });

  it(`should invest resources automatically, right after it receives some ETH amount, and mint DSR tokens`, async () => {
    const Manager = await ethers.getContractFactory("BasicManager");
    const manager = await Manager.deploy(
      networkData.Contracts.ExchangeRouter,
      networkData.Contracts.Assets,
      networkData.Contracts.Assets[0]);
    await manager.setDsrTokenAddress(dsr.address);
    await dsr.addManager(manager.address);
    const isManagerAdded = await dsr.isManagerAdded(manager.address);
    const firstTotalSupply = await dsr.totalSupply();
    const tx = await signers[0].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const secondTotalSupply = await dsr.totalSupply();
    const balanceOfDSR = await dsr.balanceOf(signers[0].address);
    const exposure = await manager.getExposureOfAccounts();
    if (CONSOLE_LOG) {
      console.log(`Total Supply: ${firstTotalSupply} | ${secondTotalSupply}`);
      console.log(`Is manager added? ${isManagerAdded}`);
      console.log(`Balance of DSR: ${balanceOfDSR}`);
      console.log(exposure);
    }
    assert(balanceOfDSR >= 0 && exposure[0] > 0 && exposure[1] > 0);
  }).timeout(100000);

  it(`should allow to mint DSR tokens and transfer to another wallet correctly`, async () => {
    const tx = await signers[1].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const previousBalanceOfDSR = await dsr.balanceOf(signers[1].address);
    await dsr.connect(ethers.provider.getSigner(signers[1].address)).transfer(signers[2].address, previousBalanceOfDSR);
    const currentBalanceOfDSR = await dsr.balanceOf(signers[1].address);
    if (CONSOLE_LOG) {
      console.log(`Previous Balance ${signers[1].address}: ${previousBalanceOfDSR}`);
      console.log(`Current Balance ${signers[1].address}: ${currentBalanceOfDSR}`);
    }
    assert(currentBalanceOfDSR < previousBalanceOfDSR && currentBalanceOfDSR == 0);
  }).timeout(100000);

  it(`should add automatic liquidity for DSR/ETH pair after performing investment`, async () => {
    const dsrEthPair = await dsr.dsrEthPair();
    const IERC20 = await artifacts.readArtifact("IERC20");
    const wEth = new ethers.Contract(networkData.Contracts.Assets[0], IERC20.abi, ethers.provider);
    const previousBalanceDSR = await dsr.balanceOf(dsrEthPair);
    const previousBalanceETH = await wEth.balanceOf(dsrEthPair);
    const tx = await signers[3].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const currentBalanceDSR = await dsr.balanceOf(dsrEthPair);
    const currentBalanceETH = await wEth.balanceOf(dsrEthPair);
    if (CONSOLE_LOG) {
      console.log(`DSR/ETH LP Previous Balance DSR: ${previousBalanceDSR}`);
      console.log(`DSR/ETH LP Previous Balance ETH: ${previousBalanceETH}`);
      console.log(`DSR/ETH LP Current Balance DSR: ${currentBalanceDSR}`);
      console.log(`DSR/ETH LP Current Balance ETH: ${currentBalanceETH}`);
    }
    assert(currentBalanceDSR > previousBalanceDSR && currentBalanceETH > previousBalanceETH);
  });

  it(`should charge and withdraw comission for developer team correctly`, async () => {
    const previousBalance = await ethers.provider.getBalance(signers[0].address);
    const previousBalanceDev = await ethers.provider.getBalance(devComission.address);
    const tx = await signers[3].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const currentBalanceDev = await ethers.provider.getBalance(devComission.address);
    await devComission.connect(ethers.provider.getSigner(signers[0].address)).withdrawEthSent(signers[0].address);
    const currentBalance = await ethers.provider.getBalance(signers[0].address);
    const balanceAfterWithdraw = await ethers.provider.getBalance(devComission.address);
    if (CONSOLE_LOG) {
      console.log(`Balance Before Comission         : ${previousBalance}`);
      console.log(`Balance After Comission          : ${currentBalance}`);
      console.log(`Balance Contract Before Comission: ${previousBalanceDev}`);
      console.log(`Balance Contract After Comission : ${currentBalanceDev}`);
      console.log(`Balance Contract After Withdraw  : ${balanceAfterWithdraw}`);
    }
    assert(currentBalance > previousBalance);
  });

  it(`should not allow to another person than owner to withdrawn comission`, async () => {
    const tx = await signers[3].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    let result = false;
    try {
      await devComission.connect(ethers.provider.getSigner(signers[1].address)).withdrawEthSent(signers[0].address);
      assert(false);
    } catch {
      assert(true);
    }
  });

  it(`should reward SDR tokens for investors as reward in the Infinite Farm System`, async () => {
    const SDR = await ethers.getContractFactory("SystemDeFiReference");
    const sdr = await SDR.deploy(
      "System DeFi For Reference",
      "SDR",
      networkData.Contracts.ExchangeRouter,
      networkData.Contracts.ReferenceSystemDeFi,
      dsr.address,
      dsr.address,
      [dsr.address]);

    await dsr.connect(ethers.provider.getSigner(signers[0].address)).initializeTokenContract(
      dsrHelper.address,
      devComission.address,
      networkData.Contracts.ExchangeRouter,
      RSD_ADDRESS,
      sdr.address);
    const balanceSDR = await sdr.balanceOf(dsr.address);
    const balanceRewardBefore = await sdr.balanceOf(signers[1].address);
    const tx = await signers[1].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const balanceDSR = await dsr.balanceOf(signers[1].address);
    const balanceRewardAfter = await sdr.balanceOf(signers[1].address);
    if (CONSOLE_LOG) {
      console.log(`Balance SDR [${dsr.address}]: ${balanceSDR}`);
      console.log(`Balance DSR [${signers[1].address}]: ${balanceDSR}`);
      console.log(`Balance Reward Before [${signers[1].address}]: ${balanceRewardBefore}`);
      console.log(`Balance Reward After  [${signers[1].address}]: ${balanceRewardAfter}`);
    }
    assert(balanceRewardAfter > 0 && balanceRewardAfter > balanceRewardBefore);
  });

  it(`should mint more tokens when receiveing profit from manager(s) and sharing them among all investors as dividends`, async () => {
    const Manager = await ethers.getContractFactory("BasicManagerMOCK");
    const managerMock = await Manager.deploy(
      networkData.Contracts.ExchangeRouter,
      networkData.Contracts.Assets,
      networkData.Contracts.Assets[0]);
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).addManager(managerMock.address);
    await managerMock.connect(ethers.provider.getSigner(signers[0].address)).setDsrTokenAddress(dsr.address);

    await signers[2].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const b01 = await dsr.balanceOf(signers[2].address);
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).transfer(signers[3].address, b01, {gasLimit: 12000000});
    const balanceBeforeDividend = await dsr.balanceOf(signers[3].address);

    await signers[1].sendTransaction({to: managerMock.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const totalSupplyBefore = await dsr.totalSupply();
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).checkForProfit({gasLimit: 12000000});
    await managerMock.setPercentage(10);
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).checkForProfit({gasLimit: 12000000});
    const totalSupplyAfter = await dsr.totalSupply();

    const balanceAfterDividend = await dsr.balanceOf(signers[3].address);
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).removeManager(managerMock.address);

    if (CONSOLE_LOG) {
      console.log(`Total Supply Before      : ${totalSupplyBefore}`);
      console.log(`Total Supply After       : ${totalSupplyAfter}`);
      console.log(`Balance Before Dividend  : ${balanceBeforeDividend}`);
      console.log(`Balance After Dividend   : ${balanceAfterDividend}`);
    }

    assert(totalSupplyAfter > totalSupplyBefore && balanceAfterDividend > balanceBeforeDividend);
  }).timeout(100000);

  it(`should allow an account to spend its received dividend correctly`, async () => {
    const Manager = await ethers.getContractFactory("BasicManagerMOCK");
    const managerMock = await Manager.deploy(
      networkData.Contracts.ExchangeRouter,
      networkData.Contracts.Assets,
      networkData.Contracts.Assets[0]);
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).addManager(managerMock.address);
    await managerMock.connect(ethers.provider.getSigner(signers[0].address)).setDsrTokenAddress(dsr.address);

    await signers[2].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const b01 = await dsr.balanceOf(signers[2].address);
    await signers[1].sendTransaction({to: managerMock.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).checkForProfit({gasLimit: 12000000});
    await managerMock.setPercentage(10);
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).checkForProfit({gasLimit: 12000000});
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).removeManager(managerMock.address);
    const b02 = await dsr.balanceOf(signers[2].address);

    const balanceDifference = b02.sub(b01);

    const balanceToBefore = await dsr.balanceOf(signers[4].address);
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).transfer(signers[4].address, balanceDifference, {gasLimit: 12000000});
    const balanceToAfter = await dsr.balanceOf(signers[4].address);

    const b03 = await dsr.balanceOf(signers[2].address);

    const balanceTo2Before = await dsr.balanceOf(signers[5].address);
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).transfer(signers[5].address, b03, {gasLimit: 12000000});
    const balanceTo2After = await dsr.balanceOf(signers[5].address);

    const b04 = await dsr.balanceOf(signers[2].address);

    if (CONSOLE_LOG) {
      console.log(`Balance Difference                   : ${balanceDifference}`);
      console.log(`Balance FROM After MINT              : ${b01}`);
      console.log(`Balance FROM After PROFIT            : ${b02}`);
      console.log(`Balance FROM After TRANSFER #1       : ${b03}`);
      console.log(`Balance FROM After TRANSFER #2       : ${b04}`);
      console.log(`Balance TO Before TRANSFER           : ${balanceToBefore}`);
      console.log(`Balance TO After TRANSFER            : ${balanceToAfter}`);
      console.log(`Balance TO2 Before TRANSFER          : ${balanceTo2Before}`);
      console.log(`Balance TO2 After TRANSFER           : ${balanceTo2After}`);
    }
  }).timeout(100000);

  it(`should receive profit and provide automatic liquidity for DSR/ETH + DSR/RSD + DSR/SDR pairs`, async () => {
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).initializeTokenContract(
      dsrHelper.address,
      devComission.address,
      networkData.Contracts.ExchangeRouter,
      RSD_ADDRESS,
      networkData.Contracts.SystemDeFiReference);

    const IERC20 = await artifacts.readArtifact("IERC20");
    const wEth = new ethers.Contract(networkData.Contracts.Assets[0], IERC20.abi, ethers.provider);
    const sdr = new ethers.Contract(networkData.Contracts.SystemDeFiReference, IERC20.abi, ethers.provider);

    const Manager = await ethers.getContractFactory("BasicManagerMOCK");
    const managerMock = await Manager.deploy(
      networkData.Contracts.ExchangeRouter,
      networkData.Contracts.Assets,
      networkData.Contracts.Assets[0]);
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).addManager(managerMock.address);
    await managerMock.connect(ethers.provider.getSigner(signers[0].address)).setDsrTokenAddress(dsr.address);
    await signers[1].sendTransaction({to: managerMock.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    await managerMock.checkForProfit();
    await managerMock.setPercentage(10);

    const dsrEthPair = await dsr.dsrEthPair();
    const dsrRsdPair = await dsr.dsrRsdPair();
    const dsrSdrPair = await dsr.dsrSdrPair();
    const sdrRsdPair = await dsr.sdrRsdPair();

    const balanceDsrEthPair = [await dsr.balanceOf(dsrEthPair), await wEth.balanceOf(dsrEthPair)];
    const balanceDsrRsdPair = [await dsr.balanceOf(dsrRsdPair), await rsd.balanceOf(dsrRsdPair)];
    const balanceDsrSdrPair = [await dsr.balanceOf(dsrSdrPair), await sdr.balanceOf(dsrSdrPair)];

    await dsr.connect(ethers.provider.getSigner(signers[2].address)).checkForProfit({gasLimit: 12000000});

    const balanceDsrEthPairAfter = [await dsr.balanceOf(dsrEthPair), await wEth.balanceOf(dsrEthPair)];
    const balanceDsrRsdPairAfter = [await dsr.balanceOf(dsrRsdPair), await rsd.balanceOf(dsrRsdPair)];
    const balanceDsrSdrPairAfter = [await dsr.balanceOf(dsrSdrPair), await sdr.balanceOf(dsrSdrPair)];

    if (CONSOLE_LOG) {
      console.log(`DSR/ETH LP      : ${balanceDsrEthPair}`);
      console.log(`DSR/RSD LP      : ${balanceDsrRsdPair}`);
      console.log(`DSR/SDR LP      : ${balanceDsrSdrPair}`);
      console.log(`DSR/ETH LP After: ${balanceDsrEthPairAfter}`);
      console.log(`DSR/RSD LP After: ${balanceDsrRsdPairAfter}`);
      console.log(`DSR/SDR LP After: ${balanceDsrSdrPairAfter}`);
    }

    assert(balanceDsrEthPair[0] < balanceDsrEthPairAfter[0] && balanceDsrRsdPair[0] < balanceDsrRsdPairAfter[0]);
  }).timeout(100000);

  it(`should burn tokens correctly even after profit received`, async () => {
    const Manager = await ethers.getContractFactory("BasicManagerMOCK");
    const managerMock = await Manager.deploy(
      networkData.Contracts.ExchangeRouter,
      networkData.Contracts.Assets,
      networkData.Contracts.Assets[0]);
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).addManager(managerMock.address);
    await managerMock.connect(ethers.provider.getSigner(signers[0].address)).setDsrTokenAddress(dsr.address);

    await signers[2].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    const b01 = await dsr.balanceOf(signers[2].address);
    await signers[1].sendTransaction({to: managerMock.address, value: ethers.utils.parseEther(ETH), gasLimit: 12000000});
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).checkForProfit({gasLimit: 12000000});
    await managerMock.setPercentage(10);
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).checkForProfit({gasLimit: 12000000});
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).removeManager(managerMock.address);
    const b02 = await dsr.balanceOf(signers[2].address);
    await dsr.connect(ethers.provider.getSigner(signers[2].address)).burn(b02, {gasLimit: 12000000});
    const b03 = await dsr.balanceOf(signers[2].address);

    if (CONSOLE_LOG) {
      console.log(`MINTED BALANCE: ${b01}`);
      console.log(`PROFIT BALANCE: ${b02}`);
      console.log(`BURNED BALANCE: ${b03}`);
    }

    assert(b01 > 0 && b02 > b01 && b03 == 0);
  }).timeout(100000);
});
