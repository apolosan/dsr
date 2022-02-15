// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
/* import "./IReferenceSystemDeFi.sol";
import "hardhat/console.sol"; */

contract DeFiSystemReference is Context, ERC20("DeFi System for Reference", "DSR"), Ownable {

	mapping (address => uint256) private _balances;
	mapping (address => mapping (address => uint256)) private _allowances;
	uint256 private _totalSupply;
	string private _name;
	string private _symbol;

	constructor(string memory name, string memory symbol) {
		_name = name;
		_symbol = symbol;
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
}
