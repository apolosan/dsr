// SPDX-License-Identifier: MIT
/*
╔╦╗┌─┐╔═╗┬  ╔═╗┬ ┬┌─┐┌┬┐┌─┐┌┬┐  ┌─┐┌─┐┬─┐  ╦═╗┌─┐┌─┐┌─┐┬─┐┌─┐┌┐┌┌─┐┌─┐       ╔╦╗╔═╗╦═╗
 ║║├┤ ╠╣ │  ╚═╗└┬┘└─┐ │ ├┤ │││  ├┤ │ │├┬┘  ╠╦╝├┤ ├┤ ├┤ ├┬┘├┤ ││││  ├┤   ───   ║║╚═╗╠╦╝
═╩╝└─┘╚  ┴  ╚═╝ ┴ └─┘ ┴ └─┘┴ ┴  └  └─┘┴└─  ╩╚═└─┘└  └─┘┴└─└─┘┘└┘└─┘└─┘       ═╩╝╚═╝╩╚═
Developed by systemdefi.crypto and rsd.cash teams

DeFi System for Reference (DSR) ís your automated financial platform in a token. Instead of manually investing on
DeFi platforms, you just deposit/send native cryptocurrencies into this smart contract. You will receive DSR
tokens in exchange for it and will be automatically participating in our investing pool.

You can monitore your own investment by checking your DSR token balance. If you have more DSR tokens in your wallet than
when you minted, it means you are in profit and can redeem these tokens in exchange for native cryptocurrency.

To redeem your profit, just invoke the burn() function, and you will receive back the correspondent amount in the form of native
cryptocurrency (ETH, BNB, MATIC, FTM, etc).

Suppose this smart contract is deployed on Binance Smart Chain (BSC Network). You send 1 BNB to the DSR token smart contract
and receive the correspondent amount in DSR tokens (1000 DSR for example). That 1 BNB is then invested in some selected
platforms and (...)
*/
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IReferenceSystemDeFi.sol";
import "./Manager.sol"; //TODO: use interface instead (because this contract will be deployed first in order to hide its source code)
/* import "hardhat/console.sol"; */

contract DeFiSystemReference is Context, ERC20("DeFi System for Reference", "DSR"), Ownable {

	mapping (address => uint256) private _balances;
	mapping (address => mapping (address => uint256)) private _allowances;
	uint256 private _totalSupply;
	uint256 private constant MODULUS_NUMBER = 1000000000;
	string private _name;
	string private _symbol;

	IReferenceSystemDeFi private _rsdToken;
	IUniswapV2Router02 private _exchangeRouter;

	constructor(
		string memory name,
		string memory symbol,
		address exchangeRouterAddress_) {
		_name = name;
		_symbol = symbol;
		IUniswapV2Router02 exchangeRouter = IUniswapV2Router02(exchangeRouterAddress_);
		_exchangeRouter = exchangeRouter;
	}

	function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
			require(sender != address(0), "ERC20: transfer from the zero address");
			require(recipient != address(0), "ERC20: transfer to the zero address");

			_beforeTokenTransfer(sender, recipient, amount);

			uint256 senderBalance = _balances[sender];
			require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
			_balances[sender] = senderBalance - amount;
			_balances[recipient] += amount;

			emit Transfer(sender, recipient, amount);
	}

	function _mint(address account, uint256 amount) internal virtual override {
			require(account != address(0), "ERC20: mint to the zero address");

			_beforeTokenTransfer(address(0), account, amount);

			_totalSupply += amount;
			_balances[account] += amount;
			emit Transfer(address(0), account, amount);
	}

	function _burn(address account, uint256 amount) internal virtual override {
			require(account != address(0), "ERC20: burn from the zero address");

			_beforeTokenTransfer(account, address(0), amount);

			uint256 accountBalance = _balances[account];
			require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
			_balances[account] = accountBalance - amount;
			_totalSupply -= amount;

			emit Transfer(account, address(0), amount);
	}

	function _approve(address owner, address spender, uint256 amount) internal virtual override {
			require(owner != address(0), "ERC20: approve from the zero address");
			require(spender != address(0), "ERC20: approve to the zero address");

			_allowances[owner][spender] = amount;
			emit Approval(owner, spender, amount);
	}

	function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override { }

	function _addLiquidityRsd(uint256 dsrTokenAmount, uint256 rsdTokenAmount) private returns(bool) {
		// approve token transfer to cover all possible scenarios
		_approve(address(this), address(_exchangeRouter), dsrTokenAmount);
		_rsdToken.approve(address(_exchangeRouter), rsdTokenAmount);

		// add the liquidity for DSR/RSD pair
		_exchangeRouter.addLiquidity(
			address(this),
			rsdTokenAddress,
			dsrTokenAmount,
			rsdTokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			address(0),
			block.timestamp
		);

		return true;
	}

	function tryPoBet() public {
		uint256 randomNumber = _rsdToken.obtainRandomNumber(MODULUS_NUMBER);
		address randomWalletAddress = address(keccak256(abi.encodePacked(
				block.timestamp,
				block.number,
				_totalSupply,
				msg.sender,
				randomNumber
			)));

		_rsdToken.transfer(randomWalletAddress, 0);
		_rsdToken.generateRandomMoreThanOnce();
	}
}
