const MANAGER_ADDRESS = "0x75bB2E2f3545657ee446C83761C60Aa75c427D68";
const main = async () => {
  const [deployer] = await ethers.getSigners();
  const IManager = await artifacts.readArtifact("IManager");
  const manager = new ethers.Contract(MANAGER_ADDRESS, IManager.abi, ethers.provider);
  const tx = await manager.connect(ethers.provider.getSigner(deployer.address)).checkForProfit();
  console.log(tx);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
