const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/fantom.json")));

//const ASSETS = networkData.Contracts.Assets;
const ASSETS = [networkData.Contracts.Assets[0], networkData.Contracts.Assets[1]];
const GAS_LIMIT = 9000000;

async function main() {

	const [deployer] = await ethers.getSigners();
	console.log(`Deploying contracts with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

	const Manager = await ethers.getContractFactory("BasicManager");
	const manager = await Manager.deploy(
		networkData.Contracts.ExchangeRouter,
		ASSETS,
		networkData.Contracts.Assets[0],
		{gasLimit: GAS_LIMIT}
	);

	console.log(`BasicManager address: ${manager.address}`);

	await manager.connect(ethers.provider.getSigner(deployer.address)).setDsrTokenAddress(networkData.Contracts.DeFiSystemReference);
	await new Promise(resolve => setTimeout(resolve, 10000));
	let dsrTokenAddress = await manager.getDsrTokenAddress();

	const DeFiSystemReference = await artifacts.readArtifact("DeFiSystemReference");
	const dsr = new ethers.Contract(networkData.Contracts.DeFiSystemReference, DeFiSystemReference.abi, ethers.provider);
	await dsr.connect(ethers.provider.getSigner(deployer.address)).addManager(manager.address);

	console.log(`DSR Token set parameters as: ${networkData.Contracts.DeFiSystemReference}`);
	console.log(`BasicManager ${manager.address} set DSR Token address as: ${dsrTokenAddress}`);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
