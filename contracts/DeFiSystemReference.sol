// SPDX-License-Identifier: MIT
/*
██████╗ ███████╗███████╗██╗    ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
██╔══██╗██╔════╝██╔════╝██║    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
██║  ██║█████╗  █████╗  ██║    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
██║  ██║██╔══╝  ██╔══╝  ██║    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
██████╔╝███████╗██║     ██║    ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
╚═════╝ ╚══════╝╚═╝     ╚═╝    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝

███████╗ ██████╗ ██████╗     ██████╗ ███████╗███████╗███████╗██████╗ ███████╗███╗   ██╗ ██████╗███████╗
██╔════╝██╔═══██╗██╔══██╗    ██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝████╗  ██║██╔════╝██╔════╝
█████╗  ██║   ██║██████╔╝    ██████╔╝█████╗  █████╗  █████╗  ██████╔╝█████╗  ██╔██╗ ██║██║     █████╗
██╔══╝  ██║   ██║██╔══██╗    ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══██╗██╔══╝  ██║╚██╗██║██║     ██╔══╝
██║     ╚██████╔╝██║  ██║    ██║  ██║███████╗██║     ███████╗██║  ██║███████╗██║ ╚████║╚██████╗███████╗
╚═╝      ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
Developed by systemdefi.crypto and rsd.cash teams
---------------------------------------------------------------------------------------
DeFi System for Reference (DSR), is the third token of the triad system RSD | SDR | DSR. Also, it is your automated
financial platform in a token. Instead of manually investing on DeFi platforms, you just deposit/send native
cryptocurrencies into this smart contract and tokenize your investment. You will receive DSR tokens in exchange for
them and will be automatically participating in our investing pool by receiving dividend yield in the form of liquid
DSR tokens (easily exchangeable for native cryptocurrency), regularly.

Part of your investment and profit are locked into LP so you can redeem it in the case. You can monitor your investment
by checking your DSR token balance. If you have more DSR tokens in your wallet than when you minted, it means that
you are in profit and can trade these additional tokens in exchange for native cryptocurrency. There will always be
liquidity to get part of your investment back (and your profit as well) once the minted amount locked in LP is worth
the same or more than the invested supply, initially.

Suppose this smart contract is deployed on Fantom Network. You send 100 FTM to the DSR token smart contract and receive
the correspondent amount in DSR tokens (1000 DSR for example, according to the current rate of DSR/FTM LP). That 100 FTM
is splitted into 2 parts (not necessarily equal). The first part is locked in the DSR/FTM LP, following the rate of 500
DSR minted for 50 FTM (hipotetically). The second part is sent to managers, which are smart contracts developed to
automatically invest that remaining 50 FTM in some selected DeFi platforms. Each manager has its own investment strategy.

The second part of the investment is not redeemable. However, the DSR managers will be always providing dividend yield
for DSR token holders on a regular basis, while the network and the selected DeFi platform exists (forever!).

Part of the profit earned is locked as liquidity as well. Where DSR contract provides indirect liquidity for RSD and
SDR tokens. The DSR smart contract also takes advantage of the RSD Proof of Bet (PoBet) system by calling its contract
regularly until it receives the prize given to senders. After, the amount received is then locked as liquidity with DSR
and SDR tokens.

In order to incentivize people to run the checkForProfit() function constantly, the DSR smart contract will reward the
function caller (sender) if the contract detects some claimable profit.

If you are considering to not invest on DSR at the moment, just remember you had acquired some tokens in the past only
with the 'promise' of their price going up. With DSR, even if the token price does not go up, you are earning passive
income, which eliminates some risk. In order to price goes down, someone besides you has to mint more DSR tokens to sell
them, and the only way to do this is by directly investing in the DSR smart contract, which implicates in more locked
liquidity and more money for the managers to invest...

Even if you are some of those investors which may choose to not take the risk of directly interacting with the contract
and having half of their investment locked in, you can opt for buy DSR from the DSR/FTM LP instead. This is also good,
once it will help to increase demand for the asset and push its price upforward. You still keep earning dividends for
your tokens, proportionally.

Additionally, investors also receive SDR tokens as reward for their investment. The SDR tokens received as reward are
previously sent to the DSR smart contract in the terms of the SDR token 'infinite farm system', which is a system
developed to reward investors who contribute to our platform (RSD + SDR + DSR) but without mint new SDR tokens.

System DeFi for Reference (SDR) is an utility token used for savings and additional functions, only exchangeable for
RSD and DSR. Reference System for DeFi (RSD) is an intelligent token with dynamic and elastic supply aimed for trading,
gambling and also to reward miners.
---------------------------------------------------------------------------------------

REVERT/REQUIRE CODE ERRORS:
DSR01: PoBet is tried only once at a time
DSR02: please refer you can call this function only once at a time until it is fully executed
DSR03: only managers can call this function
DSR04: manager was added already
DSR05: manager informed does not exist in this contract anymore
DSR06: the minimum amount of active managers is one
---------------------------------------------------------------------------------------
*/
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IReferenceSystemDeFi.sol";
import "./IDeFiSystemReference.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";
import "./IWETH.sol";
import "./IManager.sol";
import "./DsrHelper.sol";
import "hardhat/console.sol";

