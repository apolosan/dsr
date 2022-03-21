const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/bsc.json")));

const main = async () => {
  const [deployer] = await ethers.getSigners();
  const IManager = await artifacts.readArtifact("IManager");
  const manager = new ethers.Contract(networkData.Contracts.Managers[0], IManager.abi, ethers.provider);
  const tx = await manager.getExposureOfAccounts();
  console.log(tx);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
