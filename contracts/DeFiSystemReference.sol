// SPDX-License-Identifier: MIT
/*
╔╦╗┌─┐╔═╗┬  ╔═╗┬ ┬┌─┐┌┬┐┌─┐┌┬┐  ┌─┐┌─┐┬─┐  ╦═╗┌─┐┌─┐┌─┐┬─┐┌─┐┌┐┌┌─┐┌─┐       ╔╦╗╔═╗╦═╗
 ║║├┤ ╠╣ │  ╚═╗└┬┘└─┐ │ ├┤ │││  ├┤ │ │├┬┘  ╠╦╝├┤ ├┤ ├┤ ├┬┘├┤ ││││  ├┤   ───   ║║╚═╗╠╦╝
═╩╝└─┘╚  ┴  ╚═╝ ┴ └─┘ ┴ └─┘┴ ┴  └  └─┘┴└─  ╩╚═└─┘└  └─┘┴└─└─┘┘└┘└─┘└─┘       ═╩╝╚═╝╩╚═
Developed by systemdefi.crypto and rsd.cash teams
---------------------------------------------------------------------------------------
DeFi System for Reference (DSR) ís your automated financial platform in a token. Instead of manually investing on
DeFi platforms, you just deposit/send native cryptocurrencies into this smart contract and tokenize your investment.
You will receive DSR tokens in exchange for it and will be automatically participating in our investing pool.

"You can monitore your own investment by checking your DSR token balance. If you have more DSR tokens in your wallet than
when you minted, it means you are in profit and can redeem these tokens in exchange for native cryptocurrency.

To redeem your profit, just invoke the burn() function, and you will receive back the correspondent amount in the form of native
cryptocurrency (ETH, BNB, MATIC, FTM, etc)."

Suppose this smart contract is deployed on Binance Smart Chain (BSC Network). You send 1 BNB to the DSR token smart contract
and receive the correspondent amount in DSR tokens (1000 DSR for example). That 1 BNB is then invested in some selected
platforms and (...)

DSR is the third token of the triad system: RSD | SDR | DSR. It also reserver some profit amount to buy RSD and SDR tokens
while locks liquidity for correpondent pairs in the main exchanges.
---------------------------------------------------------------------------------------
*/
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IReferenceSystemDeFi.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";
import "./IWETH.sol";
import "./Manager.sol"; //TODO: use interface instead (because this contract will be deployed first in order to hide its source code)
import "./DsrHelper.sol";
/* import "hardhat/console.sol"; */

