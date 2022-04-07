// npx ganache --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL --miner.blockTime 0 --fork.requestsPerSecond 0 --wallet.mnemonic "pudding party palace jazz august scissors fog knock enjoy direct matrix spot"
// npx hardhat node --show-stack-traces --fork https://polygon-mainnet.g.alchemy.com/v2/Idi3lnZ-iFFt7s0ruMkbrxXfkexrsOnL
const fs = require('fs');
const path = require("path");
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/polygon.json")));

async function main() {

	const [deployer] = await ethers.getSigners();
	console.log(`Initializing DSR Token with the acount: ${deployer.address}`);
	console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  const DeFiSystemReference = await artifacts.readArtifact("DeFiSystemReference");
  const dsr = new ethers.Contract(networkData.Contracts.DeFiSystemReference, DeFiSystemReference.abi, ethers.provider);

	console.log(`DeFiSystemReference address: ${dsr.address}`);

	let tx;
  try {
		tx = await dsr.connect(ethers.provider.getSigner(deployer.address)).initializeTokenContract(
		  networkData.Contracts.DsrHelper,
		  networkData.Contracts.DevComission,
		  networkData.Contracts.ExchangeRouter,
		  networkData.Contracts.ReferenceSystemDeFi,
		  networkData.Contracts.SystemDeFiReference);
			console.log(`DSR Contract Initialized Sucessfully!`);
			console.log(`------------------------------------------------`);
			console.log(tx);
	} catch {
		console.log(`Unable to initialize DSR Contract:`);
		console.log(`------------------------------------------------`);
		console.log(tx);
	}
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
