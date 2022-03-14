// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";
import "./IWETH.sol";
import "hardhat/console.sol";

contract DsrHelper is Context, Ownable {

	address immutable internal dsrTokenAddress;
	address internal rsdTokenAddress;
	address internal sdrTokenAddress;
	IUniswapV2Router02 internal exchangeRouter;
	IWETH internal _wEth;

	modifier fromDsrToken {
		require(_msgSender() == dsrTokenAddress || _msgSender() == owner(), "DSR Helper: only DSR token contract can call this function");
		_;
	}

	constructor(address dsrTokenAddress_, address exchangeRouterAddress_, address rsdTokenAddress_, address sdrTokenAddress_) {
		dsrTokenAddress = dsrTokenAddress_;
		rsdTokenAddress = rsdTokenAddress_;
		sdrTokenAddress = sdrTokenAddress_;
		if (exchangeRouterAddress_ != address(0)) {
			IUniswapV2Router02 exchangeRouter_ = IUniswapV2Router02(exchangeRouterAddress_);
			exchangeRouter = exchangeRouter_;
			_wEth = IWETH(exchangeRouter.WETH());
		}
	}

	receive() external payable {
	}

	fallback() external payable {
		require(msg.data.length == 0);
	}

	function addLiquidityDsrEth(uint256 dsrTokenAmount) external payable fromDsrToken returns(bool) {
			IERC20(dsrTokenAddress).approve(address(exchangeRouter), dsrTokenAmount);
			// add the liquidity for DSR/ETH pair
			try exchangeRouter.addLiquidityETH{value: msg.value}(
					address(this),
					dsrTokenAmount,
					0, // slippage is unavoidable
					0, // slippage is unavoidable
					address(0),
					block.timestamp
			) { return true; } catch { return false; }
	}

	function addLiquidityDsrRsd(uint256 dsrTokenAmount) external fromDsrToken returns(bool) {
		uint256 rsdTokenAmount = IERC20(rsdTokenAddress).balanceOf(address(this));
		// approve token transfer to cover all possible scenarios
		IERC20(dsrTokenAddress).approve(address(exchangeRouter), dsrTokenAmount);
		IERC20(rsdTokenAddress).approve(address(exchangeRouter), rsdTokenAmount);
		// add the liquidity for DSR/RSD pair
		try exchangeRouter.addLiquidity(
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

	function addLiquidityDsrSdr(uint256 dsrTokenAmount) external fromDsrToken returns(bool) {
		uint256 sdrTokenAmount = IERC20(sdrTokenAddress).balanceOf(address(this));
		// approve token transfer to cover all possible scenarios
		IERC20(dsrTokenAddress).approve(address(exchangeRouter), dsrTokenAmount);
		IERC20(sdrTokenAddress).approve(address(exchangeRouter), sdrTokenAmount);

		// add the liquidity for DSR/SDR pair
		try exchangeRouter.addLiquidity(
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

	function getPoolRate(address pair, address asset01, address asset02) public view returns(uint256, bool) {
		if (pair == address(0)) {
			return (1, true);
		} else {
			uint256 balance01 = IERC20(asset01).balanceOf(pair) == 0 ? 1 : IERC20(asset01).balanceOf(pair);
			uint256 balance02 = IERC20(asset02).balanceOf(pair) == 0 ? 1 : IERC20(asset02).balanceOf(pair);
			if (balance01 >= balance02)
				return (balance01 / balance02, true);
			else
				return (balance02 / balance01, false);
		}
	}

	function swapEthForRsd(uint256 ethAmount) external virtual fromDsrToken returns(bool) {
		// generate the pair path of ETH -> RSD on exchange router contract
		address[] memory path = new address[](2);
		path[0] = address(_wEth);
		path[1] = rsdTokenAddress;

		try exchangeRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
			0, // accept any amount of RSD
			path,
			address(this),
			block.timestamp
		) { return true; } catch { return false; }
	}

	function swapRsdForDsr(uint256 tokenAmount) external fromDsrToken returns(bool) {
		// generate the pair path of RSD -> DSR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = address(this);

		IERC20(rsdTokenAddress).approve(address(exchangeRouter), tokenAmount);

		try exchangeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of DSR
			path,
			address(this),
			block.timestamp
		) { return true; } catch { return false; }
	}

	function swapRsdForSdr(uint256 tokenAmount) external fromDsrToken returns(bool) {
		// generate the pair path of RSD -> SDR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = sdrTokenAddress;

		IERC20(rsdTokenAddress).approve(address(exchangeRouter), tokenAmount);

		try exchangeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of SDR
			path,
			address(this),
			block.timestamp
		) { return true; } catch { return false; }
	}

	function setSdrTokenAddress(address sdrTokenAddress_) external fromDsrToken {
		sdrTokenAddress = sdrTokenAddress_;
	}

	function setRsdTokenAddress(address rsdTokenAddress_) external fromDsrToken {
		rsdTokenAddress = rsdTokenAddress_;
	}

	function withdrawTokensSent(address tokenAddress) external fromDsrToken {
		IERC20 token = IERC20(tokenAddress);
		if (token.balanceOf(address(this)) > 0)
			token.transfer(_msgSender(), token.balanceOf(address(this)));
	}

	function withdrawEthSent(address payable accountAddress) external fromDsrToken {
		accountAddress.transfer(address(this).balance);
	}
}
