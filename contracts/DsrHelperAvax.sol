// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./DsrHelper.sol";

contract DsrHelperAvax is DsrHelper {

  constructor(address dsrTokenAddress_, address exchangeRouterAddress_, address rsdTokenAddress_, address sdrTokenAddress_)
    DsrHelper(dsrTokenAddress_, exchangeRouterAddress_, rsdTokenAddress_, sdrTokenAddress_) {
  }

  function swapEthForRsd(uint256 ethAmount) external virtual override fromDsrToken returns(bool) {
    // generate the pair path of ETH -> RSD on exchange router contract
    address[] memory path = new address[](2);
    path[0] = address(_wEth);
    path[1] = rsdTokenAddress;

    try exchangeRouter.swapExactAVAXForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
      0, // accept any amount of RSD
      path,
      address(this),
      block.timestamp
    ) { return true; } catch { return false; }
  }
}
