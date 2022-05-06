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
DeFi System for Reference (DSR) is a multi-functional token that integrates the use of
automated financial managers to generate value for the token, for its holders, and
improve the system as a whole. The ecosystem triad now consists of RSD, SDR, and DSR.
Reference System for DeFi (RSD) is the utility token for the ecosystem with its dynamic
supply algorithm that can interact externally and internally within the ecosystem.
System DeFi for Reference (SDR) is the savings and functionality token only operational
within the system. DSR now brings an additional layer of value-added operations that
are unique and complementary to the whole system. As with the SDR and RSD tokens, DSR
is unique. The token's functionality employs a combination of automated functions to
generate internally and externally resourced value to token the while improving the
internal operational value to reward users and holders of the tokens. The token will
bring additional value to the token, its holders and users, and the entire RSD | SDR |
DSR ecosystem.

Tokenomics: The DSR token and its underlying value will have three major influences:
collateral, supply/demand and the external value generators. DSR will work to solve a
liquidity problem that occurs with many tokens. It takes advantage of a two part
system, tokens are only mintable (or unlocked) with an equitable amount of collateral
and a deposit into the external fund. This external fund is a potential source of
nearly constant (per block) profit creation and distribution to the contract and the
holders of DSR. DSR also brings an additional layer of value-added operations by
activating RSD and its functionality. The DSR contract also engages RSD's Proof of
Bet (PoBet) function, the DSR contract enables the automated generation of liquidity
by using the PoBet to reward itself RSD tokens and then mint DSR to be used to create
RSD/DSR liquidity on a designated exchange on each network (Pancakeswap / Spookyswap /
Quickswap / etc). This mechanism creates secondary and independent liquidity for RSD
holders.

Collateral: No DSR tokens will be created without native deposited into the smart
contract. The collateral is split into two sections. One is a pool of collateral that
operates as the foundation for the liquidity for DSR operation. The other is the
external manager fund. This collateral will be split between 'locked' (manager fund)
and 'liquid' (liquidity) portions. This collateral is one of the foundations for
maintaining a more valuable and less unstable token.

Supply/Demand: The individual users who interact with the DSR tokens will affect the
token price as with any other token. DSR will have a primary (interacting directly
with the contract) and the secondary market. DSR also uses the functionality built
into the RSD token. It calls PoBet from RSD on every transaction and if rewards are
received, DSR is paired with the earned RSD and sent to one of the network exchanges
to support RSD/DSR liquidity. So Buying, selling, exchanging, and other DSR activities
will have a secondary reward functionality, and provides a liquidity option for RSD
holders. Since the DSR minting is directly tied to collateral, the token should have
a solid base of value support and can build upon it with the actions of the automated
fund managers.

Externally Sourced Added Value: An excellent addition to DSR that is normally not seen
in other tokens beyond requiring collateral to mint and the automated liquidity creation
is the use of an external profit generation fund. Normal liquidity pairs have one
function to provide liquidity for a token's activity and transactions. DSR is different,
it employs all of the collateral to support and build the token. Beyond providing
liquidity for DSR activity, automated managers use the locked portion of collateral as
a fund that operates outside the ecosystem to generate additional sources of profit for
the token. When profits occur, these are sent back to the DSR contract as collateral to
mint new DSR token and then distributed across all DSR holders. Since the rewards are
collateralized, prior to distribution, this generates the rewards to the holders without
negatively affecting the value of the token...

The Automated Fund Managers: these are the autonomous functions built and deployed for
DSR. These manage the internal and external operations for the token, most importantly
the profit collection and distribution operations. Once deployed, the managers operate
autonomously. When available, these collect revenue from the fund operating on an
external finance platform, mint and distribute DSR. Nothing is constant in the crypto
universe, but these managers will be working to collect profit from outside the
ecosystem and bring the value into the ecosystem. Important note, any user can call
the profit function [checkForProfit()] and get part of a direct distribution, in the
form of native cryptocurrency into their wallet.

Obtaining DSR tokens: DSR is available in exchange for native tokens, RSD, and SDR
tokens. Native (layer 1 tokens)/DSR are the primary pair. RSD/DSR and SDR/DSR are other
exchange pairs. There are two primary collateral funds and the investor/users build
those funds by obtaining DSR. There are two methods to obtain the token: with and
without a 'locked' portion of the funds. The funds in either case use Layer 1 tokens.
The team will take a 1% commission from every initial investment.

