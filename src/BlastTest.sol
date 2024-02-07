
pragma solidity ^0.8.0;

import "./IBlast.sol";
import "./IERC20Rebasing.sol";

contract BlastTest {

    IBlast public constant BLAST_YIELD =
        IBlast(0x4300000000000000000000000000000000000002);
    IERC20Rebasing public constant USDB =
        IERC20Rebasing(0x4200000000000000000000000000000000000022);
    IERC20Rebasing public constant WETH =
        IERC20Rebasing(0x4200000000000000000000000000000000000023);

    constructor() {
        BLAST_YIELD.configureAutomaticYield();
        BLAST_YIELD.configureClaimableGas(); // Gas is claimable
        BLAST_YIELD.configureGovernor(msg.sender);
    }

     // configure
    function configureContractW(address contractAddress, YieldMode _yield, GasMode gasMode, address governor) external {
        BLAST_YIELD.configureContract(contractAddress, _yield, gasMode, governor);
    }

    function configureW(YieldMode _yield, GasMode gasMode, address governor) external {
        
    }

    // base configuration options
    function configureClaimableYieldW() external {

    }
    
    function configureClaimableYieldOnBehalfW(address contractAddress) external {

    }
    
    function configureAutomaticYieldW() external {

    }
    function configureAutomaticYieldOnBehalfW(address contractAddress) external {

    }
    function configureVoidYieldW() external {

    }
    function configureVoidYieldOnBehalfW(address contractAddress) external {

    }
    function configureClaimableGasW() external {

    }
    function configureClaimableGasOnBehalfW(address contractAddress) external {

    }
    function configureVoidGasW() external {

    }
    function configureVoidGasOnBehalfW(address contractAddress) external {

    }
    function configureGovernorW(address _governor) external {

    }
    function configureGovernorOnBehalfW(address _newGovernor, address contractAddress) external {

    }

    // claim yield
    function claimYieldW(address contractAddress, address recipientOfYield, uint256 amount) external returns (uint256) {

    }
    function claimAllYieldW(address contractAddress, address recipientOfYield) external returns (uint256) {

    }

    // claim gas
    function claimAllGasW(address contractAddress, address recipientOfGas) external returns (uint256){}
    function claimGasAtMinClaimRateW(address contractAddress, address recipientOfGas, uint256 minClaimRateBips) external returns (uint256){}
    function claimMaxGasW(address contractAddress, address recipientOfGas) external returns (uint256){}
    function claimGasW(address contractAddress, address recipientOfGas, uint256 gasToClaim, uint256 gasSecondsToConsume) external returns (uint256){}

    // read functions
    function readClaimableYieldW(address contractAddress) external view returns (uint256){}
    function readYieldConfigurationW(address contractAddress) external view returns (uint8){}
    function readGasParamsW(address contractAddress) external view returns (uint256 etherSeconds, uint256 etherBalance, uint256 lastUpdated, GasMode){}
}