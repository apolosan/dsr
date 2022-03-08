// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IPriceFeed {
    function getUnderlyingPrice(address cToken) external view returns (uint);
}
