const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon.json")));

async function main() {

	const [deployer] = await ethers.getSigners();
	console.log(`Deploying contracts with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

	const Manager = await ethers.getContractFactory("Manager");
	const manager = await Manager.deploy(
		networkData.Contracts.ExchangeRouter,
		networkData.Contracts.Comptroller,
		networkData.Contracts.PriceFeed,
		networkData.Contracts.Assets,
		networkData.Contracts.CAssets,
		networkData.Contracts.Assets[0]
	);

	console.log(`First Manager address: ${manager.address}`);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
