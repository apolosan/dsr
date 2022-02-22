// SPDX-License-Identifier: MIT
/*
╔╦╗┌─┐╔═╗┬  ╔═╗┬ ┬┌─┐┌┬┐┌─┐┌┬┐  ┌─┐┌─┐┬─┐  ╦═╗┌─┐┌─┐┌─┐┬─┐┌─┐┌┐┌┌─┐┌─┐       ╔╦╗╔═╗╦═╗
 ║║├┤ ╠╣ │  ╚═╗└┬┘└─┐ │ ├┤ │││  ├┤ │ │├┬┘  ╠╦╝├┤ ├┤ ├┤ ├┬┘├┤ ││││  ├┤   ───   ║║╚═╗╠╦╝
═╩╝└─┘╚  ┴  ╚═╝ ┴ └─┘ ┴ └─┘┴ ┴  └  └─┘┴└─  ╩╚═└─┘└  └─┘┴└─└─┘┘└┘└─┘└─┘       ═╩╝╚═╝╩╚═
Developed by systemdefi.crypto and rsd.cash teams
---------------------------------------------------------------------------------------
DeFi System for Reference (DSR), is the third token of the triad system RSD | SDR | DSR. Also, it is your automated
financial platform in a token. Instead of manually investing on DeFi platforms, you just deposit/send native
cryptocurrencies into this smart contract and tokenize your investment. You will receive DSR tokens in exchange for
them and will be automatically participating in our investing pool by receiving dividend yield in the form of liquid
DSR tokens (easily exchangeable for native cryptocurrency), regularly.

Part of your investment and profit are locked into LP so you can redeem it in the case. You can monitor your investment
by checking your DSR token balance. If you have more DSR tokens in your wallet than when you minted, it means
you are in profit and can trade these additional tokens in exchange for native cryptocurrency. There will always be
liquidity to get part of your investment back (and your profit as well) once the minted amount locked in LP is worth
the same or more than the invested supply, initially.

Suppose this smart contract is deployed on Binance Smart Chain (BSC Network). You send 1 BNB to the DSR token smart
contract and receive the correspondent amount in DSR tokens (1000 DSR for example, according to the current rate of
DSR/BNB LP). That 1 BNB is splitted into 2 parts. The first part is locked in the DSR/BNB LP, following the rate of
500 DSR minted for 0.5 BNB (hipotetically). The second part is sent to managers, which are smart contracts developed
to automatically invest that remaining 0.5 BNB in some selected DeFi platforms. Each manager has its own investment
strategy.

The second part of the investment is not redeemable. However, the DSR managers will be always providing dividend yield
for DSR token holders on a regular basis, while the network and the selected DeFi platform exists (forever).

Part of the profit earned is locked as liquidity as well. Where DSR contract provides indirect liquidity for RSD and
SDR tokens. The DSR smart contract also takes advantage of the RSD Proof of Bet (PoBet) system by calling its contract
regularly until it receives the prize given to senders. After, the amount received is then locked as liquidity with DSR
and SDR tokens.
* CHECADORES DE LUCROS RECEBEM PARTE DO VALOR DA FUNÇÃO SE OS MANAGERS RETORNAREM LUCRO NAQUELE INSTANTE

If you are considering to not invest on DSR at the moment, just remember you had acquired some tokens in the past only
with the 'promise' of their price going up. Here, even if the token price does not go up, you are earning passive income,
which eliminates some risk. In order to price goes down, someone besides you has to mint more DSR tokens to sell them,
and the only way to do this is by directly investing in the DSR smart contract, which implicates in more locked liquidity
and more money for the managers to invest.

Even if you are some of those investors which may choose to not take the risk of directly interacting with the contract
and having half of their investment locked in, you can opt for buy DSR from the DSR/BNB LP instead. This is also good,
once it will help to increase demand for the asset and push its price upforward. You are still earning dividends for
your tokens, proportionally.
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
	address public payable developerComissionAddress;

	address public dsrEthPair;
	address public dsrRsdPair;
	address public dsrSdrPair;
	address public rsdEthPair;
	address public sdrRsdPair;

	uint256 private _countTryPoBet;
	uint256 private _totalInvestedSupply;
	uint256 private _totalSpendableProfit; // TODO: used to avoid an recipient is able to spend some inexistent profit. Develop control. NOT NEEDED ANYMORE. INSPECT...
	uint256 private _totalSupply;
	uint256 private constant _FACTOR = 10000;

	uint256 public liquidityProfitShare = 7000;
	uint256 public developerComissionRate = 100; // with _FACTOR = 10000, it means the comission rate is 1.00% and can be changed to a minimum of 0.01%
	uint256 public checkerComissionRate = developerComissionRate.div(5);
	uint256 public totalProfit;

	mapping (address => uint256) private _balances;
	mapping (address => uint256) private _currentProfitSpent;
	mapping (address => mapping (address => uint256)) private _allowances;

	address[] public managerAddresses;

	string private _name;
	string private _symbol;

	IERC20 private _sdrToken;
	IWETH private _wEth;
	IReferenceSystemDeFi private _rsdToken;
	IUniswapV2Router02 private _exchangeRouter;

	event Burn(address from, address zero, uint256 amount);
	event Mint(address zero, address account, uint256 amount);

	modifier lockTryPoBet {
		_countTryPoBet = _countTryPoBet.add(1);
		_;
		_countTryPoBet = _countTryPoBet.sub(1);
	}

	constructor(
		string memory name,
		string memory symbol) {
		_name = name;
		_symbol = symbol;
	}

	receive() external payable {
		invest(_msgSender());
	}

	fallback() external payable {
		require(msg.data.length == 0);
		invest(_msgSender());
	}

	function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
			require(sender != address(0), "ERC20: transfer from the zero address");
			require(recipient != address(0), "ERC20: transfer to the zero address");

			_beforeTokenTransfer(sender, recipient, amount);

			uint256 senderBalance = balanceOf(sender);
			require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
			if (potentialProfitPerAccount(sender) > 0 && _currentProfitSpent[sender] < potentialProfitPerAccount(sender)) {
				uint256 profitSpendable = potentialProfitPerAccount(sender).sub(_currentProfitSpent[sender]);
				if (amount <= profitSpendable) {
					// Transfer only profit or part of it for desired amount
					_currentProfitSpent[sender] = _currentProfitSpent[sender].add(amount);
					_totalSpendableProfit = _totalSpendableProfit.sub(amount);
					_totalInvestedSupply = _totalInvestedSupply.add(amount);
				} else {
					// Transfer all profit and part of balance for desired amount
					uint256 spendableDifference = amount.sub(profitSpendable);
					_currentProfitSpent[sender] = _currentProfitSpent[sender].add(profitSpendable);
					_totalSpendableProfit = _totalSpendableProfit.sub(profitSpendable);
					_totalInvestedSupply = _totalInvestedSupply.add(profitSpendable);
					_balances[sender] = _balances[sender].sub(spendableDifference);
					// Calculate new profit spent in order to allow the sender to continue participating in the next profit cycles, regularly
					_currentProfitSpent[sender] = potentialProfitPerAccount(sender);
				}
			} else {
				_balances[sender] = senderBalance.sub(amount);
			}

			// To avoid the recipient be able to spend an inexistent profit we consider he already spent the current claimable profit
			// He will be able to earn profit in the next cycle, after the call of receiveProfit() function
			if (_balances[recipient] == 0) {
				_balances[recipient] = _balances[recipient].add(amount);
				_currentProfitSpent[recipient] = potentialProfitPerAccount(recipient);
			} else {
				uint256 previousSpendableProfitRecipient = potentialProfitPerAccount(recipient);
				_balances[recipient] = _balances[recipient].add(amount);
				uint256 currentSpendableProfitRecipient = potentialProfitPerAccount(recipient);
				_currentProfitSpent[recipient] = currentSpendableProfitRecipient.sub(previousSpendableProfitRecipient);
			}

			emit Transfer(sender, recipient, amount);
	}

	function _mint(address account, uint256 amount) internal virtual override {
			require(account != address(0), "ERC20: mint to the zero address");

			_beforeTokenTransfer(address(0), account, amount);

			_totalSupply = _totalSupply.add(amount);
			_balances[account] = _balances[account].add(amount);
			emit Mint(address(0), account, amount);
	}

	function _burn(address account, uint256 amount) internal virtual override {
			require(account != address(0), "ERC20: burn from the zero address");

			_beforeTokenTransfer(account, address(0), amount);

			uint256 burnBalance = balanceOf(account);
			require(burnBalance >= amount, "ERC20: burn amount exceeds balance");
			if (potentialProfitPerAccount(account) > 0 && _currentProfitSpent[account] < potentialProfitPerAccount(account)) {
				uint256 profitSpendable = potentialProfitPerAccount(account).sub(_currentProfitSpent[account]);
				if (amount <= profitSpendable) {
					_currentProfitSpent[account] = _currentProfitSpent[account].add(amount);
					_totalSpendableProfit = _totalSpendableProfit.sub(amount);
				} else {
					uint256 spendableDifference = amount.sub(profitSpendable);
					_currentProfitSpent[account] = _currentProfitSpent[account].add(profitSpendable);
					_totalSpendableProfit = _totalSpendableProfit.sub(profitSpendable);
					_balances[account] = _balances[account].sub(spendableDifference);
					_totalInvestedSupply = _totalInvestedSupply.sub(spendableDifference);
					// Calculate new profit spent in order to allow the sender investor to continue participating in the next profit cycles
					_currentProfitSpent[account] = potentialProfitPerAccount(account);
				}
			} else {
				_balances[account] = burnBalance.sub(amount);
			}
			_totalSupply = _totalSupply.sub(amount);

			emit Burn(account, address(0), amount);
	}

	function _approve(address owner, address spender, uint256 amount) internal virtual override {
			require(owner != address(0), "ERC20: approve from the zero address");
			require(spender != address(0), "ERC20: approve to the zero address");

			_allowances[owner][spender] = amount;
			emit Approval(owner, spender, amount);
	}

	function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
		tryPoBet();
	}

	function balanceOf(address account) public view virtual override returns (uint256) {
			if (account == address(this))
				// DSR smart contract does not participate in the profit sharing
				return _balances[address(this)];
			else
				return (potentialBalanceOf(account).sub(_currentProfitSpent[account]));
	}

	function potentialBalanceOf(address account) public view return(uint256) {
		return _balances[account].add(potentialProfitPerAccount(account));
	}

	function _addLiquidityDsrEth(uint256 dsrTokenAmount, uint256 ethAmount) private returns(bool) {
			_approve(address(this), address(_exchangeRouter), dsrTokenAmount);
			// add the liquidity for DSR/ETH pair
			try _exchangeRouter.addLiquidityETH{value: ethAmount}(
					address(this),
					dsrTokenAmount,
					0, // slippage is unavoidable
					0, // slippage is unavoidable
					address(0),
					block.timestamp
			) { return true; } catch { return false; }
	}

	function _addLiquidityDsrRsd(uint256 dsrTokenAmount, uint256 rsdTokenAmount) private returns(bool) {
		// approve token transfer to cover all possible scenarios
		_approve(address(this), address(_exchangeRouter), dsrTokenAmount);
		_rsdToken.approve(address(_exchangeRouter), rsdTokenAmount);
		// add the liquidity for DSR/RSD pair
		try _exchangeRouter.addLiquidity(
			address(this),
			rsdTokenAddress,
			dsrTokenAmount,
			rsdTokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			address(0),
			block.timestamp
		); { return true; } catch { return false; }
	}

	function _addLiquidityDsrSdr(uint256 dsrTokenAmount, uint256 sdrTokenAmount) private returns(bool) {
		// approve token transfer to cover all possible scenarios
		_approve(address(this), address(_exchangeRouter), dsrTokenAmount);
		_sdrToken.approve(address(_exchangeRouter), sdrTokenAmount);

		// add the liquidity for DSR/SDR pair
		try _exchangeRouter.addLiquidity(
			address(this),
			sdrTokenAddress,
			dsrTokenAmount,
			sdrTokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			address(0),
			block.timestamp
		) { return true; } catch { return false; }
	}

	// RESOURCE ALLOCATION STRATEGY - FOR EARNED PROFIT
	function _allocateProfit() private {
		// 1. Pay commission of the developer team
		_chargeComission(address(this).balance.mul(developerComissionRate).div(_FACTOR));

		// 2. Allocate resources for the DSR/ETH LP
		_addLiquidityDsrEth(balanceOf(address(this)), address(this).balance.mul(liquidityProfitShare).div(_FACTOR));

		// 3. Allocate resources for the Manager(s)
		if (managerAddresses.length > 0) {
			uint256 share = address(this).balance.div(managerAddresses.length);
			for (uint256 i = 0; i < managerAddresses.length; i++) {
				Manager manager = Manager(managerAddresses[i]);
				manager.receiveResources{share}();
			}
		}
	}

	// RESOURCE ALLOCATION STRATEGY - FOR INITIAL INVESTORS
	function _allocateResources() private {
		// 1. Pay commission of the developer team
		_chargeComission(address(this).balance.mul(developerComissionRate).div(_FACTOR));

		// 2. Allocate resources for the DSR/ETH LP
		_addLiquidityDsrEth(balanceOf(address(this)), address(this).balance.div(2));

		// 3. Allocate resources for the Manager(s)
		if (managerAddresses.length > 0) {
			uint256 share = address(this).balance.div(managerAddresses.length);
			for (uint256 i = 0; i < managerAddresses.length; i++) {
				Manager manager = Manager(managerAddresses[i]);
				manager.receiveResources{share}();
			}
		}
	}

	function _chargeComission(uint256 amount) private {
		// check if the commission wallet is defined
		DsrHelper developerComissionWallet;
		if (developerComissionAddress == address(0)) {
			developerComissionWallet = new DsrHelper(owner());
			developerComissionWallet = address(developerComissionWallet);
		}
		developerComissionAddress.transfer(amount);
	}

	function _getDsrEthPoolRate() private view returns(uint256) {
		if (dsrEthPair == address(0)) {
			return 1;
		} else {
			uint256 dsrBalance = balanceOf(dsrEthPair);
			uint256 ethBalance = IERC20(address(_wEth)).balanceOf(dsrEthPair);
			ethBalance = ethBalance == 0 ? 1 : ethBalance;
			return (dsrBalance.div(ethBalance));
		}
	}

	function _getDsrRsdPoolRate() private view returns(uint256) {
		if (dsrRsdPair == address(0)) {
			return 1;
		} else {
			uint256 rsdBalance = _rsdToken.balanceOf(dsrRsdPair);
			uint256 dsrBalance = balanceOf(dsrRsdPair);
			rsdBalance = rsdBalance == 0 ? 1 : rsdBalance;
			return (dsrBalance.div(rsdBalance));
		}
	}

	function _getDsrSdrPoolRate() private view returns(uint256) {
		if (dsrSdrPair == address(0)) {
			return 1;
		} else {
			uint256 sdrBalance = _sdrToken.balanceOf(dsrSdrPair);
			uint256 dsrBalance = balanceOf(dsrSdrPair);
			dsrBalance = dsrBalance == 0 ? 1 : dsrBalance;
			return (sdrBalance.div(dsrBalance));
		}
	}

	function _getRsdEthPoolRate() private view returns(uint256) {
		if (rsdEthPair == address(0)) {
			return 1;
		} else {
			uint256 rsdBalance = _rsdToken.balanceOf(rsdEthPair);
			uint256 ethBalance = IERC20(address(_wEth)).balanceOf(rsdEthPair);
			ethBalance = ethBalance == 0 ? 1 : ethBalance;
			return (rsdBalance.div(ethBalance));
		}
	}

	function _splitDividend(uint256 dividendAmount) private {
		totalProfit = totalProfit.add(dividendAmount);
		_totalSpendableProfit = _totalSpendableProfit.add(dividendAmount);
		_totalSupply = _totalSupply.add(dividendAmount);
	}

	function _swapRsdForDsr(uint256 tokenAmount) private returns(bool) {
		// need to check if the helper address is initialized
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

	function addManager(address manager) public onlyOwner {
		require(!isManagerAdded(manager), "DSR: manager was added already");
		managerAddresses.push(manager);
	}

	function checkForProfit() public {
		// TODO: reward msg.sender of this function if there is some profit
	}

	function getAvailableTotalProfit() public view returns(uint256) {
		return _totalSpendableProfit;
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

			address[] managerAddresses = new address[];
	}

	function invest(address investor) public payable {
		uint256 rate;
		if (balanceOf(dsrEthPair) == 0 || dsrEthPair == address(0)) {
			rate = _getRsdEthPoolRate();
		} else {
			rate = _getDsrEthPoolRate();
		}
		if (msg.value > 0) {
			_mint(investor, msg.value.mul(rate));
			_totalInvestedSupply = _totalInvestedSupply.add(msg.value.mul(rate));
			_mint(address(this), msg.value.mul(rate).div(2));
		}
		_allocateResources();
	}

	function isManagerAdded(address manager) public returns(bool) {
		for (uint256 i = 0; i < managerAddresses.length; i++)
			if (manager == managerAddresses[i])
				return true;

		return false;
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

	// TODO: adjust the percent share
	function receiveProfit() public payable {
		if (msg.value > 0) {
			uint256 rate = _getDsrEthPoolRate();
			// it means the contract has enough DSR to send to the DSR/ETH LP
			if (balanceOf(address(this)) <= msg.value.mul(rate).div(2)) {
				uint256 balanceDiff = msg.value.mul(rate).div(2).sub(balanceOf(address(this)));
				_mint(address(this), balanceDiff);
			}
			_splitDividend(msg.value.mul(rate).div(2));
			_allocateProfit();
		}
	}

	function removeManager(address manager) public onlyOwner {
		require(isManagerAdded(manager), "DSR: manager informed does not exist in this contract anymore");
		address[] newManagerAddresses = new address[];
		for (uint256 i = 0; i < managerAddresses.length; i++) {
			if (manager != managerAddresses[i]) {
				newManagerAddresses.push(managerAddresses[i]);
			}
		}
		managerAddresses = newManagerAddresses;
	}

	function potentialProfitPerAccount(address account) public view returns(uint256) {
		if (_totalInvestedSupply == 0)
			return _totalInvestedSupply;
		else
			return totalProfit.mul(_balances[account]).div(_totalInvestedSupply);
	}

	// here the DSR token contract tries to earn some RSD tokens in the PoBet system. The earned amount is then locked in the DSR/RSD LP
	function tryPoBet() public lockTryPoBet {
		if (_countTryPoBet < 2) {
			uint256 rsdBalance = _rsdToken.balanceOf(address(this));

			if (rsdBalance > 0)
				_rsdToken.transfer(obtainRandomWalletAddress(), 1);
			else
				_rsdToken.transfer(obtainRandomWalletAddress(), 0);

			// it means we have won the PoBet prize! Woo hoo! So, now we lock liquidity in DSR/RSD LP with this earned amount!
			if (rsdBalance < _rsdToken.balanceOf(address(this))) {
				uint256 earnedRsd = _rsdToken.balanceOf(address(this)).sub(rsdBalance);

				DsrHelper dsrHelper;
				if (balanceOf(address(this)) == 0) {
					// DSR amount in DSR contract and in DSR/RSD LP is both 0. In this case we mint DSR and deposit initial liquidity into the DSR/RSD LP with the earned RSD from PoBet, with the corresponding amount of DSR following the rate of RSD in the RSD/ETH LP
					if (balanceOf(dsrRsdPair) == 0) {
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
					if (balanceOf(dsrRsdPair) == 0) {
						_addLiquidityDsrRsd(balanceOf(address(this)), earnedRsd);
					} else {
						// DSR contract has some DSR amount and there is liquidity in DSR/RSD LP. We need to check the rate of DSR/RSD pool before add liquidity in DSR/RSD LP
						uint256 minAmount = _getDsrRsdPoolRate().mul(earnedRsd.div(2)) > balanceOf(address(this)) ? balanceOf(address(this)) : _getDsrRsdPoolRate().mul(earnedRsd.div(2));
						_addLiquidityDsrRsd(minAmount, earnedRsd.div(2));
					}
				}
			}
			// we also help to improve randomness of the RSD token contract after trying the PoBet system
			_rsdToken.generateRandomMoreThanOnce();
			delete rsdBalance;
		}
	}

	function setDeveloperComissionRate(uint256 comissionRate) public onlyOwner {
		developerComissionRate = comissionRate;
	}

	function setSdrTokenAddress(address sdrTokenAddress_) public onlyOwner {
		sdrTokenAddress = sdrTokenAddress_;
	}

	function setRsdTokenAddress(address rsdTokenAddress_) public onlyOwner {
		rsdTokenAddress = rsdTokenAddress_;
	}
}
