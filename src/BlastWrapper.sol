pragma solidity ^0.8.0;

import "./IBlast.sol";
import "./IERC20Rebasing.sol";

contract BlastWrapper {
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
    function configureContractW(
        address contractAddress,
        YieldMode _yield,
        GasMode gasMode,
        address governor
    ) external {
        BLAST_YIELD.configureContract(
            contractAddress,
            _yield,
            gasMode,
            governor
        );
    }

    function configureW(
        YieldMode _yield,
        GasMode gasMode,
        address governor
    ) external {
        BLAST_YIELD.configure(_yield, gasMode, governor);
    }

    // base configuration options
    function configureClaimableYieldW() external {
        BLAST_YIELD.configureClaimableYield();
    }

    function configureClaimableYieldOnBehalfW(
        address contractAddress
    ) external {
        BLAST_YIELD.configureClaimableYieldOnBehalf(contractAddress);
    }

    function configureAutomaticYieldW() external {
        BLAST_YIELD.configureAutomaticYield();
    }

    function configureAutomaticYieldOnBehalfW(
        address contractAddress
    ) external {
        BLAST_YIELD.configureAutomaticYieldOnBehalf(contractAddress);
    }

    function configureVoidYieldW() external {
        BLAST_YIELD.configureVoidYield();
    }

    function configureVoidYieldOnBehalfW(address contractAddress) external {
        BLAST_YIELD.configureVoidYieldOnBehalf(contractAddress);
    }

    function configureClaimableGasW() external {
        BLAST_YIELD.configureClaimableGas();
    }

    function configureClaimableGasOnBehalfW(address contractAddress) external {
        BLAST_YIELD.configureClaimableGasOnBehalf(contractAddress);
    }

    function configureVoidGasW() external {
        BLAST_YIELD.configureVoidGas();
    }

    function configureVoidGasOnBehalfW(address contractAddress) external {
        BLAST_YIELD.configureVoidGasOnBehalf(contractAddress);
    }

    function configureGovernorW(address _governor) external {
        BLAST_YIELD.configureGovernor(_governor);
    }

    function configureGovernorOnBehalfW(
        address _newGovernor,
        address contractAddress
    ) external {
        BLAST_YIELD.configureGovernorOnBehalf(_newGovernor, contractAddress);
    }

    // claim yield
    function claimYieldW(
        address contractAddress,
        address recipientOfYield,
        uint256 amount
    ) external returns (uint256) {
        BLAST_YIELD.claimYield(contractAddress, recipientOfYield, amount);
    }

    function claimAllYieldW(
        address contractAddress,
        address recipientOfYield
    ) external returns (uint256) {
        BLAST_YIELD.claimAllYield(contractAddress, recipientOfYield);
    }

    // claim gas
    function claimAllGasW(
        address contractAddress,
        address recipientOfGas
    ) external returns (uint256) {
        BLAST_YIELD.claimAllGas(contractAddress, recipientOfGas);
    }

    function claimGasAtMinClaimRateW(
        address contractAddress,
        address recipientOfGas,
        uint256 minClaimRateBips
    ) external returns (uint256) {
        BLAST_YIELD.claimGasAtMinClaimRate(
            contractAddress,
            recipientOfGas,
            minClaimRateBips
        );
    }

    function claimMaxGasW(
        address contractAddress,
        address recipientOfGas
    ) external returns (uint256) {
        BLAST_YIELD.claimMaxGas(contractAddress, recipientOfGas);
    }

    function claimGasW(
        address contractAddress,
        address recipientOfGas,
        uint256 gasToClaim,
        uint256 gasSecondsToConsume
    ) external returns (uint256) {
        BLAST_YIELD.claimGas(
            contractAddress,
            recipientOfGas,
            gasToClaim,
            gasSecondsToConsume
        );
    }

    // read functions
    function readClaimableYieldW(
        address contractAddress
    ) external view returns (uint256) {
        BLAST_YIELD.readClaimableYield(contractAddress);
    }

    function readYieldConfigurationW(
        address contractAddress
    ) external view returns (uint8) {
        BLAST_YIELD.readYieldConfiguration(contractAddress);
    }

    function readGasParamsW(
        address contractAddress
    )
        external
        view
        returns (
            uint256 etherSeconds,
            uint256 etherBalance,
            uint256 lastUpdated,
            GasMode
        )
    {
        BLAST_YIELD.readGasParams(contractAddress);
    }
}
