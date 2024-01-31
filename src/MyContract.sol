// SPDX-License-Identifier: MIT

import "./IBlast.sol";
import "./IERC20Rebasing.sol";

pragma solidity ^0.8.0;

contract MyContract {
    IBlast public constant BLAST = IBlast(0x4300000000000000000000000000000000000002);
    IERC20Rebasing public constant USDB = IERC20Rebasing(0x4200000000000000000000000000000000000022);
    IERC20Rebasing public constant WETH = IERC20Rebasing(0x4200000000000000000000000000000000000023);

	constructor(address gov) {
        BLAST.configureClaimableGas(); // Gas is claimable
		// IBlast(0x4300000000000000000000000000000000000002).configureAutomaticYield(); //contract balance will grow automatically
        BLAST.configureClaimableYield(); //claim your yield
        BLAST.configureGovernor(gov); // only gov address can claim yield
        
        USDB.configure(YieldMode.CLAIMABLE); //configure claimable yield for USDB
		WETH.configure(YieldMode.CLAIMABLE); //configure claimable yield for WETH
	}

    function claimYield(address recipient, uint256 amount) external {
	    //This function is public meaning anyone can claim the yield
	    BLAST.claimYield(address(this), recipient, amount);
    }

	function claimAllYield(address recipient) external {
	    //This function is public meaning anyone can claim the yield
		BLAST.claimAllYield(address(this), recipient);
    }

    function claimAllGas(address recipient) external {
	    // This function is public meaning anyone can claim the gas
		BLAST.claimAllGas(address(this), recipient);
    }
}