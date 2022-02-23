require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

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
				optimizer: {
					enabled: true,
					runs: 5
				}
			}
		},
	networks: {
		development: {
			url: `http://127.0.0.1:8545`,
			mnemonic: mnemonic_,
			allowUnlimitedContractSize: "true",
			gas: "auto",
			gasPrice: "auto"
		},
		bsc_testnet: {
			url: `https://data-seed-prebsc-1-s3.binance.org:8545`,
			accounts: {mnemonic: mnemonic_},
			blockGasLimit: 12450000,
			gas: 12450000,
			gasPrice: "auto",
			network_id: 97
		},
		bsc_mainnet: {
			url: `https://bsc-dataseed2.binance.org:443`,
			network_id: 56,
			accounts: {mnemonic: mnemonic_},
			blockGasLimit: 12450000,
			gas: 12450000,
			gasPrice: "auto"
		},
		eth_mainnet: {
			url: `https://mainnet.infura.io/v3/692236537493482daf8d9f4ca5f68a6a`,
			accounts: {mnemonic: mnemonic_},
			blockGasLimit: 12450000,
			gas: 12450000,
			gasPrice: "auto",
			network_id: 1
		},
		arbitrum: {
			url: `https://arb1.arbitrum.io/rpc`,
			accounts: {mnemonic: mnemonic_},
			network_id: 42161,
			gas: 0,
			gasPrice: "auto"
		},
		optimism: {
			url: `https://mainnet.optimism.io`,
			accounts: {mnemonic: mnemonic_},
			network_id: 10,
			gas: 0,
			gasPrice: "auto"
		},
		fantom_testnet: {
			url: `https://rpc.testnet.fantom.network`,
			accounts: {mnemonic: mnemonic_},
			blockGasLimit: 5000000,
			gas: 5000000,
			gasPrice: "auto",
			network_id: 0xfa2
		},
		harmony: {
			url: `https://api.harmony.one`,
			accounts: {mnemonic: mnemonic_},
			gas: 5000000,
			gasPrice: "auto",
			network_id: 1666600000,
		}
	},
	etherscan: {
		apiKey: 'FIHXBFSNE8869E9HIQSCU9RPGBK31WXG3P',
	},
	ftmscan: {
		apiKey: 'QVS2K8CNVXQW7HF12KRW354EBQSJVZCS7U'
	}
};
