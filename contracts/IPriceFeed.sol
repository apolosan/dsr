// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IPriceFeed {
    function getUnderlyingPrice(address cToken) external view returns (uint);
    function getReferenceData(string memory base, string memory quote) external view returns(uint, uint, uint);
}
