const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/fantom.json")));

async function main() {

  const [deployer] = await ethers.getSigners();
  const BasicManager = await artifacts.readArtifact("BasicManager");
  const manager = new ethers.Contract(networkData.Contracts.Managers[0], BasicManager.abi, ethers.provider);
  await manager.getRates();
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
