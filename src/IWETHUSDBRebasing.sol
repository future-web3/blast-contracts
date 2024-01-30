// SPDX-License-Identifier: MIT

import "./IBlast.sol";

pragma solidity ^0.8.0;

interface IWETHUSDBRebasing {
    // changes the yield mode of the caller and update the balance
    // to reflect the configuration
    function configure(YieldMode) external returns (uint256);
}