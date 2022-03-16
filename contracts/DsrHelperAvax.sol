// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./DsrHelper.sol";

contract DsrHelperAvax is DsrHelper {

  constructor(address dsrTokenAddress_, address exchangeRouterAddress_, address rsdTokenAddress_, address sdrTokenAddress_)
    DsrHelper(dsrTokenAddress_, exchangeRouterAddress_, rsdTokenAddress_, sdrTokenAddress_) {
  }

  function swapEthForRsd() external virtual override fromDsrToken returns(bool) {
    uint256 ethAmount = address(this).balance;
    // generate the pair path of ETH -> RSD on exchange router contract
    address[] memory path = new address[](2);
    path[0] = IUniswapV2Router02(exchangeRouterAddress).WETH();
    path[1] = rsdTokenAddress;

    try IUniswapV2Router02(exchangeRouterAddress).swapExactAVAXForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
      0, // accept any amount of RSD
      path,
      address(this),
      block.timestamp
    ) { return true; } catch { return false; }
  }
}
