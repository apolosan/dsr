const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon_testnet.json")));

async function main() {

  const [deployer] = await ethers.getSigners();
	console.log(`Adding Manager to DSR Token with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  const DeFiSystemReference = await artifacts.readArtifact("DeFiSystemReference");
  const dsr = new ethers.Contract(networkData.Contracts.DeFiSystemReference, DeFiSystemReference.abi, ethers.provider);

  const BasicManager = await artifacts.readArtifact("BasicManager");
  const manager = new ethers.Contract(networkData.Contracts.Managers[0], BasicManager.abi, ethers.provider);

  let tx;
  let tx2;
  try {
    tx = await dsr.connect(ethers.provider.getSigner(deployer.address)).addManager(manager.address);
    tx2 = await manager.connect(ethers.provider.getSigner(deployer.address)).setDsrTokenAddress(dsr.address);
    console.log(`Manager ${manager.address} added to DSR Token at ${dsr.address} sucessfully!`);
    console.log(`Transaction #1 Hash: ${tx.hash} -- addManager(${manager.address})`);
    console.log(`Transaction #2 Hash: ${tx2.hash} -- setDsrTokenAddress(${dsr.address})`);
  } catch {
    console.log(`Unable to add manager ${manager.address}`);
    console.log(`------------------------------------------------`);
    console.log(tx);
    console.log(tx2);
  }
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