The partially 'locked funds' method: The individual sends an amount of Layer 1 (native)
tokens, for example 100 MATIC to the contract. In this case, 1 Matic commission goes to
the team, then half (~49.5 MATIC) of the remaining value will be locked in the automated
manager fund. The other half (~49.5 MATIC) of the remaining value will be collateral to
mint DSR. The sender will receive 49.5 MATIC worth of DSR tokens plus and additional
amount of the 49.5 MATIC as incentive for interacting with the contract, which will be
immediately locked in his wallet. This ensures all minted tokens have collateral in the
contract. The locked DSR will be unlocked gradually and proportionally as managers'
profits are sent back to the contract. In addition, an amount of SDR tokens inside the
DSR contract will also be deposited in the individual's wallet representing a bonus from
the manager fund (as long as there are SDR funds remaining in the DSR contract fund).
The liquid portion will stay in the DSR contract to provide liquidity, the 'locked'
portion will be held in the automated manager fund for use by the fund managers for
profit generation.

The 'unlocked' method: This is primarily a secondary market exchange. The source of
these tokens will be holders of DSR, not the contract. The individual exchanges Layer 1
cryptocurrency for the DSR token on an exchange, just like with any direct exchange,
no additional bonus will be given. This will not "lock" any of the value of the exchanged
tokens to the individual. This method will not mint new DSR tokens and since this is a
secondary market transaction, it is subject to availability of DSR tokens on LPs. The
holders of the DSR token will start to earn DSR upon obtaining these secondary market at
the same rate as an initial investor.

Holding, and using DSR tokens: The holders of the DSR tokens only will begin to receive
continuous incremental rewards upon receiving their DSR tokens. The rewards will show up
as additional DSR tokens in the individual's wallet. The holders of 'locked funds' will
receive incremental awards in both their DSR and SDR tokens, since both provide incremental
"rewards". SDR rewards holders based on the community’s activity with SDR token's infinite
farm system. Due to the nature of the 'locked value', those holders will require additional
time to return to the initial value, however these holders will be generating rewards from
holding the DSR, locked DSR, and SDR tokens.

The Ecosystem Dynamics: The most unique part of the ecosystem in general, is that all of
the tokens are dynamic and have functionality built into each token. Activity-based supply
stability functionality (RSD), multiple tokens using PoBet functionality (RSD & DSR), the
'Infinite Farm' reward system (SDR), and now automated managers taking external profit,
building collateral and redistributing rewards to holders (DSR). No other ecosystem has
tokens built specifically to create value while being held and used.

Deployment: Initially DSR will be deployed on three networks. Binance Smart Chain (BSC),
Polygon (Matic/Poly), and Fantom (FTM) will have tokens with their automated manager smart
contracts deployed. The rollout to the other networks will happen shortly after as
additional automated manager smart contracts are tested and finalized. Based on activity
level, some networks will have multiple manager smart contracts, some will have only one
manager smart contract. Once DSR contracts are deployed on all the networks with RSD and
SDR, the team will be monitoring collateral and token activity levels to gauge the necessity
to expand the number of managers.
---------------------------------------------------------------------------------------

REVERT/REQUIRE CODE ERRORS:
DSR01: please refer you can call this function only once at a time until it is fully executed
DSR02: only managers can call this function
DSR03: manager was added already
DSR04: informed manager does not exist in this contract anymore
DSR05: the minimum amount of active managers is one
DSR06: direct investments in the contract are paused
DSR07: token is paused, please wait!
---------------------------------------------------------------------------------------
*/
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IReferenceSystemDeFi.sol";
import "./IWETH.sol";
import "./IManager.sol";
import "./IRManager.sol";
import "./DsrHelper.sol";

