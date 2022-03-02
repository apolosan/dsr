// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IcERC20 {
    function mint(uint256) external returns (uint256);
    function borrow(uint256) external returns (uint256);
    function borrowRatePerBlock() external view returns (uint256);
    function borrowBalanceCurrent(address) external returns (uint256);
		function redeem(uint256 redeemTokens) external returns (uint256);
    function repayBorrow(uint256) external returns (uint256);
}
