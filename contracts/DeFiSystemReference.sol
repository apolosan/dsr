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
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IReferenceSystemDeFi.sol";
import "./IWETH.sol";
import "./IManager.sol";
import "./DsrHelper.sol";

contract DeFiSystemReference is IERC20, Ownable {

    using SafeMath for uint256;

		bool private _isTryPoBet = false;
		bool private _isFirstMint = true;
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

    uint8 private _decimals = 18;
    uint256 private _totalSupply;

		uint256 private _countProfit;
		uint256 private _currentBlockCheck;
		uint256 private _currentBlockTryPoBet;
		uint256 private _lastBlockWithProfit;
		uint256 private _totalNumberOfBlocksForProfit;
		uint256 private constant _FACTOR = 10**36;
		uint256 private constant _MAGNITUDE = 2**128;

		uint256 private lastTotalProfit;
		uint256 private constant liquidityProfitShare = (60 * _FACTOR) / 100; // 60.00%
		uint256 private developerComissionRate = _FACTOR / 100; // 1.00%
		uint256 private checkerComissionRate = (2 * _FACTOR) / 1000; // 0.20%
		uint256 private dividendRate;
    uint256 public countInvestment;
		uint256 public totalProfit;

		mapping (address => uint256) private _balances;
		mapping (address => uint256) private _currentProfitSpent;
		mapping (address => mapping (address => uint256)) private _allowances;

		address[] private managerAddresses;

    string private _name;
    string private _symbol;

		IWETH private _wEth;

		event Burn(address from, address zero, uint256 amount);
		event ProfitReceived(uint256 amount);

		modifier lockMint() {
			require(!_isMintLocked, "DSR01");
			_isMintLocked = true;
			_;
			_isMintLocked = false;
		}

    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
				_mint(address(this), 1);
				_isFirstMint = false;
    }

    receive() external payable {
			if (msg.sender != dsrHelperAddress)
				invest(msg.sender);
    }

    fallback() external payable {
			require(msg.data.length == 0);
			if (msg.sender != dsrHelperAddress)
				invest(msg.sender);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
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

    function transfer(address recipient, uint256 amount) public virtual override returns (bool success) {
        success = _transfer(msg.sender, recipient, amount);
        return success;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool success) {
        success = _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return success;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual returns (bool success) {
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
        // Calculate new profit spent in order to allow the sender to continue participating in the next profit cycles, regularly
        _currentProfitSpent[sender] = potentialProfitPerAccount(sender);
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
	    return true;
    }

    function _mint(address account, uint256 amount) internal virtual {
			require(account != address(0), "ERC20: mint to the zero address");

			_beforeTokenTransfer(address(0), account, amount);

			_totalSupply = _totalSupply.add(amount);
			_balances[account] = _balances[account].add(amount);
			// It cannot mint more amount than invested initially, even with profit
			_currentProfitSpent[account] = potentialProfitPerAccount(account);
			emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
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
        _currentProfitSpent[account] = potentialProfitPerAccount(account);
			}
			_totalSupply = _totalSupply.sub(amount);
			emit Burn(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
      checkForProfit();
			tryPoBet(uint256(sha256(abi.encodePacked(from, to, amount))));
    }

		// RESOURCE ALLOCATION STRATEGY - FOR EARNED PROFIT
		function _allocateProfit(bool mustChargeComission) private {
			uint256 profit = address(this).balance; // Assuming the profit was received as regular ETH instead of wrapped ETH

			// 1. Calculate the amounts
			uint256 checkComission = (profit.mul(checkerComissionRate)).div(_FACTOR);
			uint256 devComission = (profit.mul(developerComissionRate)).div(_FACTOR);
			uint256 liqLocked = (profit.mul(liquidityProfitShare)).div(_FACTOR);

			// 2. Separate the profit amount for checkers
			if (!isManagerAdded(msg.sender)) {
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
			uint256 dsrForEthAmount = (liqLocked.div(2).mul(dsrHelper.getPoolRate(dsrEthPair, address(this), address(_wEth)))).div(_FACTOR); // DSR -> ETH
			_mint(dsrHelperAddress, dsrForEthAmount);
			if (!dsrHelper.addLiquidityDsrEth{value: liqLocked.div(2)}()) {
				_burn(dsrHelperAddress, dsrForEthAmount);
			} // DSR + ETH

			// 5. Allocate resources for the DSR/RSD LP and DSR/SDR LP - ETH remaining used for liquidity
			profit = profit.sub(liqLocked.div(2));
			payable(dsrHelperAddress).transfer(liqLocked.div(2));
			try dsrHelper.swapEthForRsd() {
				uint256 rsdAmount = IReferenceSystemDeFi(rsdTokenAddress).balanceOf(dsrHelperAddress).div(2);
				uint256 dsrForRsdAmount = (rsdAmount.mul(dsrHelper.getPoolRate(dsrRsdPair, address(this), rsdTokenAddress))).div(_FACTOR); // DSR -> RSD
				_mint(dsrHelperAddress, dsrForRsdAmount);
				try dsrHelper.addLiquidityDsrRsd(true) { } catch {
					_burn(dsrHelperAddress, dsrForRsdAmount);
				} // DSR + RSD
			} catch { }

			if (dsrHelper.swapRsdForSdr()) {
				uint256 sdrAmount = IERC20(sdrTokenAddress).balanceOf(dsrHelperAddress);
				uint256 dsrForSdrAmount = (sdrAmount.mul(dsrHelper.getPoolRate(dsrSdrPair, address(this), sdrTokenAddress))).div(_FACTOR); // DSR -> SDR
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
          if (msg.sender != managerAddresses[i]) {
					       try IManager(managerAddresses[i]).receiveResources{value: share}() { } catch { }
          }
				}
			}
		}

		// RESOURCE ALLOCATION STRATEGY - FOR INITIAL INVESTORS
		function _allocateResources() private {
			uint256 resources = address(this).balance;

			// 1. Calculate developer team comission and pay it
			uint256 devComission = (resources.mul(developerComissionRate)).div(_FACTOR);
			resources = resources.sub(devComission);
			_chargeComissionDev(devComission);

			// 2. Allocate resources for the DSR/ETH LP
      uint256 mainLiquidity = resources.div(2);
			resources = resources.sub(mainLiquidity);
			uint256 rate;
			DsrHelper dsrHelper = DsrHelper(payable(dsrHelperAddress));
			if (balanceOf(dsrEthPair) == 0 || dsrEthPair == address(0))
				 rate = dsrHelper.getPoolRate(rsdEthPair, rsdTokenAddress, address(_wEth));
			else
			   rate = dsrHelper.getPoolRate(dsrEthPair, address(this), address(_wEth));

			uint256 mainLiquidityValue = (mainLiquidity.mul(rate)).div(_FACTOR);
			uint256 amountToDsrEth = balanceOf(address(this));
			uint256 diffToMint = amountToDsrEth > mainLiquidityValue ? amountToDsrEth - mainLiquidityValue : mainLiquidityValue - amountToDsrEth;
			_mint(dsrHelperAddress, diffToMint);
			if (amountToDsrEth > 0)
				_transfer(address(this), dsrHelperAddress, amountToDsrEth);
			dsrHelper.addLiquidityDsrEth{value: mainLiquidity}(); // DSR + ETH

			// 3. Allocate resources for the Manager(s)
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
			payable(msg.sender).transfer(amount);
		}

		function _chargeComissionDev(uint256 amount) private {
			if (developerComissionAddress != address(0))
				payable(developerComissionAddress).transfer(amount);
		}

    function _detachManager(address managerAddress) private {
      require(isManagerAdded(managerAddress), "DSR04");
      uint256 length_ = managerAddresses.length;
      require(length_ > 1, "DSR05");
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
    }

		function _rewardSdrInfiniteFarm(address investor, uint256 amountInvested) private {
			IERC20 sdr = IERC20(sdrTokenAddress);
			uint256 balanceSdr = sdr.balanceOf(address(this));
			if (balanceSdr > 0) {
				uint256 amountToReward = ((balanceSdr.div(5)).mul(amountInvested)).div(_totalSupply.div(countInvestment));
				try sdr.transfer(investor, amountToReward) { } catch { }
			}
		}

		function addManager(address manager) public onlyOwner {
			require(!isManagerAdded(manager), "DSR03");
			managerAddresses.push(manager);
		}

    function burn(uint256 amount) public {
      _burn(msg.sender, amount);
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

    function detachManager(address managerAddress) public onlyOwner {
      _detachManager(managerAddress);
    }

		function getAverageNumberOfBlocksForProfit() public view returns(uint256) {
			return (_countProfit == 0) ? _countProfit : _totalNumberOfBlocksForProfit.div(_countProfit);
		}

		function getAverageProfitPerBlock() public view returns(uint256) {
			return (_totalNumberOfBlocksForProfit == 0) ? _totalNumberOfBlocksForProfit : totalProfit.div(_totalNumberOfBlocksForProfit);
		}

		function getDividendYield() public view returns(uint256) {
			return (_totalSupply == 0) ? _totalSupply : ((totalProfit.mul(_FACTOR)).div(_totalSupply));
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
				if (balanceOf(dsrEthPair) == 0 || dsrEthPair == address(0)) {
					rate = DsrHelper(payable(dsrHelperAddress)).getPoolRate(rsdEthPair, rsdTokenAddress, address(_wEth));
					_lastBlockWithProfit = block.number;
				} else {
					rate = DsrHelper(payable(dsrHelperAddress)).getPoolRate(dsrEthPair, address(this), address(_wEth));
				}
				uint256 amountInvested = ((msg.value).mul(rate)).div(_FACTOR);
        amountInvested = amountInvested.sub((amountInvested.mul(developerComissionRate)).div(_FACTOR));
        amountInvested = amountInvested.div(2);
				_mint(investor, amountInvested);
        countInvestment++;
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
          block.difficulty,
          block.coinbase,
					_totalSupply,
					msg.sender,
					IReferenceSystemDeFi(rsdTokenAddress).totalSupply(),
					someNumber
				))));
			return randomWalletAddress;
		}

		function potentialBalanceOf(address account) public view returns(uint256) {
			return _balances[account].add(potentialProfitPerAccount(account));
		}

		function potentialProfitPerAccount(address account) public view returns(uint256) {
			if (account == address(this)
				|| account == dsrHelperAddress
				|| account == dsrEthPair
				|| account == dsrRsdPair
				|| account == dsrSdrPair) {
				return 0;
			} else {
				return (_balances[account].mul(dividendRate).div(_MAGNITUDE));
      }
		}

		function receiveProfit(bool mustChargeComission) external virtual payable lockMint {
			require(isManagerAdded(msg.sender) || msg.sender == owner(), "DSR02");
			if (msg.value > 0) {
				uint256 value = ((msg.value).mul(DsrHelper(payable(dsrHelperAddress)).getPoolRate(dsrEthPair, address(this), address(_wEth)))).div(_FACTOR);
				dividendRate = dividendRate.add((value.mul(_MAGNITUDE)).div(_totalSupply));
				totalProfit = totalProfit.add(value);
				_totalSupply = _totalSupply.add(value);

				_allocateProfit(mustChargeComission);
				emit ProfitReceived(value);
			}
		}

		function removeManager(address managerAddress) external onlyOwner {
      IManager manager = IManager(managerAddress);
      manager.withdrawInvestment();
      manager.setDsrTokenAddress(address(0));
      _detachManager(managerAddress);
		}

		// here the DSR token contract tries to earn some RSD tokens in the PoBet system. The earned amount is then locked in the DSR/RSD LP
		function tryPoBet(uint256 someNumber) public {
			if(!_isTryPoBet && !_isFirstMint) {
				_isTryPoBet = true;
				if (_currentBlockTryPoBet != block.number) {
					_currentBlockTryPoBet = block.number;
					IReferenceSystemDeFi rsd = IReferenceSystemDeFi(rsdTokenAddress);
					uint256 rsdBalance = rsd.balanceOf(address(this));
					try rsd.transfer(obtainRandomWalletAddress(someNumber), rsdBalance) {
						if (dsrRsdPair != address(0)) {
							DsrHelper dsrHelper = DsrHelper(payable(dsrHelperAddress));
							uint256 newRsdBalance = rsd.balanceOf(address(this));
							// it means we have won the PoBet prize! Woo hoo! So, now we lock liquidity in DSR/RSD LP with this earned amount!
							if (rsdBalance < newRsdBalance) {
								uint256 earnedRsd = newRsdBalance.sub(rsdBalance);
                uint256 dsrAmountToMint;
                uint256 balanceDsr = balanceOf(address(this));
								if (balanceDsr == 0) {
                  rsd.transfer(dsrHelperAddress, earnedRsd);
                  earnedRsd = rsd.balanceOf(dsrHelperAddress);
                  if (balanceOf(dsrRsdPair) == 0) {
                    // We follow the rate of RSD in the RSD/ETH LP
                    dsrAmountToMint = earnedRsd;
									} else {
										// We follow the rate of DSR in the DSR/RSD LP
                    dsrAmountToMint = (earnedRsd.mul(dsrHelper.getPoolRate(dsrRsdPair, address(this), rsdTokenAddress))).div(_FACTOR);
                  }
                  _mint(dsrHelperAddress, dsrAmountToMint);
								} else {
                  uint256 dsrAmountToTransfer;
                  rsd.transfer(dsrHelperAddress, earnedRsd);
                  earnedRsd = rsd.balanceOf(dsrHelperAddress);
									if (balanceOf(dsrRsdPair) == 0) {
                    dsrAmountToTransfer = earnedRsd;
									} else {
                    dsrAmountToTransfer = (earnedRsd.mul(dsrHelper.getPoolRate(dsrRsdPair, address(this), rsdTokenAddress))).div(_FACTOR);
                  }
                  _transfer(address(this), dsrHelperAddress, balanceDsr);
                  if (dsrAmountToTransfer > balanceDsr)
                    _mint(dsrHelperAddress, (dsrAmountToTransfer - balanceDsr));
								}
                dsrHelper.addLiquidityDsrRsd(false);
						  }
            }
					} catch { }
					// we also help to improve randomness of the RSD token contract after trying the PoBet system
					rsd.generateRandomMoreThanOnce();
				}
				_isTryPoBet = false;
			}
		}

		function setCheckerComissionRate(uint256 comissionRate) external onlyOwner {
			checkerComissionRate = comissionRate;
		}

		function setDeveloperComissionRate(uint256 comissionRate) external onlyOwner {
			developerComissionRate = comissionRate;
		}

		function setSdrTokenAddress(address sdrTokenAddress_) external onlyOwner {
			sdrTokenAddress = sdrTokenAddress_;
			DsrHelper(payable(dsrHelperAddress)).setSdrTokenAddress(sdrTokenAddress_);
		}

		function setRsdTokenAddress(address rsdTokenAddress_) external onlyOwner {
			rsdTokenAddress = rsdTokenAddress_;
			DsrHelper(payable(dsrHelperAddress)).setSdrTokenAddress(rsdTokenAddress_);
		}
}
