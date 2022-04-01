// npx ganache --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL --miner.blockTime 0 --fork.requestsPerSecond 0 --wallet.mnemonic "pudding party palace jazz august scissors fog knock enjoy direct matrix spot"
// npx hardhat node --show-stack-traces --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon.json")));

const GAS_LIMIT = 12000000;
const TIME_TO_WAIT = 10000;

async function main() {

	const [deployer] = await ethers.getSigners();
	console.log(`Deploying contracts with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

	const Manager = await ethers.getContractFactory("BasicManager");
	const manager = await Manager.deploy(
		networkData.Contracts.ExchangeRouter,
		networkData.Contracts.Assets,
		networkData.Contracts.Assets[0]);

	console.log(`BasicManager #1 address: ${manager.address}`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

  const DeFiSystemReference = await ethers.getContractFactory("DeFiSystemReference");
  const dsr = await DeFiSystemReference.deploy("DeFi System for Reference", "DSR", {gasLimit: GAS_LIMIT});

	console.log(`DeFiSystemReference address: ${dsr.address}`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	const SystemDeFiReference = await artifacts.readArtifact("SystemDeFiReference");
	const sdr = new ethers.Contract(networkData.Contracts.SystemDeFiReference, SystemDeFiReference.abi, ethers.provider);

	await manager.connect(ethers.provider.getSigner(deployer.address)).setDsrTokenAddress(dsr.address);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
	const managerDsrAddress = await manager.getDsrTokenAddress();
	await dsr.connect(ethers.provider.getSigner(deployer.address)).addManager(manager.address);

	console.log(`Manager has set DSR Token adddress as: ${managerDsrAddress}`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	const DsrHelper = await ethers.getContractFactory("DsrHelper");

  dsrHelper = await DsrHelper.deploy(
    dsr.address,
    networkData.Contracts.ExchangeRouter,
    networkData.Contracts.ReferenceSystemDeFi,
    networkData.Contracts.SystemDeFiReference);

	console.log(`Dsr Helper #1 address: ${dsrHelper.address}`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

  devComission = await DsrHelper.deploy(
    networkData.ZeroAddress,
    networkData.ZeroAddress,
    networkData.ZeroAddress,
    networkData.ZeroAddress);

	console.log(`Comission Helper address: ${devComission.address}`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	await dsr.connect(ethers.provider.getSigner(deployer.address)).setDsrHelperAddress(dsrHelper.address);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
	await dsr.connect(ethers.provider.getSigner(deployer.address)).setDeveloperComissionAddress(devComission.address);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
	await dsr.connect(ethers.provider.getSigner(deployer.address)).setRsdTokenAddress(networkData.Contracts.ReferenceSystemDeFi);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
	await dsr.connect(ethers.provider.getSigner(deployer.address)).setSdrTokenAddress(networkData.Contracts.SystemDeFiReference);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
	await dsr.connect(ethers.provider.getSigner(deployer.address)).setExchangeRouter(networkData.Contracts.ExchangeRouter);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	await dsr.connect(ethers.provider.getSigner(deployer.address)).initializePair(
		networkData.Contracts.Factory,
		dsr.address,
		networkData.Contracts.Assets[0],
		0
	);

	console.log(`Pair DSR/ETH Deployed/Initialized`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	await dsr.connect(ethers.provider.getSigner(deployer.address)).initializePair(
		networkData.Contracts.Factory,
		dsr.address,
		networkData.Contracts.ReferenceSystemDeFi,
		1
	);

	console.log(`Pair DSR/RSD Deployed/Initialized`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	await dsr.connect(ethers.provider.getSigner(deployer.address)).initializePair(
		networkData.Contracts.Factory,
		dsr.address,
		networkData.Contracts.SystemDeFiReference,
		2
	);

	console.log(`Pair DSR/SDR Deployed/Initialized`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	await dsr.connect(ethers.provider.getSigner(deployer.address)).initializePair(
		networkData.Contracts.Factory,
		networkData.Contracts.ReferenceSystemDeFi,
		networkData.Contracts.Assets[0],
		3
	);

	console.log(`Pair RSD/ETH Initialized`);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

	await sdr.connect(ethers.provider.getSigner(deployer.address)).setFarmContractAddress(dsr.address);
	await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
	await sdr.connect(ethers.provider.getSigner(deployer.address)).setMarketingAddress(dsr.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
