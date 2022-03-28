// npx ganache --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL --miner.blockTime 0 --fork.requestsPerSecond 0 --wallet.mnemonic "pudding party palace jazz august scissors fog knock enjoy direct matrix spot"
// npx hardhat node --show-stack-traces --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/bitgert.json")));

const GAS_LIMIT = 8000000;

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

  const DeFiSystemReference = await ethers.getContractFactory("DeFiSystemReference");
  const dsr = await DeFiSystemReference.deploy("DeFi System for Reference", "DSR", {gasLimit: GAS_LIMIT});

	console.log(`DeFiSystemReference address: ${dsr.address}`);

	const SystemDeFiReference = await artifacts.readArtifact("SystemDeFiReference");
	const sdr = new ethers.Contract(networkData.Contracts.SystemDeFiReference, SystemDeFiReference.abi, ethers.provider);

	await manager.connect(ethers.provider.getSigner(deployer.address)).setDsrTokenAddress(dsr.address);
	const managerDsrAddress = await manager.getDsrTokenAddress();
	await dsr.connect(ethers.provider.getSigner(deployer.address)).addManager(manager.address);

	console.log(`Manager has set DSR Token adddress as: ${managerDsrAddress}`);

	const DsrHelper = await ethers.getContractFactory("DsrHelper");

  dsrHelper = await DsrHelper.deploy(
    dsr.address,
    networkData.Contracts.ExchangeRouter,
    networkData.Contracts.ReferenceSystemDeFi,
    networkData.Contracts.SystemDeFiReference);

	console.log(`Dsr Helper #1 address: ${dsrHelper.address}`);

  devComission = await DsrHelper.deploy(
    networkData.ZeroAddress,
    networkData.ZeroAddress,
    networkData.ZeroAddress,
    networkData.ZeroAddress);

	console.log(`Comission Helper address: ${devComission.address}`);

  await dsr.connect(ethers.provider.getSigner(deployer.address)).initializeTokenContract(
    dsrHelper.address,
    devComission.address,
    networkData.Contracts.ExchangeRouter,
    networkData.Contracts.ReferenceSystemDeFi,
    networkData.Contracts.SystemDeFiReference, {gasLimit: GAS_LIMIT});

		await sdr.connect(ethers.provider.getSigner(deployer.address)).setFarmContractAddress(dsr.address);
		await sdr.connect(ethers.provider.getSigner(deployer.address)).setMarketingAddress(dsr.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
