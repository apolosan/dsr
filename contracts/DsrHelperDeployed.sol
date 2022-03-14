// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./DsrHelper.sol";

contract DsrHelperDeployed is DsrHelper {

  constructor(address dsrTokenAddress_, address exchangeRouterAddress_, address rsdTokenAddress_, address sdrTokenAddress_)
    DsrHelper(dsrTokenAddress_, exchangeRouterAddress_, rsdTokenAddress_, sdrTokenAddress_) {
  }
}
