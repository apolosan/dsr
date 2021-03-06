// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IDeFiSystemReference {
	function receiveProfit(bool) external payable;
	function receiveOnlyForManagers() external payable;
}
