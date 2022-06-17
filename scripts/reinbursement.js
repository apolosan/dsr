const fs = require('fs');
const { ethers } = require('hardhat');
const path = require("path");
const jsonFile = fs.readFileSync(path.resolve(__dirname, "../../dsrHolders01_heco.json")).toString().trim();
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/heco.json")));
const jsonParsed = JSON.parse(jsonFile);
const FACTOR = 10**18;
const GAS_LIMIT = 8000000;
const TIME_TO_WAIT = 15000;

const main = async () => {
    var holders = [];
    var totalAmount = 0;
    for (i = 0; i < jsonParsed.length; i++) {
        var balance = jsonParsed[i].Balance * FACTOR;
        var holder = [jsonParsed[i].HolderAddress, balance.toLocaleString('fullwide', {useGrouping:false}), balance];
        holders.push(holder);
        totalAmount += jsonParsed[i].Balance;
    }

    const [deployer] = await ethers.getSigners();
    const signer = ethers.provider.getSigner(deployer.address);
    const BasicManager = await artifacts.readArtifact("BasicManager");
    const manager = new ethers.Contract(networkData.Contracts.Managers[0], BasicManager.abi, ethers.provider);

    var previousBalance = await deployer.getBalance();

    await manager.connect(signer).setDsrTokenAddress(networkData.ZeroAddress);
    await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

    await manager.connect(signer).withdrawInvestment({gasLimit: GAS_LIMIT});
    await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

    var currentBalance = await deployer.getBalance();
    var amountToReimburse = currentBalance - previousBalance;

    console.log(`Total Amount: ${totalAmount}`);
    console.log(`Previous Balance   : ${(previousBalance / FACTOR).toFixed(8)}`);
    console.log(`Current Balance    : ${(currentBalance / FACTOR).toFixed(8)}`);
    console.log(`Amount to Reimburse: ${(amountToReimburse / FACTOR).toFixed(8)}`);
    console.log(`-------------------------------------------------------------------------`);

    for (i = 0; i < jsonParsed.length; i++) {
        var amount = amountToReimburse * (jsonParsed[i].Balance / totalAmount);
        var holder = [jsonParsed[i].HolderAddress, amount.toLocaleString('fullwide', {useGrouping:false}), amount];
        var tx = await deployer.sendTransaction({to: holder[0], value: ethers.utils.parseEther((holder[2] / FACTOR).toFixed(8).toString()), gasLimit: GAS_LIMIT});
        await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
        console.log(`Reimbursing ${(holder[2] / FACTOR).toFixed(8)} ETH to ${holder[0]}. Transaction Hash: ${tx.hash}`);
    }
    
    // jsonParsed.forEach(async (item, i) => {
    //     var amount = amountToReimburse * (item.Balance / totalAmount);
    //     var holder = [item.HolderAddress, amount.toLocaleString('fullwide', {useGrouping:false}), amount];
    //     var tx = await deployer.sendTransaction({to: holder[0], value: ethers.utils.parseEther((holder[2] / FACTOR).toFixed(8).toString()), gasLimit: GAS_LIMIT});
    //     //await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
    //     console.log(`Reimbursing ${(holder[2] / FACTOR).toFixed(8)} ETH to ${holder[0]}. Transaction Hash: ${tx.hash}`);
    //     console.log(`Reimbursing ${(holder[2] / FACTOR).toFixed(8)} ETH to ${holder[0]}`);
    // });
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});