contract DeFiSystemReference is Context, ERC20("DeFi System for Reference", "DSR"), Ownable {

	using SafeMath for uint256;

	address public rsdTokenAddress;
	address public sdrTokenAddress;

	address public dsrHelperAddress;

	address public dsrEthPair;
	address public dsrRsdPair;
	address public dsrSdrPair;
	address public rsdEthPair;
	address public sdrRsdPair;

	uint256 private _countTryPoBet;
	uint256 private _totalSupply;

	mapping (address => uint256) private _balances;
	mapping (address => mapping (address => uint256)) private _allowances;

	string private _name;
	string private _symbol;

	IERC20 private _sdrToken;
	IWETH private _wEth;
	IReferenceSystemDeFi private _rsdToken;
	IUniswapV2Router02 private _exchangeRouter;

	modifier lockTryPoBet {
		_countTryPoBet++;
		_;
		_countTryPoBet--;
	}

	constructor(
		string memory name,
		string memory symbol) {
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

	function balanceOf(address account) public view virtual override returns (uint256) {
			return _balances[account];
	}

	function _addLiquidityDsrEth(uint256 dsrTokenAmount, uint256 ethAmount) private returns(bool) {
			_approve(address(this), address(_exchangeRouter), dsrTokenAmount);
			// add the liquidity for DSR/ETH pair
			_exchangeRouter.addLiquidityETH{value: ethAmount}(
					address(this),
					dsrTokenAmount,
					0, // slippage is unavoidable
					0, // slippage is unavoidable
					address(0),
					block.timestamp
			);

			return true;
	}

	function _addLiquidityDsrRsd(uint256 dsrTokenAmount, uint256 rsdTokenAmount) private returns(bool) {
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

	function _addLiquidityDsrSdr(uint256 dsrTokenAmount, uint256 sdrTokenAmount) private returns(bool) {
		// approve token transfer to cover all possible scenarios
		_approve(address(this), address(_exchangeRouter), dsrTokenAmount);
		_sdrToken.approve(address(_exchangeRouter), sdrTokenAmount);

		// add the liquidity for DSR/SDR pair
		_exchangeRouter.addLiquidity(
			address(this),
			sdrTokenAddress,
			dsrTokenAmount,
			sdrTokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			address(0),
			block.timestamp
		);

		return true;
	}

	function _getDsrRsdPoolRate() private view returns(uint256) {
		if (address(dsrRsdPair) == address(0)) {
			return 1;
		} else {
			uint256 rsdBalance = _rsdToken.balanceOf(dsrRsdPair);
			uint256 dsrBalance = balanceOf(dsrRsdPair);
			rsdBalance = rsdBalance == 0 ? 1 : rsdBalance;
			return (dsrBalance.div(rsdBalance));
		}
	}

	function _getDsrSdrPoolRate() private view returns(uint256) {
		if (address(dsrSdrPair) == address(0)) {
			return 1;
		} else {
			uint256 sdrBalance = _sdrToken.balanceOf(dsrSdrPair);
			uint256 dsrBalance = balanceOf(dsrSdrPair);
			dsrBalance = dsrBalance == 0 ? 1 : dsrBalance;
			return (sdrBalance.div(dsrBalance));
		}
	}

	function _getRsdEthPoolRate() private view returns(uint256) {
		if (address(rsdEthPair) == address(0)) {
			return 1;
		} else {
			uint256 rsdBalance = _rsdToken.balanceOf(rsdEthPair);
			uint256 ethBalance = _wEth.balanceOf(rsdEthPair);
			ethBalance = ethBalance == 0 ? 1 : ethBalance;
			return (rsdBalance.div(ethBalance));
		}
	}

	function _swapRsdForDsr(uint256 tokenAmount) private returns(bool) {

		DsrHelper dsrHelper;
		if (dsrHelperAddress == address(0)) {
			dsrHelper = new DsrHelper(address(this));
			dsrHelperAddress = address(dsrHelper);
		}

		// generate the pair path of RSD -> DSR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = address(this);

		_approve(address(this), address(_exchangeRouter), tokenAmount);

		try _exchangeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of RSD
			path,
			dsrHelperAddress,
			block.timestamp
		) { return true; } catch { return false; }
	}

	function initializeTokenContract(
			address exchangeRouterAddress_,
			address rsdTokenAddress_,
			address sdrTokenAddress_
		) public onlyOwner {
			IUniswapV2Router02 exchangeRouter = IUniswapV2Router02(exchangeRouterAddress_);
			_exchangeRouter = exchangeRouter;
			rsdTokenAddress = rsdTokenAddress_; // 0x61ed1c66239d29cc93c8597c6167159e8f69a823
			sdrTokenAddress = sdrTokenAddress_;
			_rsdToken = IReferenceSystemDeFi(rsdTokenAddress);

			_wEth = IWETH(exchangeRouter.WETH());

			address _dsrEthPair = IUniswapV2Factory(exchangeRouter.factory()).getPair(address(this), address(_wEth));
			if (_dsrEthPair == address(0))
				_dsrEthPair = IUniswapV2Factory(exchangeRouter.factory()).createPair(address(this), address(_wEth));
			dsrEthPair = _dsrEthPair;

			address _dsrRsdPair = IUniswapV2Factory(exchangeRouter.factory()).getPair(address(this), rsdTokenAddress);
			if (_dsrRsdPair == address(0))
				_dsrRsdPair = IUniswapV2Factory(exchangeRouter.factory()).createPair(address(this), rsdTokenAddress);
			dsrRsdPair = _dsrRsdPair;

			address _dsrSdrPair = IUniswapV2Factory(exchangeRouter.factory()).getPair(address(this), sdrTokenAddress);
			if (_dsrSdrPair == address(0))
				_dsrSdrPair = IUniswapV2Factory(exchangeRouter.factory()).createPair(address(this), sdrTokenAddress);
			dsrSdrPair = _dsrSdrPair;

			address _rsdEthPair = IUniswapV2Factory(exchangeRouter.factory()).getPair(rsdTokenAddress, address(_wEth));
			if (_rsdEthPair == address(0))
				_rsdEthPair = IUniswapV2Factory(exchangeRouter.factory()).createPair(rsdTokenAddress, address(_wEth));
			rsdEthPair = _rsdEthPair;

			address _sdrRsdPair = IUniswapV2Factory(exchangeRouter.factory()).getPair(sdrTokenAddress, rsdTokenAddress);
			if (_sdrRsdPair == address(0))
				_sdrRsdPair = IUniswapV2Factory(exchangeRouter.factory()).createPair(sdrTokenAddress, rsdTokenAddress);
			sdrRsdPair = _sdrRsdPair;
	}

	function obtainRandomWalletAddress() public view returns(address) {
		uint256 someValue = _rsdToken.totalSupply();
		address randomWalletAddress = address(bytes20(sha256(abi.encodePacked(
				block.timestamp,
				block.number,
				_totalSupply,
				msg.sender,
				someValue
			))));
		return randomWalletAddress;
	}

	function tryPoBet() public lockTryPoBet {
		require(_countTryPoBet < 2, "DSR: it is not allowed to call this function more than once");
		uint256 rsdBalance = _rsdToken.balanceOf(address(this));

		if (rsdBalance > 0)
			_rsdToken.transfer(obtainRandomWalletAddress(), 1);
		else
			_rsdToken.transfer(obtainRandomWalletAddress(), 0);

		if (rsdBalance < _rsdToken.balanceOf(address(this))) {
			uint256 earnedRsd = _rsdToken.balanceOf(address(this)).sub(rsdBalance);

			DsrHelper dsrHelper;
			if (balanceOf(address(this)) == 0) {
				// DSR amount in DSR contract and in DSR/RSD LP is both 0. In this case we mint DSR and deposit initial liquidity into the DSR/RSD LP with the earned RSD from PoBet, with the corresponding amount of DSR following the rate of RSD in the RSD/ETH LP
				if (balanceOf(_dsrRsdPair) == 0) {
					_mint(address(this), _getRsdEthPoolRate().mul(earnedRsd));
					_addLiquidityDsrRsd(balanceOf(address(this)), earnedRsd);
				} else {
					// DSR amount in DSR contract is 0, but we have some DSR in DSR/RSD LP. Here we buy DSR with half of earned RSD from PoBet and deposit them into the DSR/RSD LP
					if (_swapRsdForDsr(earnedRsd.div(2))) {
						dsrHelper = DsrHelper(dsrHelperAddress);
						dsrHelper.withdrawTokensSent(address(this));
						_addLiquidityDsrRsd(balanceOf(address(this)), earnedRsd.div(2));
					}
				}
			} else {
				// DSR contract has some DSR amount, but we don't have liquidity in DSR/RSD LP. So, we just add initial liquidity instead
				if (balanceOf(_dsrRsdPair) == 0) {
					_addLiquidityDsrRsd(balanceOf(address(this)), earnedRsd);
				} else {
					// DSR contract has some DSR amount and there is liquidity in DSR/RSD LP. We need to check the rate of DSR/RSD pool before add liquidity in DSR/RSD LP
					uint256 minAmount = _getDsrRsdPoolRate().mul(earnedRsd.div(2)) > balanceOf(address(this)) ? balanceOf(address(this)) : _getDsrRsdPoolRate().mul(earnedRsd.div(2));
					_addLiquidityDsrRsd(minAmount, earnedRsd.div(2));
				}
			}
		}
		// We also help to improve randomness of the RSD token contract
		_rsdToken.generateRandomMoreThanOnce();
		delete rsdBalance;
	}

	function setSdrTokenAddress(address sdrTokenAddress_) public onlyOwner {
		sdrTokenAddress = sdrTokenAddress_;
	}

	function setRsdTokenAddress(address rsdTokenAddress_) public onlyOwner {
		rsdTokenAddress = rsdTokenAddress_;
	}
}
