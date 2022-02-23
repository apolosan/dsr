// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IManager {
	function checkForProfit() external;
	function receiveResources() external payable;
}
