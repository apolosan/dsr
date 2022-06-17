const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/fantom.json")));

async function main() {

  const [deployer] = await ethers.getSigners();
	console.log(`Pause investments for DSR Token with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  const DeFiSystemReference = await artifacts.readArtifact("DeFiSystemReference");
  const dsr = new ethers.Contract(networkData.Contracts.DeFiSystemReference, DeFiSystemReference.abi, ethers.provider);
  await dsr.connect(ethers.provider.getSigner(deployer.address)).pauseInvestments();
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
