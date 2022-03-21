require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ganache");
//require('hardhat-ethernal');
require('hardhat-contract-sizer');
require("hardhat-gas-reporter");

const fs = require('fs');
const path = require("path");
const mnemonic_ = fs.readFileSync(path.resolve(__dirname, ".secret_deploy")).toString().trim();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  	solidity: {
			version: "0.8.0",
			settings: {
        evmVersion: "byzantium",
				optimizer: {
					enabled: true,
					runs: 12000
				}
			}
		},
	networks: {
		development: {
			url: `http://127.0.0.1:8545`,
			mnemonic: mnemonic_,
			gas: "auto",
			gasPrice: "auto",
      timeout: 40000
		},
		bsc_testnet: {
			url: `https://data-seed-prebsc-1-s1.binance.org:8545`,
			accounts: {mnemonic: mnemonic_},
      blockGasLimit: 12450000,
      gasPrice: "auto",
      gas: 6000000,
			network_id: 97,
      timeout: 40000
		},
		bsc_mainnet: {
			url: `https://bsc-dataseed2.binance.org:443`,
			network_id: 56,
			accounts: {mnemonic: mnemonic_},
			blockGasLimit: 12450000,
			gas: 12450000,
			gasPrice: "auto",
      timeout: 40000
		},
		eth_mainnet: {
			url: `https://mainnet.infura.io/v3/692236537493482daf8d9f4ca5f68a6a`,
			accounts: {mnemonic: mnemonic_},
			blockGasLimit: 12450000,
			gas: 12450000,
			gasPrice: "auto",
			network_id: 1,
      timeout: 40000
		},
    eth_kovan: {
      url: `https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161`,
      accounts: {mnemonic: mnemonic_},
      blockGasLimit: 12450000,
      gas: 12450000,
      gasPrice: "auto",
      network_id: 42,
      timeout: 40000
    },
    eth_rinkeby: {
      url: `https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161`,
      accounts: {mnemonic: mnemonic_},
      blockGasLimit: 12450000,
      gas: 12450000,
      gasPrice: "auto",
      network_id: 4,
      timeout: 40000
    },
    eth_ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/Ag5POFqHfMtbOBKQqR9FMBkAQu9CLtBi`,
      accounts: {mnemonic: mnemonic_},
      saveDeployments: true,
      confirmations: 0,
      blockGasLimit: 8000000,
      gasLimit: 8000000,
      gas: 8000000,
      gasPrice: 20000000000,
      network_id: 3,
      timeout: 40000
    },
		arbitrum: {
			url: `https://arb1.arbitrum.io/rpc`,
			accounts: {mnemonic: mnemonic_},
			network_id: 42161,
			gas: 0,
			gasPrice: "auto",
      timeout: 40000
		},
		optimism: {
			url: `https://mainnet.optimism.io`,
			accounts: {mnemonic: mnemonic_},
			network_id: 10,
			gas: 0,
			gasPrice: "auto",
      timeout: 40000
		},
		fantom: {
			url: `https://rpc.ftm.tools`,
			accounts: {mnemonic: mnemonic_},
			blockGasLimit: 5000000,
			gas: 5000000,
			gasPrice: "auto",
			network_id: 250,
      timeout: 40000
		},
    polygon: {
      url: `https://polygon-rpc.com/`,
      accounts: {mnemonic: mnemonic_},
      blockGasLimit: 5000000,
      gas: 5000000,
      gasPrice: "auto",
      network_id: 137,
      timeout: 40000
    },
    avalanche: {
      url: `https://api.avax.network/ext/bc/C/rpc`,
      accounts: {mnemonic: mnemonic_},
      blockGasLimit: 5000000,
      gas: 5000000,
      gasPrice: "auto",
      network_id: 43114,
      timeout: 40000
    },
		harmony: {
			url: `https://api.harmony.one`,
			accounts: {mnemonic: mnemonic_},
			gas: 5000000,
			gasPrice: "auto",
			network_id: 1666600000,
      timeout: 40000
		}
	},
	etherscan: {
		apiKey: 'FIHXBFSNE8869E9HIQSCU9RPGBK31WXG3P',
	},
	ftmscan: {
		apiKey: 'QVS2K8CNVXQW7HF12KRW354EBQSJVZCS7U'
	}
};
