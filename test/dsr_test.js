// npx ganache --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL --miner.blockTime 0 --fork.requestsPerSecond 0 --wallet.mnemonic "pudding party palace jazz august scissors fog knock enjoy direct matrix spot"
// npx hardhat node --show-stack-traces --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL
const { expect, assert } = require('chai');
const BigNumber = require("bignumber.js");

const UNISWAP_ROUTER_ADDRESS = "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff";
const RSD_ADDRESS = "0x61ed1c66239d29cc93c8597c6167159e8f69a823";
const SDR_ADDRESS = "0x141F4c6cD6a8a8517a92B9fB840d89d6333783FA"; // Polygon
const MANAGERS_ADDRESSES = ["0x75bB2E2f3545657ee446C83761C60Aa75c427D68"];
const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';
const CONSOLE_LOG = true;
const ETH = "1.0";

// For Test Manager
const COMPTROLLER_ADDRESS = "0xF20fcd005AFDd3AD48C85d0222210fe168DDd10c";
const PRICE_FEED_ADDRESS = "0xD375E22f5D98cc808454D8F67b78dC20c3219959";
const ASSETS = ["0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270", "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"]; // ETH & USDC
const C_ASSETS = ["0xCa0F37f73174a28a64552D426590d3eD601ecCa1", "0xbEbAD52f3A50806b25911051BabDe6615C8e21ef"];

describe("DeFiSystemReference", async () => {
  let dsr, dsrHelper, signers, devComission, rsd;

  before(async () => {
    signers = await ethers.getSigners();
    const DSR = await ethers.getContractFactory("DeFiSystemReference");
    const RSD = await ethers.getContractFactory("ReferenceSystemDeFi");
    const DsrHelper = await ethers.getContractFactory("DsrHelper");
    dsr = await DSR.deploy("DeFi System For Reference", "DSR");
    rsd = await RSD.deploy("Reference System for DeFi", "RSD", signers[0].address);
    dsrHelper = await DsrHelper.deploy(dsr.address, UNISWAP_ROUTER_ADDRESS, rsd.address, SDR_ADDRESS);
    devComission = await DsrHelper.deploy(ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS, ZERO_ADDRESS);
    await dsr.connect(ethers.provider.getSigner(signers[0].address)).initializeTokenContract(dsrHelper.address, devComission.address, UNISWAP_ROUTER_ADDRESS, rsd.address, SDR_ADDRESS);
  });

  it('should deploy and initialize DSR token correctly', async () => {
    const dsr_address = await dsr.address;
    const dev_address = await dsr.developerComissionAddress();
    if (CONSOLE_LOG) {
      console.log(`DSR Address: ${dsr.address}`);
      console.log(`Dev Address for Comission: ${dev_address}`);
    }
    assert(dsr_address != undefined && dsr_address != ZERO_ADDRESS && dev_address != ZERO_ADDRESS);
  });

  it('should set DSR address for the first deployed manager', async () => {
    const Manager = await ethers.getContractFactory("Manager");
    const manager = await Manager.deploy(UNISWAP_ROUTER_ADDRESS, COMPTROLLER_ADDRESS, PRICE_FEED_ADDRESS, ASSETS, C_ASSETS, ASSETS[0]);
    // const IManager = await artifacts.readArtifact("IManager");
    // const IOwnable = await artifacts.readArtifact("IOwnable");
    // const manager = new ethers.Contract(MANAGERS_ADDRESSES[0], IManager.abi, ethers.provider);
    // const ownable = new ethers.Contract(MANAGERS_ADDRESSES[0], IOwnable.abi, ethers.provider);
    await manager.setDsrTokenAddresss(dsr.address);
    const dsr_address = await manager.getDsrTokenAddress();
    if (CONSOLE_LOG) {
      // const manager_owner = await ownable.owner();
      // console.log(`Manager Owner: ${manager_owner}`);
      // console.log(`Signer Address: ${signers[0].address}`);
      console.log(dsr_address);
    }
    assert(dsr_address != ZERO_ADDRESS && dsr_address != undefined);
  });

  it(`can try PoBet function of RSD token contract`, async () => {
    const tx = await dsr.tryPoBet(4);
    if (CONSOLE_LOG)
      console.log(tx.hash);
    assert(tx.hash != undefined || tx.hash != '');
  });

  it(`should invest resources automatically, right after it receives some ETH amount, and mint DSR tokens`, async () => {
    const Manager = await ethers.getContractFactory("Manager");
    const manager = await Manager.deploy(UNISWAP_ROUTER_ADDRESS, COMPTROLLER_ADDRESS, PRICE_FEED_ADDRESS, ASSETS, C_ASSETS, ASSETS[0]);
    await manager.setDsrTokenAddresss(dsr.address);
    await dsr.addManager(manager.address);
    const isManagerAdded = await dsr.isManagerAdded(manager.address);
    const account01 = await manager.getAccount(0);
    const account02 = await manager.getAccount(1);
    console.log("STEP #1");
    const tx = await signers[0].sendTransaction({to: dsr.address, value: ethers.utils.parseEther(ETH)});
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
    const balanceOfDSR = await dsr.balanceOf(signers[0].address);
    if (CONSOLE_LOG) {
      console.log(`Is manager added? ${isManagerAdded}`);
      console.log(`Balance of DSR: ${balanceOfDSR}`);
      const exposure = await manager.getExposureOfAccounts();
      console.log(exposure);
      console.log(`Balance of Account #1 - ${account01}: ${balance_cETH}`);
      console.log(`Balance of Account #2 - ${account02}: ${balance_cUSD}`);
      console.log(`Borrow Balance of Account #1 - ${account01}: ${borrowedBalanceAccount01}`);
      console.log(`Borrow Balance of Account #2 - ${account02}: ${borrowedBalanceAccount02}`);
    }
    assert(balance_cETH != 0 && balance_cUSD != 0 && borrowedBalanceAccount01 != 0 && borrowedBalanceAccount02 != 0);
  });
});