contract DeFiSystemReference is IDeFiSystemReference, Context, ERC20("DeFi System for Reference", "DSR"), Ownable {

	using SafeMath for uint256;

	bool private _isTryPoBet = false;
	bool private _isMintLocked = false;

	address public rsdTokenAddress;
	address public sdrTokenAddress;

	address public dsrHelperAddress;
	address payable public developerComissionAddress;

	address public dsrEthPair;
	address public dsrRsdPair;
	address public dsrSdrPair;
	address public rsdEthPair;
	address public sdrRsdPair;

	uint256 private _countProfit;
	uint256 private _lastBlockWithProfit;
	uint256 private _totalNumberOfBlocksForProfit;
	uint256 private _totalSupply;
	uint256 private constant _FACTOR = 10**18;
	uint256 private constant _MAGNITUDE = 2**128;

	uint256 public lastTotalProfit;
	uint256 public liquidityProfitShare = 6*(10**17); // 60.00%
	uint256 public liquidityInvestmentShare = 5*(10**17); // 50.00%
	uint256 public developerComissionRate = 1*(10**16); // 1.00%
	uint256 public checkerComissionRate = 2*(10**15); // 0.20%
	uint256 public dividendRate;
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
	event ProfitReceived(uint256 amount);

	modifier lockTryPoBet() {
		require(!_isTryPoBet, "DSR01");
		_isTryPoBet = true;
		_;
		_isTryPoBet = false;
	}

	modifier lockMint() {
		require(!_isMintLocked, "DSR02");
		_isMintLocked = true;
		_;
		_isMintLocked = false;
	}

	modifier onlyManager() {
		require(isManagerAdded(_msgSender()) || _msgSender() == owner(), "DSR03");
		_;
	}

	constructor(
		string memory name,
		string memory symbol) {
		_name = name;
		_symbol = symbol;
	}

	receive() external payable {
		if (_msgSender() != dsrHelperAddress)
			invest(_msgSender());
	}

	fallback() external payable {
		require(msg.data.length == 0);
		if (_msgSender() != dsrHelperAddress)
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
					// Transfer only profit or part of it for the desired amount
					_currentProfitSpent[sender] = _currentProfitSpent[sender].add(amount);
				} else {
					// Transfer all profit and part of balance for the desired amount
					uint256 spendableDifference = amount.sub(profitSpendable);
					_currentProfitSpent[sender] = _currentProfitSpent[sender].add(profitSpendable);
					_balances[sender] = _balances[sender].sub(spendableDifference);
					// Calculate new profit spent in order to allow the sender to continue participating in the next profit cycles, regularly
					_currentProfitSpent[sender] = potentialProfitPerAccount(sender);
				}
			} else {
				_balances[sender] = senderBalance.sub(amount);
			}

			// To avoid the recipient be able to spend an unavailable or inexistent profit we consider he already spent the current claimable profit
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

			checkForProfit();
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
				} else {
					uint256 spendableDifference = amount.sub(profitSpendable);
					_currentProfitSpent[account] = _currentProfitSpent[account].add(profitSpendable);
					_balances[account] = _balances[account].sub(spendableDifference);
					// Calculate new profit spent in order to allow the sender investor to continue participating in the next profit cycles
					_currentProfitSpent[account] = potentialProfitPerAccount(account);
				}
			} else {
				_balances[account] = burnBalance.sub(amount);
			}
			_totalSupply = _totalSupply.sub(amount);
			checkForProfit();
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

	function potentialBalanceOf(address account) public view returns(uint256) {
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
		) { return true; } catch { return false; }
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
	function _allocateProfit(bool mustChargeComission) private {
		uint256 profit = address(this).balance; // Assuming the profit was received as regular ETH instead of wrapped ETH

		// 1. Calculate the amounts
		uint256 checkComission = profit.mul(checkerComissionRate).div(_FACTOR);
		uint256 devComission = profit.mul(developerComissionRate).div(_FACTOR);
		uint256 liqLocked = profit.mul(liquidityProfitShare).div(_FACTOR);

		// 2. Separate the profit amount for checkers
		profit = profit.sub(checkComission);
		_chargeComissionCheck(checkComission);

		// 3. Pay commission for the developer team
		if (mustChargeComission) {
			profit = profit.sub(devComission);
			_chargeComissionDev(devComission);
		}

		// 4. Allocate resources for the DSR/ETH LP
		profit = profit.sub(liqLocked.div(2));
		(uint256 rate, bool isNormalRate) = _getDsrEthPoolRate();
		uint256 dsrForEthAmount = isNormalRate ? liqLocked.div(2).mul(rate) : liqLocked.div(2).div(rate); // DSR -> ETH
		_mint(address(this), dsrForEthAmount);
		_addLiquidityDsrEth(dsrForEthAmount, liqLocked.div(2)); // DSR + ETH

		// 5. Allocate resources for the DSR/RSD LP and DSR/SDR LP - ETH remaining used for liquidity
		profit = profit.sub(liqLocked.div(2));

		if (_swapEthForRsd(liqLocked.div(2)))
			DsrHelper(dsrHelperAddress).withdrawTokensSent(rsdTokenAddress);
		uint256 rsdAmount = _rsdToken.balanceOf(address(this));
		(rate, isNormalRate) = _getDsrRsdPoolRate();
		uint256 dsrForRsdAmount = isNormalRate ? rsdAmount.mul(rate) : rsdAmount.div(rate); // DSR -> RSD
		_mint(address(this), dsrForRsdAmount);
		_addLiquidityDsrRsd(dsrForRsdAmount, rsdAmount.div(2)); // DSR + RSD

		rsdAmount = _rsdToken.balanceOf(address(this));

		uint256 previousSdrAmount = _sdrToken.balanceOf(address(this));
		if (_swapRsdForSdr(rsdAmount))
			DsrHelper(dsrHelperAddress).withdrawTokensSent(sdrTokenAddress);
		uint256 currentSdrAmount = _sdrToken.balanceOf(address(this));
		uint256 sdrAmount = currentSdrAmount.sub(previousSdrAmount);
		(rate, isNormalRate) = _getDsrSdrPoolRate();
		uint256 dsrForSdrAmount = isNormalRate ? sdrAmount.mul(rate) : sdrAmount.div(rate); // DSR -> SDR
		_mint(address(this), dsrForSdrAmount);
		_addLiquidityDsrSdr(dsrForSdrAmount, sdrAmount); // DSR + SDR

		// 6. Allocate remaining resources for the Manager(s)
		if (managerAddresses.length > 0) {
			uint256 share = profit.div(managerAddresses.length);
			for (uint256 i = 0; i < managerAddresses.length; i++) {
				IManager manager = IManager(managerAddresses[i]);
				manager.receiveResources{value: share}();
			}
		}

		delete profit;
		delete checkComission;
		delete devComission;
		delete liqLocked;
		delete dsrForEthAmount;
		delete rsdAmount;
		delete dsrForRsdAmount;
		delete previousSdrAmount;
		delete currentSdrAmount;
		delete sdrAmount;
		delete dsrForSdrAmount;
	}

	// RESOURCE ALLOCATION STRATEGY - FOR INITIAL INVESTORS
	function _allocateResources() private {
		uint256 resources = address(this).balance;

		// 1. Calculate the amounts
		uint256 devComission = resources.mul(developerComissionRate).div(_FACTOR);
		uint256 mainLiquidity = resources.mul(liquidityInvestmentShare).div(_FACTOR);

		// 2. Pay commission of the developer team
		resources = resources.sub(devComission);
		_chargeComissionDev(devComission);

		// 3. Allocate resources for the DSR/ETH LP
		resources = resources.sub(mainLiquidity);
		(uint256 rate, bool isNormalRate) = _getDsrEthPoolRate();
		uint256 mainLiquidityValue = isNormalRate ? mainLiquidity.mul(rate) : mainLiquidity.div(rate);
		_mint(address(this), mainLiquidityValue);
		_addLiquidityDsrEth(balanceOf(address(this)), mainLiquidity);

		// 4. Allocate resources for the Manager(s)
		if (managerAddresses.length > 0) {
			uint256 share = resources.div(managerAddresses.length);
			for (uint256 i = 0; i < managerAddresses.length; i++) {
				IManager manager = IManager(managerAddresses[i]);
				manager.receiveResources{value: share}();
			}
		}

		delete resources;
		delete devComission;
		delete mainLiquidity;
	}

	function _calculateProfitPerBlock() private {
		uint256 currentProfit = totalProfit.sub(lastTotalProfit);
		if (currentProfit > 0) {
			uint256 currentNumberOfBlocksForProfit = block.number.sub(_lastBlockWithProfit);
			_countProfit = _countProfit.add(1);
			_totalNumberOfBlocksForProfit = _totalNumberOfBlocksForProfit.add(currentNumberOfBlocksForProfit);
			_lastBlockWithProfit = block.number;
		}
		lastTotalProfit = totalProfit;
	}

	function _chargeComissionCheck(uint256 amount) private {
		address payable checker = payable(_msgSender());
		checker.transfer(amount);
	}

	function _chargeComissionDev(uint256 amount) private {
		// check if the commission wallet is defined
		DsrHelper developerComissionWallet;
		if (developerComissionAddress == address(0)) {
			developerComissionWallet = new DsrHelper(owner());
			developerComissionAddress = payable(address(developerComissionWallet));
		}
		developerComissionAddress.transfer(amount);
	}

	function _getDsrEthPoolRate() private view returns(uint256, bool) {
		if (dsrEthPair == address(0)) {
			return (1, true);
		} else {
			uint256 dsrBalance = balanceOf(dsrEthPair) == 0 ? 1 : balanceOf(dsrEthPair);
			uint256 ethBalance = IERC20(address(_wEth)).balanceOf(dsrEthPair) == 0 ? 1: IERC20(address(_wEth)).balanceOf(dsrEthPair);
			if (dsrBalance >= ethBalance)
				return (dsrBalance.div(ethBalance), true);
			else
				return (ethBalance.div(dsrBalance), false);
		}
	}

	function _getDsrRsdPoolRate() private view returns(uint256, bool) {
		if (dsrRsdPair == address(0)) {
			return (1, true);
		} else {
			uint256 rsdBalance = _rsdToken.balanceOf(dsrRsdPair) == 0 ? 1 : _rsdToken.balanceOf(dsrRsdPair);
			uint256 dsrBalance = balanceOf(dsrRsdPair) == 0 ? 1 : balanceOf(dsrRsdPair);
			if (dsrBalance >= rsdBalance)
				return (dsrBalance.div(rsdBalance), true);
			else
				return (rsdBalance.div(dsrBalance), false);
		}
	}

	function _getDsrSdrPoolRate() private view returns(uint256, bool) {
		if (dsrSdrPair == address(0)) {
			return (1, true);
		} else {
			uint256 dsrBalance = balanceOf(dsrSdrPair) == 0 ? 1 : balanceOf(dsrSdrPair);
			uint256 sdrBalance = _sdrToken.balanceOf(dsrSdrPair) == 0 ? 1 : _sdrToken.balanceOf(dsrSdrPair);
			if (dsrBalance >= sdrBalance)
				return (dsrBalance.div(sdrBalance), true);
			else
				return (sdrBalance.div(dsrBalance), false);
		}
	}

	function _getRsdEthPoolRate() private view returns(uint256, bool) {
		if (rsdEthPair == address(0)) {
			return (1, true);
		} else {
			uint256 rsdBalance = _rsdToken.balanceOf(rsdEthPair) == 0 ? 1 : _rsdToken.balanceOf(rsdEthPair);
			uint256 ethBalance = IERC20(address(_wEth)).balanceOf(rsdEthPair) == 0 ? 1 : IERC20(address(_wEth)).balanceOf(rsdEthPair);
			if (rsdBalance >= ethBalance)
				return (rsdBalance.div(ethBalance), true);
			else
				return (ethBalance.div(rsdBalance), false);
		}
	}

	function _rewardSdrInfiniteFarm(address investor, uint256 amountInvested) private {
		uint256 sdrBalance = _sdrToken.balanceOf(address(this));
		if (sdrBalance > 0) {
			uint256 amountToReward = sdrBalance.mul(amountInvested).div(_totalSupply);
			_sdrToken.transfer(investor, amountToReward);
		}
	}

	function _swapEthForRsd(uint256 ethAmount) private returns(bool) {
		// need to check if the helper address is initialized
		DsrHelper dsrHelper;
		if (dsrHelperAddress == address(0)) {
			dsrHelper = new DsrHelper(address(this));
			dsrHelperAddress = address(dsrHelper);
		}

		_wEth.deposit{value: ethAmount}();

		// generate the pair path of ETH -> RSD on exchange router contract
		address[] memory path = new address[](2);
		path[0] = address(_wEth);
		path[1] = rsdTokenAddress;

		IERC20(address(_wEth)).approve(address(_exchangeRouter), ethAmount);

		try _exchangeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
		 	ethAmount,
			0, // accept any amount of RSD
			path,
			dsrHelperAddress,
			block.timestamp
		) { return true; } catch { return false; }
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

		_rsdToken.approve(address(_exchangeRouter), tokenAmount);

		try _exchangeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of DSR
			path,
			dsrHelperAddress,
			block.timestamp
		) { return true; } catch { return false; }
	}

	function _swapRsdForSdr(uint256 tokenAmount) private returns(bool) {
		// need to check if the helper address is initialized
		DsrHelper dsrHelper;
		if (dsrHelperAddress == address(0)) {
			dsrHelper = new DsrHelper(address(this));
			dsrHelperAddress = address(dsrHelper);
		}

		// generate the pair path of RSD -> SDR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = sdrTokenAddress;

		_rsdToken.approve(address(_exchangeRouter), tokenAmount);

		try _exchangeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of SDR
			path,
			dsrHelperAddress,
			block.timestamp
		) { return true; } catch { return false; }
	}

	function addManager(address manager) public onlyOwner {
		require(!isManagerAdded(manager), "DSR04");
		managerAddresses.push(manager);
	}

	function checkForProfit() public {
		for (uint256 i = 0; i < managerAddresses.length; i++) {
			IManager manager = IManager(managerAddresses[i]);
			manager.checkForProfit(); // It must check profit and call the receiveProfit() function after
		}
		_calculateProfitPerBlock();
	}

	function getAverageNumberOfBlocksForProfit() public view returns(uint256) {
		return (_countProfit == 0) ? _countProfit : _totalNumberOfBlocksForProfit.div(_countProfit);
	}

	function getAverageProfitPerBlock() public view returns(uint256) {
		return (_totalNumberOfBlocksForProfit == 0) ? _totalNumberOfBlocksForProfit : totalProfit.div(_totalNumberOfBlocksForProfit);
	}

	function getDividendYield() public view returns(uint256) {
		return (_totalSupply == 0) ? _totalSupply : (totalProfit.mul(_FACTOR).div(_totalSupply));
	}

	function getDividendYieldPerBlock() public view returns(uint256) {
		return (_totalNumberOfBlocksForProfit == 0) ? _totalNumberOfBlocksForProfit : getDividendYield().div(_totalNumberOfBlocksForProfit);
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

	function invest(address investor) public payable lockMint {
		if (msg.value > 0) {
			uint256 rate;
			bool isNormalRate;
			if (balanceOf(dsrEthPair) == 0 || dsrEthPair == address(0)) {
				(rate, isNormalRate) = _getRsdEthPoolRate();
				_lastBlockWithProfit = block.number;
			} else {
				(rate, isNormalRate) = _getDsrEthPoolRate();
			}
			uint256 amountInvested = isNormalRate ? (msg.value).mul(rate) : (msg.value).div(rate);
			_mint(investor, amountInvested);
			_rewardSdrInfiniteFarm(investor, amountInvested);
			_allocateResources();
		}
	}

	function isManagerAdded(address manager) public view returns(bool) {
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

	function receiveProfit(bool mustChargeComission) external virtual override payable onlyManager lockMint {
		if (msg.value > 0) {
			(uint256 rate, bool isNormalRate) = _getDsrEthPoolRate();
			uint256 value = isNormalRate ? (msg.value).mul(rate) : (msg.value).div(rate);
			dividendRate = dividendRate.add(value.mul(_MAGNITUDE).div(_totalSupply));
			totalProfit = totalProfit.add(value);
			_totalSupply = _totalSupply.add(value);

			_allocateProfit(mustChargeComission);
			emit ProfitReceived(value);

			delete rate;
			delete isNormalRate;
			delete value;
		}
	}

	function removeManager(address manager) public onlyOwner {
		require(isManagerAdded(manager), "DSR05");
		require(managerAddresses.length > 1, "DSR06");
		IManager(manager).withdrawInvestment();
		IManager(manager).setDsrTokenAddresss(address(0));
		address[] storage newManagerAddresses;
		for (uint256 i = 0; i < managerAddresses.length; i++) {
			if (manager != managerAddresses[i])
				newManagerAddresses.push(managerAddresses[i]);
		}
		managerAddresses = newManagerAddresses;
		_allocateResources();
	}

	function potentialProfitPerAccount(address account) public view returns(uint256) {
		return (_balances[account].mul(dividendRate).div(_MAGNITUDE));
	}

	// here the DSR token contract tries to earn some RSD tokens in the PoBet system. The earned amount is then locked in the DSR/RSD LP
	function tryPoBet() public lockTryPoBet {
		uint256 rsdBalance = _rsdToken.balanceOf(address(this));

		if (rsdBalance > 0)
			_rsdToken.transfer(obtainRandomWalletAddress(), 1);
		else
			_rsdToken.transfer(obtainRandomWalletAddress(), 0);

		// it means we have won the PoBet prize! Woo hoo! So, now we lock liquidity in DSR/RSD LP with this earned amount!
		if (rsdBalance < _rsdToken.balanceOf(address(this))) {
			uint256 earnedRsd = _rsdToken.balanceOf(address(this)).sub(rsdBalance);

			if (balanceOf(address(this)) == 0) {
				// DSR amount in DSR contract and in DSR/RSD LP is both 0. In this case we mint DSR and deposit initial liquidity into the DSR/RSD LP with the earned RSD from PoBet, with the corresponding amount of DSR following the rate of RSD in the RSD/ETH LP
				if (balanceOf(dsrRsdPair) == 0) {
					(uint256 rate, bool isNormalRate) = _getRsdEthPoolRate();
					uint256 earnedRsdValue = isNormalRate ? earnedRsd.mul(rate) : earnedRsd.div(rate);
					_mint(address(this), earnedRsdValue);
					_addLiquidityDsrRsd(balanceOf(address(this)), earnedRsd);
				} else {
					// DSR amount in DSR contract is 0, but we have some DSR in DSR/RSD LP. Here we buy DSR with half of earned RSD from PoBet and deposit them into the DSR/RSD LP
					if (_swapRsdForDsr(earnedRsd.div(2))) {
						DsrHelper(dsrHelperAddress).withdrawTokensSent(address(this));
						_addLiquidityDsrRsd(balanceOf(address(this)), earnedRsd.div(2));
					}
				}
			} else {
				// DSR contract has some DSR amount, but we don't have liquidity in DSR/RSD LP. So, we just add initial liquidity instead
				if (balanceOf(dsrRsdPair) == 0) {
					_addLiquidityDsrRsd(balanceOf(address(this)), earnedRsd);
				} else {
					// DSR contract has some DSR amount and there is liquidity in DSR/RSD LP. We need to check the rate of DSR/RSD pool before add liquidity in DSR/RSD LP
					(uint256 rate, bool isNormalRate) = _getDsrRsdPoolRate();
					uint256 earnedRsdValue = isNormalRate ? earnedRsd.div(2).mul(rate) : earnedRsd.div(2).div(rate);
					uint256 minAmount = earnedRsdValue > balanceOf(address(this)) ? balanceOf(address(this)) : earnedRsdValue;
					_addLiquidityDsrRsd(minAmount, earnedRsd.div(2));
				}
			}
		}
		// we also help to improve randomness of the RSD token contract after trying the PoBet system
		_rsdToken.generateRandomMoreThanOnce();
		delete rsdBalance;
	}

	function setCheckerComissionRate(uint256 comissionRate) public onlyOwner {
		checkerComissionRate = comissionRate;
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
