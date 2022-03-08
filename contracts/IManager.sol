// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IManager {
	function checkForProfit() external;
	function queryPrice() external view returns(uint256);
	function receiveResources() external payable;
	function setDsrTokenAddresss(address) external;
	function withdrawInvestment() external;
	function convertETHtoUSD(uint256) external view returns(uint256);
	function convertUSDtoETH(uint256) external view returns(uint256);
}