contract DeFiSystemReference is IERC20, Ownable {

    using SafeMath for uint256;

		bool private _isTryPoBet = false;
		bool private _isFirstMint = true;
		bool private _isMintLocked = false;
    bool private _areInvestmentsPaused = false;
    bool private _paused = false;

		address public exchangeRouterAddress;
		address private rsdTokenAddress;
		address private sdrTokenAddress;

		address public dsrHelperAddress;
		address public developerComissionAddress;

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
    uint256 private countInvestment;
		uint256 public totalProfit;

		mapping (address => uint256) private _balances;
		mapping (address => uint256) private _currentProfitSpent;
    mapping (address => uint256) private _lockedBalances;
		mapping (address => mapping (address => uint256)) private _allowances;

		address[] private managerAddresses;
    address[5] public assetPairs;

    string private _name;
    string private _symbol;

		IWETH private _wEth;

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
			if (msg.sender != dsrHelperAddress
          && msg.sender != assetPairs[0]
          && msg.sender != assetPairs[1]
          && msg.sender != assetPairs[2])
				invest(msg.sender);
    }

    fallback() external payable {
			require(msg.data.length == 0);
			if (msg.sender != dsrHelperAddress
          && msg.sender != assetPairs[0]
          && msg.sender != assetPairs[1]
          && msg.sender != assetPairs[2])
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

    function availableBalanceOf(address account) public view returns (uint256) {
      return _balances[account].add(potentialProfitPerAccount(account));
    }

    function balanceOf(address account) public view override returns (uint256) {
			if (account == address(this)
				|| account == dsrHelperAddress
				|| account == assetPairs[0]
				|| account == assetPairs[1]
				|| account == assetPairs[2])
				// DSR smart contracts and DSR Helper do not participate in the profit sharing
				return _balances[account];
			else
				return potentialBalanceOf(account);
    }

    function lockedBalanceOf(address account) public view returns (uint256) {
      if (account == address(this)
        || account == dsrHelperAddress
        || account == assetPairs[0]
        || account == assetPairs[1]
        || account == assetPairs[2])
        return _balances[account];
      else
        return (_lockedBalances[account]);
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

			uint256 senderBalance = availableBalanceOf(sender);
			require(senderBalance >= amount, "ERC20: transfer amount exceeds balance or there are funds locked");
			uint256 profitSpendable = potentialProfitPerAccount(sender);
			if (profitSpendable > 0) {
        // We now unlock some funds for that sender, since the contract now has provided enough liquidity from profit
        if (profitSpendable >= _lockedBalances[sender]) {
          _balances[sender] = _balances[sender].add(_lockedBalances[sender]);
          _lockedBalances[sender] = 0;
        } else {
          _balances[sender] = _balances[sender].add(profitSpendable);
          _lockedBalances[sender] = _lockedBalances[sender].sub(profitSpendable);
        }
				if (amount <= profitSpendable) {
					// Transfer only profit or part of it for the desired amount
					_currentProfitSpent[sender] = _currentProfitSpent[sender].add(amount);
				} else {
					// Transfer all profit and part of balance for the desired amount
					uint256 spendableDifference = amount.sub(profitSpendable);
					_balances[sender] = _balances[sender].sub(spendableDifference);
					// Calculate new profit spent in order to allow the sender to continue participating in the next profit cycles, regularly
					_currentProfitSpent[sender] = profitPerAccount(sender);
				}
			} else {
				_balances[sender] = senderBalance.sub(amount);
        _currentProfitSpent[sender] = profitPerAccount(sender);
			}

			// To avoid the recipient be able to spend an unavailable or inexistent profit we consider he already spent the current claimable profit
			// He will be able to earn profit in the next cycle, after the call of receiveProfit() function
			if (_balances[recipient] == 0) {
				_balances[recipient] = _balances[recipient].add(amount);
				_currentProfitSpent[recipient] = profitPerAccount(recipient);
			} else {
				uint256 previousSpendableProfitRecipient = profitPerAccount(recipient);
				_balances[recipient] = _balances[recipient].add(amount);
				uint256 currentSpendableProfitRecipient = profitPerAccount(recipient);
				_currentProfitSpent[recipient] = _currentProfitSpent[recipient].add(currentSpendableProfitRecipient.sub(previousSpendableProfitRecipient));
			}

			emit Transfer(sender, recipient, amount);
	    return true;
    }

    function _mint(address account, uint256 amount) internal virtual {
			require(account != address(0), "ERC20: mint to the zero address");

			_beforeTokenTransfer(address(0), account, amount);

			_totalSupply = _totalSupply.add(amount);
      if (account != address(this)
        && account != dsrHelperAddress
        && account != assetPairs[0]
        && account != assetPairs[1]
        && account != assetPairs[2]) {
			  _balances[account] = _balances[account].add(amount.div(2));
        _lockedBalances[account] = _lockedBalances[account].add(amount.div(2));
      } else {
        _balances[account] = _balances[account].add(amount);
      }
			// It cannot mint more amount than invested initially, even with profit
			_currentProfitSpent[account] = profitPerAccount(account);
			emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
			require(account != address(0), "ERC20: burn from the zero address");

			_beforeTokenTransfer(account, address(0), amount);

			uint256 burnBalance = availableBalanceOf(account);
			require(burnBalance >= amount, "ERC20: burn amount exceeds balance (allowed)");
			uint256 profitSpendable = potentialProfitPerAccount(account);
			if (profitSpendable > 0) {
        if (profitSpendable >= _lockedBalances[account]) {
          _balances[account] = _balances[account].add(_lockedBalances[account]);
          _lockedBalances[account] = 0;
        } else {
          _balances[account] = _balances[account].add(profitSpendable);
          _lockedBalances[account] = _lockedBalances[account].sub(profitSpendable);
        }
				if (amount <= profitSpendable) {
					_currentProfitSpent[account] = _currentProfitSpent[account].add(amount);
				} else {
					uint256 spendableDifference = amount.sub(profitSpendable);
          uint256 additionalDifference;
          if (spendableDifference > _balances[account]) {
            additionalDifference = spendableDifference.sub(_balances[account]);
            _balances[account] = 0;
            if (additionalDifference > _lockedBalances[account])
              _lockedBalances[account] = 0;
            else
              _lockedBalances[account] = _lockedBalances[account].sub(additionalDifference);
          } else {
					  _balances[account] = _balances[account].sub(spendableDifference);
          }
					_currentProfitSpent[account] = profitPerAccount(account);
				}
			} else {
				_balances[account] = burnBalance.sub(amount);
        _currentProfitSpent[account] = profitPerAccount(account);
			}
			_totalSupply = _totalSupply.sub(amount);
			emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
      require(!_paused, "DSR07: token is paused, please wait!");
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
			uint256 dsrForEthAmount = (liqLocked.div(2).mul(dsrHelper.getPoolRate(assetPairs[0], address(this), address(_wEth)))).div(_FACTOR); // DSR -> ETH
			_mint(dsrHelperAddress, dsrForEthAmount);
			if (!dsrHelper.addLiquidityDsrEth{value: liqLocked.div(2)}()) {
				_burn(dsrHelperAddress, dsrForEthAmount);
			} // DSR + ETH

			// 5. Allocate resources for the DSR/RSD LP and DSR/SDR LP - ETH remaining used for liquidity
			profit = profit.sub(liqLocked.div(2));
			payable(dsrHelperAddress).transfer(liqLocked.div(2));
			try dsrHelper.swapEthForRsd() {
				uint256 rsdAmount = IReferenceSystemDeFi(rsdTokenAddress).balanceOf(dsrHelperAddress).div(2);
				uint256 dsrForRsdAmount = (rsdAmount.mul(dsrHelper.getPoolRate(assetPairs[1], address(this), rsdTokenAddress))).div(_FACTOR); // DSR -> RSD
				_mint(dsrHelperAddress, dsrForRsdAmount);
				try dsrHelper.addLiquidityDsrRsd(true) { } catch {
					_burn(dsrHelperAddress, dsrForRsdAmount);
				} // DSR + RSD
			} catch { }

			if (dsrHelper.swapRsdForSdr()) {
				uint256 sdrAmount = IERC20(sdrTokenAddress).balanceOf(dsrHelperAddress);
				uint256 dsrForSdrAmount = (sdrAmount.mul(dsrHelper.getPoolRate(assetPairs[2], address(this), sdrTokenAddress))).div(_FACTOR); // DSR -> SDR
				_mint(dsrHelperAddress, dsrForSdrAmount);
				try dsrHelper.addLiquidityDsrSdr() { } catch {
					_burn(dsrHelperAddress, dsrForSdrAmount);
				} // DSR + SDR
			}

			// 6. Allocate remaining resources for the Manager(s)
      _allocateRemaining();
		}

    function _allocateRemaining() private {
      uint256 length_ = managerAddresses.length;
      if (length_ > 0) {
        uint256 share = address(this).balance.div(length_);
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
			if (balanceOf(assetPairs[0]) == 0 || assetPairs[0] == address(0))
				 rate = dsrHelper.getPoolRate(assetPairs[3], rsdTokenAddress, address(_wEth));
			else
			   rate = dsrHelper.getPoolRate(assetPairs[0], address(this), address(_wEth));

			uint256 mainLiquidityValue = (mainLiquidity.mul(rate)).div(_FACTOR);
			uint256 amountToDsrEth = balanceOf(address(this));
			uint256 diffToMint = amountToDsrEth > mainLiquidityValue ? amountToDsrEth - mainLiquidityValue : mainLiquidityValue - amountToDsrEth;
			_mint(dsrHelperAddress, diffToMint);
			if (amountToDsrEth > 0)
				_transfer(address(this), dsrHelperAddress, amountToDsrEth);
			try dsrHelper.addLiquidityDsrEth{value: mainLiquidity}() {
        uint256 balanceDsrHelper = balanceOf(dsrHelperAddress);
        if (balanceDsrHelper > 0)
          _burn(dsrHelperAddress, balanceDsrHelper);
      } catch {// DSR + ETH
        _burn(dsrHelperAddress, balanceOf(dsrHelperAddress));
      }

			// 3. Allocate resources for the Manager(s)
      _allocateRemaining();
		}

		function _calculateProfitPerBlock() private {
			if (totalProfit.sub(lastTotalProfit) > 0) {
				_countProfit++;
				_totalNumberOfBlocksForProfit = _totalNumberOfBlocksForProfit.add(block.number.sub(_lastBlockWithProfit));
				_lastBlockWithProfit = block.number;
			}
			lastTotalProfit = totalProfit;
		}

		function _chargeComissionCheck(uint256 amount) private {
			payable(tx.origin).transfer(amount);
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
				try sdr.transfer(investor, ((balanceSdr.div(5)).mul(amountInvested)).div(_totalSupply.div(countInvestment))) { } catch { }
			}
		}

		function addManager(address manager) public onlyOwner {
			require(!isManagerAdded(manager), "DSR03");
			managerAddresses.push(manager);
		}

    function allocateRemaining() public onlyOwner {
      _allocateRemaining();
    }

    function burn(uint256 amount) public {
      _burn(msg.sender, amount);
    }

		function checkForProfit() public {
			if (_currentBlockCheck != block.number) {
				_currentBlockCheck = block.number;
				for (uint256 i = 0; i < managerAddresses.length; i++) {
          // It must check profit and call the receiveProfit() function after, but only if it does not revert, otherwise we should call it in the next block
					try IManager(managerAddresses[i]).checkForProfit() { } catch { }
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

    function getRates(uint256 index) public view returns(uint256, uint256, uint256, uint256) {
      return IRManager(managerAddresses[index]).getRates();
    }

    function initializePair(address factoryAddress, address asset01, address asset02, uint256 index) public onlyOwner {
      IUniswapV2Factory factory = IUniswapV2Factory(factoryAddress);
      assetPairs[index] = factory.getPair(asset01, asset02);
      if (assetPairs[index] == address(0))
        assetPairs[index] = factory.createPair(asset01, asset02);
    }

		function invest(address investor) public payable lockMint {
      require(!_areInvestmentsPaused, "DSR06");
			if (msg.value > 0) {
				uint256 rate;
				if (balanceOf(assetPairs[0]) == 0 || assetPairs[0] == address(0)) {
					rate = DsrHelper(payable(dsrHelperAddress)).getPoolRate(assetPairs[3], rsdTokenAddress, address(_wEth));
					_lastBlockWithProfit = block.number;
				} else {
					rate = DsrHelper(payable(dsrHelperAddress)).getPoolRate(assetPairs[0], address(this), address(_wEth));
				}
				uint256 amountInvested = ((msg.value).mul(rate)).div(_FACTOR);
        amountInvested = amountInvested.sub((amountInvested.mul(developerComissionRate)).div(_FACTOR));
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
			return address(bytes20(sha256(abi.encodePacked(
					block.timestamp,
					block.number,
          block.difficulty,
          block.coinbase,
					_totalSupply,
					msg.sender,
					IReferenceSystemDeFi(rsdTokenAddress).totalSupply(),
					someNumber
				))));
		}

    function pauseInvestments() external onlyOwner {
      _areInvestmentsPaused = true;
    }

    function pauseTransactions() external onlyOwner {
      _paused = true;
    }

		function potentialBalanceOf(address account) public view returns(uint256) {
      return availableBalanceOf(account).add(_lockedBalances[account]);
		}

		function potentialProfitPerAccount(address account) public view returns(uint256) {
			if (account == address(this)
				|| account == dsrHelperAddress
				|| account == assetPairs[0]
				|| account == assetPairs[1]
				|| account == assetPairs[2]) {
				return 0;
			} else {
				return profitPerAccount(account).sub(_currentProfitSpent[account]);
      }
		}

    function profitPerAccount(address account) public view returns(uint256) {
      if (account == address(this)
        || account == dsrHelperAddress
        || account == assetPairs[0]
        || account == assetPairs[1]
        || account == assetPairs[2]) {
        return 0;
      } else {
        return (((_balances[account].add(_lockedBalances[account])).mul(dividendRate)).div(_MAGNITUDE));
      }
    }

    function receiveOnlyForManagers() external payable lockMint {
      require(isManagerAdded(msg.sender) || msg.sender == owner(), "DSR02");
      if (msg.value > 0)
        _allocateRemaining();
    }

		function receiveProfit(bool mustChargeComission) external virtual payable lockMint {
			require(isManagerAdded(msg.sender) || msg.sender == owner(), "DSR02");
			if (msg.value > 0) {
				uint256 value = ((msg.value).mul(DsrHelper(payable(dsrHelperAddress)).getPoolRate(assetPairs[0], address(this), address(_wEth)))).div(_FACTOR);
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
						if (assetPairs[1] != address(0)) {
							DsrHelper dsrHelper = DsrHelper(payable(dsrHelperAddress));
							uint256 newRsdBalance = rsd.balanceOf(address(this));
							// it means we have won the PoBet prize! Woo hoo! So, now we lock liquidity in DSR/RSD LP with this earned amount!
							if (rsdBalance < newRsdBalance) {
								uint256 earnedRsd = newRsdBalance.sub(rsdBalance);
                uint256 balanceDsr = balanceOf(address(this));
								if (balanceDsr == 0) {
                  rsd.transfer(dsrHelperAddress, earnedRsd);
                  earnedRsd = rsd.balanceOf(dsrHelperAddress);
                  if (balanceOf(assetPairs[1]) == 0) {
                    // We follow the rate of RSD in the RSD/ETH LP
                    _mint(dsrHelperAddress, earnedRsd);
									} else {
										// We follow the rate of DSR in the DSR/RSD LP
                    _mint(dsrHelperAddress, (earnedRsd.mul(dsrHelper.getPoolRate(assetPairs[1], address(this), rsdTokenAddress))).div(_FACTOR));
                  }
								} else {
                  uint256 dsrAmountToTransfer;
                  rsd.transfer(dsrHelperAddress, earnedRsd);
                  earnedRsd = rsd.balanceOf(dsrHelperAddress);
									if (balanceOf(assetPairs[1]) == 0) {
                    dsrAmountToTransfer = earnedRsd;
									} else {
                    dsrAmountToTransfer = (earnedRsd.mul(dsrHelper.getPoolRate(assetPairs[1], address(this), rsdTokenAddress))).div(_FACTOR);
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

    function setDeveloperComissionAddress(address developerComissionAddress_) external onlyOwner {
      developerComissionAddress = developerComissionAddress_;
    }

    function setDsrHelperAddress(address dsrHelperAddress_) external onlyOwner {
      dsrHelperAddress = dsrHelperAddress_;
    }

    function setExchangeRouter(address exchangeRouterAddress_) external onlyOwner {
      exchangeRouterAddress = exchangeRouterAddress_;
      IUniswapV2Router02 router = IUniswapV2Router02(exchangeRouterAddress_);
      _wEth = IWETH(router.WETH());
    }

		function setSdrTokenAddress(address sdrTokenAddress_) external onlyOwner {
			sdrTokenAddress = sdrTokenAddress_;
			DsrHelper(payable(dsrHelperAddress)).setSdrTokenAddress(sdrTokenAddress_);
		}

		function setRsdTokenAddress(address rsdTokenAddress_) external onlyOwner {
			rsdTokenAddress = rsdTokenAddress_;
			DsrHelper(payable(dsrHelperAddress)).setSdrTokenAddress(rsdTokenAddress_);
		}

    function unpauseInvestments() external onlyOwner {
      _areInvestmentsPaused = false;
    }

    function unpauseTransactions() external onlyOwner {
      _paused = false;
    }
}
