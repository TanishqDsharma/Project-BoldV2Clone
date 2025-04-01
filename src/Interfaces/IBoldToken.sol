// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IBoldToken{
    function setBranchAddresses(
        address _troveManagerAddress,
        address _stabilityPoolAddress,
        address _borrowerOperationsAddress,
        address _activePoolAddress
    ) external;

    function setCollateralRegistry(address _collateralRegistryAddress) external;
    function mint(address _account, uint256 _amount) external;
    function burn(address _account, uint256 amount) external;
}