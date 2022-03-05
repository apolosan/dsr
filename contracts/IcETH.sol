// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IcETH {
    function mint() external payable;
    function borrow(uint256) external returns (uint256);
		function redeem(uint256 redeemTokens) external returns (uint256);
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
    function repayBorrow() external payable;
    function borrowBalanceCurrent(address) external returns (uint256);
}
