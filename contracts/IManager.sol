// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IManager {
	function checkForProfit() external;
	function queryPrice() external returns(uint256);
	function receiveResources(address from) external payable;
}
