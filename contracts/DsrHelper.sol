// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DsrHelper is Context {

	address immutable private dsrTokenAddress;

	modifier fromDsrToken {
		require(_msgSender() == dsrTokenAddress, "DSR Helper: only DSR token contract can call this function");
		_;
	}

	constructor(address dsrTokenAddress_) {
		dsrTokenAddress = dsrTokenAddress_;
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
