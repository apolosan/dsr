const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon_testnet.json")));

async function main() {

	const [deployer] = await ethers.getSigners();
	console.log(`Deploying contracts with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

	const Manager = await ethers.getContractFactory("BasicManager");
	const manager = await Manager.deploy(
		networkData.Contracts.ExchangeRouter,
		networkData.Contracts.Assets,
		networkData.Contracts.Assets[0]
	);

	console.log(`BasicManager address: ${manager.address}`);

	await manager.connect(ethers.provider.getSigner(deployer.address)).setDsrTokenAddress(networkData.Contracts.DeFiSystemReference);
	let dsrTokenAddress = await manager.getDsrTokenAddress();

	console.log(`BasicManager ${manager.address} set DSR Token address as: ${dsrTokenAddress}`);
	dsrTokenAddress = await manager.getDsrTokenAddress();
	console.log(`DSR Token set on parameters as: ${networkData.Contracts.DeFiSystemReference}`);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
