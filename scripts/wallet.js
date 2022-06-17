const mnemonic = '';
const wallet = ethers.Wallet.fromMnemonic(mnemonic);
console.log(wallet.address);