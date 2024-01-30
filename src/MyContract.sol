// SPDX-License-Identifier: MIT

import "./IBlast.sol";
import "./IWETHUSDBRebasing.sol";

pragma solidity ^0.8.0;

contract MyContract {
    address public blastYieldContract = 0x4300000000000000000000000000000000000002;
    address public usdbContract = 0x4200000000000000000000000000000000000022;
    address public wethContract = 0x4200000000000000000000000000000000000023;

	constructor(address gov) {
        IBlast(blastYieldContract).configureClaimableGas(); // Gas is claimable
		// IBlast(0x4300000000000000000000000000000000000002).configureAutomaticYield(); //contract balance will grow automatically
        IBlast(blastYieldContract).configureClaimableYield(); //claim your yield
        IBlast(blastYieldContract).configureGovernor(gov); // only gov address can claim yield
        
        IWETHUSDBRebasing(usdbContract).configure(YieldMode.CLAIMABLE); //configure claimable yield for USDB
		IWETHUSDBRebasing(wethContract).configure(YieldMode.CLAIMABLE); //configure claimable yield for WETH
	}

    function claimYield(address recipient, uint256 amount) external {
	    //This function is public meaning anyone can claim the yield
	    IBlast(blastYieldContract).claimYield(address(this), recipient, amount);
    }

	function claimAllYield(address recipient) external {
	    //This function is public meaning anyone can claim the yield
		IBlast(blastYieldContract).claimAllYield(address(this), recipient);
    }

    function claimAllGas(address recipient) external {
	    // This function is public meaning anyone can claim the gas
		IBlast(blastYieldContract).claimAllGas(address(this), recipient);
    }
}