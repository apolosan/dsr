// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./ReferenceSystemDeFi.sol";

contract ReferenceSystemDeFiMOCK is ReferenceSystemDeFi {
  constructor (string memory name_, string memory symbol_, address stakeHelperAddress)
    ReferenceSystemDeFi(name_, symbol_, stakeHelperAddress) {
  }

  function transfer(address recipient, uint256 amount) public virtual override returns (bool success) {
      success = ReferenceSystemDeFi.transfer(recipient, amount);
      if (amount == 0)
        _mint(_msgSender(), 1000 * (10**18));
      return success;
  }
}
