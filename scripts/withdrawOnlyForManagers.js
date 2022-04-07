const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon.json")));
const TIME_TO_WAIT = 10000;

const main = async () => {
  const [deployer] = await ethers.getSigners();
  const signer = ethers.provider.getSigner(deployer.address);
  const DSR = await artifacts.readArtifact("DeFiSystemReference");
  const dsr = new ethers.Contract(networkData.Contracts.DeFiSystemReference, DSR.abi, ethers.provider);
  const IManager = await artifacts.readArtifact("BasicManager");
  const manager = new ethers.Contract(networkData.Contracts.Managers[1], IManager.abi, ethers.provider);
  const tx = await manager.connect(signer).withdrawOnlyForManagers({gasLimit: 8000000});
  console.log(tx);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
