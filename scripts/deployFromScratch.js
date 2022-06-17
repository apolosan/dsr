// npx ganache --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL --miner.blockTime 0 --fork.requestsPerSecond 0 --wallet.mnemonic "pudding party palace jazz august scissors fog knock enjoy direct matrix spot"
// npx hardhat node --show-stack-traces --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon.json")));

const RSD_ETH_INITIAL_AMOUNT = "1";

async function main() {

	const [deployer] = await ethers.getSigners();
	console.log(`Deploying contracts with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  const ReferenceSystemDeFi = await ethers.getContractFactory("ReferenceSystemDeFi");
  const rsd = await ReferenceSystemDeFi.deploy("ReferenceSystemDeFi", "RSD", deployer.address);

  console.log(`ReferenceSystemDeFi address: ${rsd.address}`);

  const IUniswapV2Router02 = await artifacts.readArtifact("IUniswapV2Router02");
  const exchangeRouter = new ethers.Contract(networkData.Contracts.ExchangeRouter, IUniswapV2Router02.abi, ethers.provider);

  const ethAmount = ethers.utils.parseEther(RSD_ETH_INITIAL_AMOUNT);
  const rsdAmount = new ethers.utils.parseEther('500000');

  await rsd.connect(ethers.provider.getSigner(deployer.address)).approve(exchangeRouter.address, rsdAmount);
  await exchangeRouter.connect(ethers.provider.getSigner(deployer.address)).addLiquidityETH(
      rsd.address,
      rsdAmount,
      0, // slippage is unavoidable
      0, // slippage is unavoidable
      networkData.ZeroAddress,
      20000000000000,
      {value: ethAmount});

  let sdr;
  const SystemDeFiReference = await ethers.getContractFactory("SystemDeFiReference");
  if (rsd.address != '' && rsd.address != undefined) {
    sdr = await SystemDeFiReference.deploy(
      "System DeFi for Reference",
      "SDR",
      rsd.address,
      networkData.Contracts.ExchangeRouter,
      deployer.address, // networkData.Contracts.FarmContract,
      deployer.address, // networkData.Contracts.Marketing,
      [deployer.address]);

    console.log(`SystemDeFiReference address: ${sdr.address}`);
  }

  await sdr.initializeTokenContract();

	const Manager = await ethers.getContractFactory("BasicManager");
	const manager = await Manager.deploy(
		networkData.Contracts.ExchangeRouter,
		networkData.Contracts.Assets,
		networkData.Contracts.Assets[0]);

	console.log(`BasicManager address: ${manager.address}`);

  if (manager.address != '' && manager.address != undefined && sdr.address != '' && sdr.address != undefined) {
    const DeFiSystemReference = await ethers.getContractFactory("DeFiSystemReference");
    const dsr = await DeFiSystemReference.deploy("DeFi System for Reference", "DSR");

    const DsrHelper = await ethers.getContractFactory("DsrHelper");

    try {
      await dsr.connect(ethers.provider.getSigner(deployer.address)).addManager(manager.address);
      await manager.connect(ethers.provider.getSigner(deployer.address)).setDsrTokenAddress(dsr.address);
      await sdr.connect(ethers.provider.getSigner(deployer.address)).setFarmContractAddress(dsr.address);
      await sdr.connect(ethers.provider.getSigner(deployer.address)).setMarketingAddress(dsr.address);
      dsrHelper = await DsrHelper.deploy(
        dsr.address,
        networkData.Contracts.ExchangeRouter,
        rsd.address,
        sdr.address);

      devComission = await DsrHelper.deploy(
        networkData.ZeroAddress,
        networkData.ZeroAddress,
        networkData.ZeroAddress,
        networkData.ZeroAddress);

      if (dsrHelper.address != '' && dsrHelper.address != undefined && devComission.address != '' && devComission != undefined)
        await dsr.connect(ethers.provider.getSigner(signers[0].address)).initializeTokenContract(
          dsrHelper.address,
          devComission.address,
          networkData.Contracts.ExchangeRouter,
          rsd.address,
          sdr.address);

      console.log(`DeFiSystemReference address: ${dsr.address}`);
      console.log(`Dsr Helper #1 address: ${dsrHelper.address}`);
      console.log(`Comission Helper address: ${devComission.address}`);
    } catch {

    }

    let amount = new ethers.utils.parseEther('500000');
    const sdr_ = await SystemDeFiReference.attach(sdr.address);
    signer = await ethers.provider.getSigner(deployer.address);
    const sdr2 = await sdr_.connect(signer);
    const rsd2 = await rsd.connect(signer);

    await rsd2.transfer(sdr.address, amount);
    const tx = await sdr2.provideInitialLiquidity();
    console.log(tx);
  }
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
