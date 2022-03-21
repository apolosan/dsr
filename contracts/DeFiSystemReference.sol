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
gambling and also to incentivize the crypto ecosystem by rewarding miners.
---------------------------------------------------------------------------------------

REVERT/REQUIRE CODE ERRORS:
DSR01: please refer you can call this function only once at a time until it is fully executed
DSR02: only managers can call this function
DSR03: manager was added already
DSR04: informed manager does not exist in this contract anymore
DSR05: the minimum amount of active managers is one
---------------------------------------------------------------------------------------
*/
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IReferenceSystemDeFi.sol";
import "./IDeFiSystemReference.sol";
import "./IWETH.sol";
import "./IManager.sol";
import "./DsrHelper.sol";

contract DeFiSystemReference is IDeFiSystemReference, Context, ERC20, Ownable {

	using SafeMath for uint256;

	bool private _isTryPoBet = false;
	bool private _isMintLocked = false;

	address public exchangeRouterAddress;
	address public rsdTokenAddress;
	address public sdrTokenAddress;

	address public dsrHelperAddress;
	address public developerComissionAddress;

	address public dsrEthPair;
	address public dsrRsdPair;
	address public dsrSdrPair;
	address public rsdEthPair;
	address public sdrRsdPair;

	uint256 private _countProfit;
	uint256 private _currentBlockCheck;
	uint256 private _currentBlockTryPoBet;
	uint256 private _lastBlockWithProfit;
	uint256 private _totalNumberOfBlocksForProfit;
	uint256 private _totalSupply;
	uint256 private constant _FACTOR = 10**18;
	uint256 private constant _MAGNITUDE = 2**128;

	uint256 public lastTotalProfit;
	uint256 public liquidityProfitShare = (60 * _FACTOR) / 100; // 60.00%
	uint256 public liquidityInvestmentShare = (50 * _FACTOR) / 100; // 50.00%
	uint256 public developerComissionRate = _FACTOR / 100; // 1.00%
	uint256 public checkerComissionRate = (2 * _FACTOR) / 1000; // 0.20%
	uint256 public dividendRate;
	uint256 public totalProfit;

	mapping (address => uint256) private _balances;
	mapping (address => uint256) private _currentProfitSpent;
	mapping (address => mapping (address => uint256)) private _allowances;

	address[] public managerAddresses;

	string private _name;
	string private _symbol;

	IWETH private _wEth;

	event Burn(address from, address zero, uint256 amount);
	event Mint(address zero, address account, uint256 amount);
	event ProfitReceived(uint256 amount);

	modifier lockMint() {
		require(!_isMintLocked, "DSR01");
		_isMintLocked = true;
		_;
		_isMintLocked = false;
	}

	constructor(
		string memory name,
		string memory symbol) ERC20(name, symbol) {
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
			uint256 potentialProfitPerAccount_ = potentialProfitPerAccount(sender);
			if (potentialProfitPerAccount_ > 0 && _currentProfitSpent[sender] < potentialProfitPerAccount_) {
				uint256 profitSpendable = potentialProfitPerAccount_.sub(_currentProfitSpent[sender]);
				if (amount <= profitSpendable) {
					// Transfer only profit or part of it for the desired amount
					_currentProfitSpent[sender] = _currentProfitSpent[sender].add(amount);
				} else {
					// Transfer all profit and part of balance for the desired amount
					uint256 spendableDifference = amount.sub(profitSpendable);
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
			emit Transfer(sender, recipient, amount);
	}

	function _mint(address account, uint256 amount) internal virtual override {
			require(account != address(0), "ERC20: mint to the zero address");

			_beforeTokenTransfer(address(0), account, amount);

			_totalSupply = _totalSupply.add(amount);
			_balances[account] = _balances[account].add(amount);
			// It cannot mint more amount than invested initially, even with profit
			_currentProfitSpent[account] = potentialProfitPerAccount(account);
			emit Mint(address(0), account, amount);
	}

	function _burn(address account, uint256 amount) internal virtual override {
			require(account != address(0), "ERC20: burn from the zero address");

			_beforeTokenTransfer(account, address(0), amount);

			uint256 burnBalance = balanceOf(account);
			require(burnBalance >= amount, "ERC20: burn amount exceeds balance");
			uint256 potentialProfitPerAccount_ = potentialProfitPerAccount(account);
			if (potentialProfitPerAccount_ > 0 && _currentProfitSpent[account] < potentialProfitPerAccount_) {
				uint256 profitSpendable = potentialProfitPerAccount_.sub(_currentProfitSpent[account]);
				if (amount <= profitSpendable) {
					_currentProfitSpent[account] = _currentProfitSpent[account].add(amount);
				} else {
					uint256 spendableDifference = amount.sub(profitSpendable);
					_balances[account] = _balances[account].sub(spendableDifference);
					// Calculate new profit spent in order to allow the sender investor to continue participating in the next profit cycles
					_currentProfitSpent[account] = potentialProfitPerAccount(account);
				}
			} else {
				_balances[account] = burnBalance.sub(amount);
			}
			_totalSupply = _totalSupply.sub(amount);
			emit Burn(account, address(0), amount);
	}

	function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
		tryPoBet(uint256(sha256(abi.encodePacked(from, to, amount))));
		checkForProfit();
	}

	function balanceOf(address account) public view virtual override returns (uint256) {
			if (account == address(this)
				|| account == dsrHelperAddress
				|| account == dsrEthPair
				|| account == dsrRsdPair
				|| account == dsrSdrPair)
				// DSR smart contracts and DSR Helper do not participate in the profit sharing
				return _balances[account];
			else
				return (potentialBalanceOf(account).sub(_currentProfitSpent[account]));
	}

	function potentialBalanceOf(address account) public view returns(uint256) {
		return _balances[account].add(potentialProfitPerAccount(account));
	}

	function totalSupply() public view virtual override returns(uint256) {
		return _totalSupply;
	}

	// RESOURCE ALLOCATION STRATEGY - FOR EARNED PROFIT
	function _allocateProfit(bool mustChargeComission) private {
		uint256 profit = address(this).balance; // Assuming the profit was received as regular ETH instead of wrapped ETH

		// 1. Calculate the amounts
		uint256 checkComission = profit.mul(checkerComissionRate).div(_FACTOR);
		uint256 devComission = profit.mul(developerComissionRate).div(_FACTOR);
		uint256 liqLocked = profit.mul(liquidityProfitShare).div(_FACTOR);

		// 2. Separate the profit amount for checkers
		if (!isManagerAdded(_msgSender())) {
			profit = profit.sub(checkComission);
			_chargeComissionCheck(checkComission);
		}

		// 3. Pay commission for the developer team
		if (mustChargeComission) {
			profit = profit.sub(devComission);
			_chargeComissionDev(devComission);
		}

		// 4. Allocate resources for the DSR/ETH LP
		profit = profit.sub(liqLocked.div(2));
		DsrHelper dsrHelper = DsrHelper(payable(dsrHelperAddress));
		(uint256 rate, bool isNormalRate) = dsrHelper.getPoolRate(dsrEthPair, address(this), address(_wEth));
		uint256 dsrForEthAmount = isNormalRate ? liqLocked.div(2).mul(rate) : liqLocked.div(2).div(rate); // DSR -> ETH
		_mint(dsrHelperAddress, dsrForEthAmount);
		if (!dsrHelper.addLiquidityDsrEth{value: liqLocked.div(2)}()) {
			_burn(dsrHelperAddress, dsrForEthAmount);
		} // DSR + ETH

		// 5. Allocate resources for the DSR/RSD LP and DSR/SDR LP - ETH remaining used for liquidity
		profit = profit.sub(liqLocked.div(2));
		payable(dsrHelperAddress).transfer(liqLocked.div(2));
		try dsrHelper.swapEthForRsd() {
			uint256 rsdAmount = IReferenceSystemDeFi(rsdTokenAddress).balanceOf(dsrHelperAddress).div(2);
			(rate, isNormalRate) = dsrHelper.getPoolRate(dsrRsdPair, address(this), rsdTokenAddress);
			uint256 dsrForRsdAmount = isNormalRate ? rsdAmount.mul(rate) : rsdAmount.div(rate); // DSR -> RSD
			_mint(dsrHelperAddress, dsrForRsdAmount);
			try dsrHelper.addLiquidityDsrRsd(true) { } catch {
				_burn(dsrHelperAddress, dsrForRsdAmount);
			} // DSR + RSD
		} catch { }

		if (dsrHelper.swapRsdForSdr()) {
			uint256 sdrAmount = IERC20(sdrTokenAddress).balanceOf(dsrHelperAddress);
			(rate, isNormalRate) = dsrHelper.getPoolRate(dsrSdrPair, address(this), sdrTokenAddress);
			uint256 dsrForSdrAmount = isNormalRate ? sdrAmount.mul(rate) : sdrAmount.div(rate); // DSR -> SDR
			_mint(dsrHelperAddress, dsrForSdrAmount);
			try dsrHelper.addLiquidityDsrSdr() { } catch {
				_burn(dsrHelperAddress, dsrForSdrAmount);
			} // DSR + SDR
		}

		// 6. Allocate remaining resources for the Manager(s)
		uint256 length_ = managerAddresses.length;
		if (length_ > 0) {
			uint256 share = profit.div(length_);
			for (uint256 i = 0; i < length_; i++) {
				try IManager(managerAddresses[i]).receiveResources{value: share}() { } catch { }
			}
		}
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
		uint256 rate;
		bool isNormalRate;
		DsrHelper dsrHelper = DsrHelper(payable(dsrHelperAddress));
		if (balanceOf(dsrEthPair) == 0 || dsrEthPair == address(0))
			(rate, isNormalRate) = dsrHelper.getPoolRate(rsdEthPair, rsdTokenAddress, address(_wEth));
		else
			(rate, isNormalRate) = dsrHelper.getPoolRate(dsrEthPair, address(this), address(_wEth));

		uint256 mainLiquidityValue = isNormalRate ? mainLiquidity.mul(rate) : mainLiquidity.div(rate);
		uint256 amountToDsrEth = balanceOf(address(this));
		uint256 diffToMint = amountToDsrEth > mainLiquidityValue ? amountToDsrEth - mainLiquidityValue : mainLiquidityValue - amountToDsrEth;
		_mint(dsrHelperAddress, diffToMint);
		if (amountToDsrEth > 0)
			_transfer(address(this), dsrHelperAddress, amountToDsrEth);
		dsrHelper.addLiquidityDsrEth{value: mainLiquidity}(); // DSR + ETH

		// 4. Allocate resources for the Manager(s)
		uint256 length_ = managerAddresses.length;
		if (length_ > 0) {
			uint256 share = resources.div(length_);
			for (uint256 i = 0; i < length_; i++) {
				try IManager(managerAddresses[i]).receiveResources{value: share}() { } catch { }
			}
		}
	}

	function _calculateProfitPerBlock() private {
		if (totalProfit.sub(lastTotalProfit) > 0) {
			_countProfit = _countProfit.add(1);
			_totalNumberOfBlocksForProfit = _totalNumberOfBlocksForProfit.add(block.number.sub(_lastBlockWithProfit));
			_lastBlockWithProfit = block.number;
		}
		lastTotalProfit = totalProfit;
	}

	function _chargeComissionCheck(uint256 amount) private {
		payable(_msgSender()).transfer(amount);
	}

	function _chargeComissionDev(uint256 amount) private {
		if (developerComissionAddress != address(0))
			payable(developerComissionAddress).transfer(amount);
	}

	function _rewardSdrInfiniteFarm(address investor, uint256 amountInvested) private {
		IERC20 sdr = IERC20(sdrTokenAddress);
		uint256 balanceSdr = sdr.balanceOf(address(this));
		if (balanceSdr > 0) {
			uint256 amountToReward = balanceSdr.mul(amountInvested).div(_totalSupply);
			try sdr.transfer(investor, amountToReward) { } catch { }
		}
	}

	function addManager(address manager) public onlyOwner {
		require(!isManagerAdded(manager), "DSR03");
		managerAddresses.push(manager);
	}

	function checkForProfit() public {
		if (_currentBlockCheck != block.number) {
			_currentBlockCheck = block.number;
			for (uint256 i = 0; i < managerAddresses.length; i++) {
				try IManager(managerAddresses[i]).checkForProfit() { } catch { } // It must check profit and call the receiveProfit() function after, but only if it does not revert, otherwise we should call it in the next block
			}
			_calculateProfitPerBlock();
		}
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
			address dsrHelperAddress_,
			address developerComissionAddress_,
			address exchangeRouterAddress_,
			address rsdTokenAddress_,
			address sdrTokenAddress_
		) public onlyOwner {
			dsrHelperAddress = dsrHelperAddress_;
			developerComissionAddress = developerComissionAddress_;
			exchangeRouterAddress = exchangeRouterAddress_;
			rsdTokenAddress = rsdTokenAddress_;
			sdrTokenAddress = sdrTokenAddress_;

			IUniswapV2Router02 router = IUniswapV2Router02(exchangeRouterAddress_);
			IUniswapV2Factory factory = IUniswapV2Factory(router.factory());
			_wEth = IWETH(router.WETH());

			dsrEthPair = factory.getPair(address(this), address(_wEth));
			if (dsrEthPair == address(0))
				dsrEthPair = factory.createPair(address(this), address(_wEth));

			dsrRsdPair = factory.getPair(address(this), rsdTokenAddress);
			if (dsrRsdPair == address(0))
				dsrRsdPair = factory.createPair(address(this), rsdTokenAddress);

			dsrSdrPair = factory.getPair(address(this), sdrTokenAddress);
			if (dsrSdrPair == address(0))
				dsrSdrPair = factory.createPair(address(this), sdrTokenAddress);

			rsdEthPair = factory.getPair(rsdTokenAddress, address(_wEth));
			if (rsdEthPair == address(0))
				rsdEthPair = factory.createPair(rsdTokenAddress, address(_wEth));

			sdrRsdPair = factory.getPair(sdrTokenAddress, rsdTokenAddress);
			if (sdrRsdPair == address(0))
				sdrRsdPair = factory.createPair(sdrTokenAddress, rsdTokenAddress);
	}

	function invest(address investor) public payable lockMint {
		if (msg.value > 0) {
			uint256 rate;
			bool isNormalRate;
			if (balanceOf(dsrEthPair) == 0 || dsrEthPair == address(0)) {
				(rate, isNormalRate) = DsrHelper(payable(dsrHelperAddress)).getPoolRate(rsdEthPair, rsdTokenAddress, address(_wEth));
				_lastBlockWithProfit = block.number;
			} else {
				(rate, isNormalRate) = DsrHelper(payable(dsrHelperAddress)).getPoolRate(dsrEthPair, address(this), address(_wEth));
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

	function obtainRandomWalletAddress(uint256 someNumber) public view returns(address) {
		address randomWalletAddress = address(bytes20(sha256(abi.encodePacked(
				block.timestamp,
				block.number,
				_totalSupply,
				msg.sender,
				IReferenceSystemDeFi(rsdTokenAddress).totalSupply(),
				someNumber
			))));
		return randomWalletAddress;
	}

	function receiveProfit(bool mustChargeComission) external virtual override payable lockMint {
		require(isManagerAdded(_msgSender()) || _msgSender() == owner(), "DSR02");
		if (msg.value > 0) {
			(uint256 rate, bool isNormalRate) = DsrHelper(payable(dsrHelperAddress)).getPoolRate(dsrEthPair, address(this), address(_wEth));
			uint256 value = isNormalRate ? (msg.value).mul(rate) : (msg.value).div(rate);
			dividendRate = dividendRate.add(value.mul(_MAGNITUDE).div(_totalSupply));
			totalProfit = totalProfit.add(value);
			_totalSupply = _totalSupply.add(value);

			_allocateProfit(mustChargeComission);
			emit ProfitReceived(value);
		}
	}

	function removeManager(address managerAddress) public onlyOwner {
		require(isManagerAdded(managerAddress), "DSR04");
		uint256 length_ = managerAddresses.length;
		require(length_ > 1, "DSR05");
		IManager manager = IManager(managerAddress);
		manager.withdrawInvestment();
		manager.setDsrTokenAddress(address(0));
		address[] memory newManagerAddresses = new address[](length_ - 1);
		uint256 j = 0;
		for (uint256 i = 0; i < length_; i++) {
			address mAddress = managerAddresses[i];
			if (managerAddress != mAddress) {
				newManagerAddresses[j] = mAddress;
				j++;
			}
		}
		managerAddresses = newManagerAddresses;
		_allocateResources();
	}

	function potentialProfitPerAccount(address account) public view returns(uint256) {
		if (account == address(this)
			|| account == dsrHelperAddress
			|| account == dsrEthPair
			|| account == dsrRsdPair
			|| account == dsrSdrPair)
			return 0;
		else
			return (_balances[account].mul(dividendRate).div(_MAGNITUDE));
	}

	// here the DSR token contract tries to earn some RSD tokens in the PoBet system. The earned amount is then locked in the DSR/RSD LP
	function tryPoBet(uint256 someNumber) public {
		if(!_isTryPoBet) {
			_isTryPoBet = true;
			if (_currentBlockTryPoBet != block.number) {
				IReferenceSystemDeFi rsd = IReferenceSystemDeFi(rsdTokenAddress);
				uint256 rsdBalance = rsd.balanceOf(address(this));
				try rsd.transfer(obtainRandomWalletAddress(someNumber), rsdBalance) {
					// it means we have won the PoBet prize! Woo hoo! So, now we lock liquidity in DSR/RSD LP with this earned amount!
					DsrHelper dsrHelper = DsrHelper(payable(dsrHelperAddress));
					uint256 newRsdBalance = rsd.balanceOf(address(this));
					if (rsdBalance < newRsdBalance) {
						uint256 earnedRsd = newRsdBalance.sub(rsdBalance);
						if (balanceOf(address(this)) == 0) {
							// DSR amount in DSR contract and in DSR/RSD LP is both 0. In this case we mint DSR and deposit initial liquidity into the DSR/RSD LP with the earned RSD from PoBet, with the corresponding amount of DSR following the rate of RSD in the RSD/ETH LP
							if (balanceOf(dsrRsdPair) == 0) {
								(uint256 rate, bool isNormalRate) = dsrHelper.getPoolRate(rsdEthPair, rsdTokenAddress, address(_wEth));
								uint256 earnedRsdValue = isNormalRate ? earnedRsd.mul(rate) : earnedRsd.div(rate);
								_mint(dsrHelperAddress, earnedRsdValue);
								rsd.transfer(dsrHelperAddress, earnedRsd);
								dsrHelper.addLiquidityDsrRsd(false);
							} else {
								// DSR amount in DSR contract is 0, but we have some DSR in DSR/RSD LP. Here we buy DSR with half of earned RSD from PoBet and deposit them into the DSR/RSD LP
								rsd.transfer(dsrHelperAddress, earnedRsd.div(2));
								if (dsrHelper.swapRsdForDsr()) {
									rsd.transfer(dsrHelperAddress, earnedRsd.div(2));
									dsrHelper.addLiquidityDsrRsd(false);
								}
							}
						} else {
							// DSR contract has some DSR amount, but we don't have liquidity in DSR/RSD LP. So, we just add initial liquidity instead
							if (balanceOf(dsrRsdPair) == 0) {
								_transfer(address(this), dsrHelperAddress, balanceOf(address(this)));
								rsd.transfer(dsrHelperAddress, earnedRsd);
								dsrHelper.addLiquidityDsrRsd(false);
							} else {
								// DSR contract has some DSR amount and there is liquidity in DSR/RSD LP. We need to check the rate of DSR/RSD pool before add liquidity in DSR/RSD LP
								(uint256 rate, bool isNormalRate) = dsrHelper.getPoolRate(dsrRsdPair, address(this), rsdTokenAddress);
								uint256 earnedRsdValue = isNormalRate ? earnedRsd.div(2).mul(rate) : earnedRsd.div(2).div(rate);
								uint256 balance = balanceOf(address(this));
								uint256 minAmount = earnedRsdValue > balance ? balance : earnedRsdValue;
								_transfer(address(this), dsrHelperAddress, minAmount);
								rsd.transfer(dsrHelperAddress, earnedRsd);
								dsrHelper.addLiquidityDsrRsd(false);
							}
						}
					}
				} catch { }
				// we also help to improve randomness of the RSD token contract after trying the PoBet system
				rsd.generateRandomMoreThanOnce();
				_currentBlockTryPoBet = block.number;
			}
			_isTryPoBet = false;
		}
	}

	function setCheckerComissionRate(uint256 comissionRate) public onlyOwner {
		checkerComissionRate = comissionRate;
	}

	function setDeveloperComissionRate(uint256 comissionRate) public onlyOwner {
		developerComissionRate = comissionRate;
	}

	function setSdrTokenAddress(address sdrTokenAddress_) public onlyOwner {
		sdrTokenAddress = sdrTokenAddress_;
		DsrHelper(payable(dsrHelperAddress)).setSdrTokenAddress(sdrTokenAddress_);
	}

	function setRsdTokenAddress(address rsdTokenAddress_) public onlyOwner {
		rsdTokenAddress = rsdTokenAddress_;
		DsrHelper(payable(dsrHelperAddress)).setSdrTokenAddress(rsdTokenAddress_);
	}
}
