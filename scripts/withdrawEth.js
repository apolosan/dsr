const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/fantom.json")));

const main = async () => {
  const [deployer] = await ethers.getSigners();
  const signer = ethers.provider.getSigner(deployer.address);
  const DsrHelper = await artifacts.readArtifact("DsrHelper");
  const dev = new ethers.Contract(networkData.Contracts.DevComission, DsrHelper.abi, ethers.provider);
  const tx = await dev.connect(signer).withdrawEthSent(deployer.address, {gasLimit: 2100000});
  console.log(tx);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
