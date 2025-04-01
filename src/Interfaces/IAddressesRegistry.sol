// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IAddressesRegistry{

    struct AddressVars{
        IERC20Metadata collToken;
        IBorrowerOperations borrowerOperations;
        IToveManager troveManager;
        ITroveNFT troveNFT;
        ImetadataNFT metadataNFT;
        IStabilityPool stabilityPool;
        IPriceFeed priceFeed;
        IActivePool activePool;
        IDefaultPool defaultPool;
        address gasPoolAddress;
        ICollSurplusPool collSurplusPool;
        IsortedTroves sortedTroves;
        IInterestRouter interestRouter;
        IHintHelpers hintHelpers;
        IMultiTroveGetter multiTroveGetter;
        ICollateralRegistry collateralRegistry;
        IBoldToken boldtoken;
        IWETH WETH;
    }

    function CCR() external returns(uint256);
    function SCR() external returns(uint256);
    function BCR() external returns(uint256);
    function MCR() external returns(uint256);

    function LIQUIDATION_PENALTY_SP() external returns(uint256);
    function LIQUIDATION_PENALTY_REDISTRIBUTION() external returns(uint256);

    function collToken() external view returns(IERC20Metadata);
    function borrowerOperations() external view returns(IBorrowerOperations);
    function troveManager() external view returns(ITroveManager);
    function troveNFT() external view returns(ITroveNFT);

    function metadataNFT() external view returns(IMetadataNFT);
    function stabilityPool() external view returns(IStabilityPool);
    function priceFeed() external view returns(IPriceFeed);
    function activePool() external view returns(IActivePool);
    function defaultPool() external view returns(IDeFaultPool);
    function gasPoolAddress() external view returns(IGasPoolAddress);
    function collSurplusPool() external view returns(ICollSurplusPool);
    function sortedTroves() external view returns(ISortedTroves);
    function interestRouter() external view returns(IInterestRouter);
    function hintHelpers() external view returns(IHintHelpers);
    function multiTroveGetter() external view returns(IMultiTroveGetter);
    function collateralRegistry() external view returns(ICollateralRegistry);
    function boldToken() external view returns(IBoldToken);
    function weth() external view returns(IWETH);s

}

