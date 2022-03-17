// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";
import "./IWETH.sol";

contract DsrHelper is Context, Ownable {

	address immutable internal dsrTokenAddress;
	address internal rsdTokenAddress;
	address internal sdrTokenAddress;
	address internal exchangeRouterAddress;

	modifier fromDsrToken {
		require(_msgSender() == dsrTokenAddress || _msgSender() == owner(), "DSR Helper: only DSR token contract can call this function");
		_;
	}

	constructor(address dsrTokenAddress_, address exchangeRouterAddress_, address rsdTokenAddress_, address sdrTokenAddress_) {
		dsrTokenAddress = dsrTokenAddress_;
		exchangeRouterAddress = exchangeRouterAddress_;
		rsdTokenAddress = rsdTokenAddress_;
		sdrTokenAddress = sdrTokenAddress_;
	}

	receive() external payable {
	}

	fallback() external payable {
		require(msg.data.length == 0);
	}

	function addLiquidityDsrEth() external payable fromDsrToken returns(bool) {
			uint256 dsrTokenAmount = IERC20(dsrTokenAddress).balanceOf(address(this));
			IERC20(dsrTokenAddress).approve(exchangeRouterAddress, dsrTokenAmount);
			// add the liquidity for DSR/ETH pair
			try IUniswapV2Router02(exchangeRouterAddress).addLiquidityETH{value: msg.value}(
					dsrTokenAddress,
					dsrTokenAmount,
					0, // slippage is unavoidable
					0, // slippage is unavoidable
					address(0),
					block.timestamp
			) { return true; } catch { return false; }
	}

	function addLiquidityDsrRsd(bool halfRsd) external fromDsrToken returns(bool) {
		uint256 dsrTokenAmount = IERC20(dsrTokenAddress).balanceOf(address(this));
		uint256 rsdTokenAmount = halfRsd ? IERC20(rsdTokenAddress).balanceOf(address(this)) / 2 : IERC20(rsdTokenAddress).balanceOf(address(this));
		// approve token transfer to cover all possible scenarios
		IERC20(dsrTokenAddress).approve(exchangeRouterAddress, dsrTokenAmount);
		IERC20(rsdTokenAddress).approve(exchangeRouterAddress, rsdTokenAmount);
		// add the liquidity for DSR/RSD pair
		try IUniswapV2Router02(exchangeRouterAddress).addLiquidity(
			dsrTokenAddress,
			rsdTokenAddress,
			dsrTokenAmount,
			rsdTokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			address(0),
			block.timestamp
		) { return true; } catch { return false; }
	}

	function addLiquidityDsrSdr() external fromDsrToken returns(bool) {
		uint256 dsrTokenAmount = IERC20(dsrTokenAddress).balanceOf(address(this));
		uint256 sdrTokenAmount = IERC20(sdrTokenAddress).balanceOf(address(this));
		// approve token transfer to cover all possible scenarios
		IERC20(dsrTokenAddress).approve(exchangeRouterAddress, dsrTokenAmount);
		IERC20(sdrTokenAddress).approve(exchangeRouterAddress, sdrTokenAmount);
		// add the liquidity for DSR/SDR pair
		try IUniswapV2Router02(exchangeRouterAddress).addLiquidity(
			dsrTokenAddress,
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

	function swapEthForRsd() external virtual fromDsrToken returns(bool) {
		uint256 ethAmount = address(this).balance;
		// generate the pair path of ETH -> RSD on exchange router contract
		address[] memory path = new address[](2);
		path[0] = IUniswapV2Router02(exchangeRouterAddress).WETH();
		path[1] = rsdTokenAddress;

		try IUniswapV2Router02(exchangeRouterAddress).swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
			0, // accept any amount of RSD
			path,
			address(this),
			block.timestamp
		) { return true; } catch { return false; }
	}

	function swapRsdForDsr() external fromDsrToken returns(bool) {
		uint256 tokenAmount = IERC20(rsdTokenAddress).balanceOf(address(this));
		// generate the pair path of RSD -> DSR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = dsrTokenAddress;

		IERC20(rsdTokenAddress).approve(exchangeRouterAddress, tokenAmount);

		try IUniswapV2Router02(exchangeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of DSR
			path,
			address(this),
			block.timestamp
		) { return true; } catch { return false; }
	}

	function swapRsdForSdr() external fromDsrToken returns(bool) {
		uint256 tokenAmount = IERC20(rsdTokenAddress).balanceOf(address(this));
		// generate the pair path of RSD -> SDR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = sdrTokenAddress;

		IERC20(rsdTokenAddress).approve(exchangeRouterAddress, tokenAmount);

		try IUniswapV2Router02(exchangeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
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
