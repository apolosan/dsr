// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";
import "./IUniswapV2Pair.sol";
import "./IWETH.sol";

contract DsrHelper is Context, Ownable {

	address internal dsrTokenAddress;
	address internal rsdTokenAddress;
	address internal sdrTokenAddress;
	address public exchangeRouterAddress;

	uint256 private constant FACTOR = 10**36;

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
		IERC20 dsr = IERC20(dsrTokenAddress);
		uint256 dsrTokenAmount = dsr.balanceOf(address(this));
		dsr.approve(exchangeRouterAddress, dsrTokenAmount);
		// add the liquidity for DSR/ETH pair
		try IUniswapV2Router02(exchangeRouterAddress).addLiquidityETH{value: msg.value}(
				address(dsr),
				dsrTokenAmount,
				0, // slippage is unavoidable
				0, // slippage is unavoidable
				address(0),
				block.timestamp+300
		) { return true; } catch { return false; }
	}

	function addLiquidityDsrRsd(bool halfRsd) external fromDsrToken returns(bool) {
		IERC20 dsr = IERC20(dsrTokenAddress);
		IERC20 rsd = IERC20(rsdTokenAddress);
		uint256 dsrTokenAmount = dsr.balanceOf(address(this));
		uint256 rsdTokenAmount = halfRsd ? rsd.balanceOf(address(this)) / 2 : rsd.balanceOf(address(this));
		// approve token transfer to cover all possible scenarios
		dsr.approve(exchangeRouterAddress, dsrTokenAmount);
		rsd.approve(exchangeRouterAddress, rsdTokenAmount);
		// add the liquidity for DSR/RSD pair
		try IUniswapV2Router02(exchangeRouterAddress).addLiquidity(
			address(dsr),
			address(rsd),
			dsrTokenAmount,
			rsdTokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			address(0),
			block.timestamp+300
		) { return true; } catch { return false; }
	}

	function addLiquidityDsrSdr() external fromDsrToken returns(bool) {
		IERC20 dsr = IERC20(dsrTokenAddress);
		IERC20 sdr = IERC20(sdrTokenAddress);
		uint256 dsrTokenAmount = dsr.balanceOf(address(this));
		uint256 sdrTokenAmount = sdr.balanceOf(address(this));
		// approve token transfer to cover all possible scenarios
		dsr.approve(exchangeRouterAddress, dsrTokenAmount);
		sdr.approve(exchangeRouterAddress, sdrTokenAmount);
		// add the liquidity for DSR/SDR pair
		try IUniswapV2Router02(exchangeRouterAddress).addLiquidity(
			address(dsr),
			address(sdr),
			dsrTokenAmount,
			sdrTokenAmount,
			0, // slippage is unavoidable
			0, // slippage is unavoidable
			address(0),
			block.timestamp+300
		) { return true; } catch { return false; }
	}

	function getPoolRate(address pair, address asset01, address asset02) public view returns(uint256) {
		uint256 balance01 = IERC20(asset01).balanceOf(pair);
		uint256 balance02 = IERC20(asset02).balanceOf(pair);
		if (pair == address(0)) {
			return FACTOR;
		} else {
			balance01 = balance01 == 0 ? 1 : balance01;
			balance02 = balance02 == 0 ? 1 : balance02;
			return ((balance01 * FACTOR) / balance02);
		}
	}

	function swapEthForRsd() external virtual fromDsrToken returns(bool) {
		IUniswapV2Router02 router = IUniswapV2Router02(exchangeRouterAddress);
		// generate the pair path of ETH -> RSD on exchange router contract
		address[] memory path = new address[](2);
		path[0] = router.WETH();
		path[1] = rsdTokenAddress;

		try router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: address(this).balance}(
			0, // accept any amount of RSD
			path,
			address(this),
			block.timestamp+300
		) { return true; } catch { return false; }
	}

	function swapRsdForDsr() external fromDsrToken returns(bool) {
		IERC20 rsd = IERC20(rsdTokenAddress);
		uint256 tokenAmount = rsd.balanceOf(address(this));
		// generate the pair path of RSD -> DSR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = dsrTokenAddress;

		rsd.approve(exchangeRouterAddress, tokenAmount);

		try IUniswapV2Router02(exchangeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of DSR
			path,
			address(this),
			block.timestamp+300
		) { return true; } catch { return false; }
	}

	function swapRsdForSdr() external fromDsrToken returns(bool) {
		IERC20 rsd = IERC20(rsdTokenAddress);
		uint256 tokenAmount = rsd.balanceOf(address(this));
		// generate the pair path of RSD -> SDR on exchange router contract
		address[] memory path = new address[](2);
		path[0] = rsdTokenAddress;
		path[1] = sdrTokenAddress;

		rsd.approve(exchangeRouterAddress, tokenAmount);

		try IUniswapV2Router02(exchangeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
			tokenAmount,
			0, // accept any amount of SDR
			path,
			address(this),
			block.timestamp+300
		) { return true; } catch { return false; }
	}

	function setDsrTokenAddress(address dsrTokenAddress_) external fromDsrToken {
		dsrTokenAddress = dsrTokenAddress_;
	}

	function setSdrTokenAddress(address sdrTokenAddress_) external fromDsrToken {
		sdrTokenAddress = sdrTokenAddress_;
	}

	function setRsdTokenAddress(address rsdTokenAddress_) external fromDsrToken {
		rsdTokenAddress = rsdTokenAddress_;
	}

	function withdrawTokensSent(address tokenAddress) external fromDsrToken {
		IERC20 token = IERC20(tokenAddress);
		uint256 balance = token.balanceOf(address(this));
		if (balance > 0)
			token.transfer(_msgSender(), balance);
	}

	function withdrawEthSent(address payable accountAddress) external fromDsrToken {
		accountAddress.transfer(address(this).balance);
	}
}
