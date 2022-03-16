// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IDsrHelper {
	function addLiquidityDsrEth(uint256 dsrTokenAmount) external payable returns(bool);
	function addLiquidityDsrRsd(uint256 dsrTokenAmount) external returns(bool);
	function addLiquidityDsrSdr(uint256 dsrTokenAmount) external returns(bool);
	function getPoolRate(address pair, address asset01, address asset02) external view returns(uint256, bool);
	function swapEthForRsd(uint256 ethAmount) external returns(bool);
	function swapRsdForDsr(uint256 tokenAmount) external returns(bool);
	function swapRsdForSdr(uint256 tokenAmount) external returns(bool);
	function setSdrTokenAddress(address sdrTokenAddress_) external;
	function setRsdTokenAddress(address rsdTokenAddress_) external;
	function withdrawTokensSent(address tokenAddress) external;
	function withdrawEthSent(address payable accountAddress) external;
}
