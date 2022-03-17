// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IDsrHelper {
	function addLiquidityDsrEth() external payable returns(bool);
	function addLiquidityDsrRsd(bool halfRsd) external returns(bool);
	function addLiquidityDsrSdr() external returns(bool);
	function getPoolRate(address pair, address asset01, address asset02) external view returns(uint256, bool);
	function swapEthForRsd() external returns(bool);
	function swapRsdForDsr() external returns(bool);
	function swapRsdForSdr() external returns(bool);
	function setSdrTokenAddress(address sdrTokenAddress_) external;
	function setRsdTokenAddress(address rsdTokenAddress_) external;
	function withdrawTokensSent(address tokenAddress) external;
	function withdrawEthSent(address payable accountAddress) external;
}
