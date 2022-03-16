const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon.json")));

const main = async () => {
  const [deployer] = await ethers.getSigners();
  const IManager = await artifacts.readArtifact("IManager");
  const manager = new ethers.Contract(networkData.Contracts.Managers[0], IManager.abi, ethers.provider);
  const tx = await manager.connect(ethers.provider.getSigner(deployer.address)).withdrawInvestment({gasLimit: 21000000});
  console.log(tx);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
