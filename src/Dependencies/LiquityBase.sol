// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.24;

import "./Constants.sol";
import "./LiquityMath.sol";
import "../Interfaces/IAddressesRegistry.sol";
import "../Interfaces/IActivePool.sol";
import "../Interfaces/IDefaultPool.sol";
import "../Interfaces/IPriceFeed.sol";
import "../Interfaces/ILiquityBase.sol";

/*
* Base contract for TroveManager, BorrowerOperations and StabilityPool. Contains global system constants and
* common functions.
*/
contract LiquityBase is ILiquityBase {

    IActivePool public activePool;
    IDefaultPool public defaultPool;
    IPriceFeed public priceFeed;

    event ActivePoolAddressChanged(address _newActiveAddress);
    event DefaultPoolAddressChanged(address _newDefaultAddress);
    event PriceFeedAddressesChanged(address _newPriceFeedAddress);

    constructor(IAddressesRegistry _addressesRegistry){
        activePool= _addressesRegistry.activePool();
        defaultPool= _addressesRegistry.defaultPool();
        priceFeed= _addressesRegistry.priceFeed();

        emit ActivePoolAddressChanged(address(activePool));
        emit DefaultPoolAddressChanged(address(defaultPool));
        emit PriceFeedAddressesChanged(address(priceFeed));

    }

    function getEntireBranchColl() public view returns(uint256 entireSystemColl) {
        uint256 activeColl= activePool.getCollBalance();
        uint256 liquidatedColl= defaultPool.getCollBalance();
        return activeColl+liquidatedColl;
    }

    function getEntireBranchDebt() public view returns(uint256 entireSystemDebt){
        uint256 activeDebt = activePool.getDebtBalance();
        uint256 closedDebt = defaultPool.getDebtBalance();
        return activeDebt + closedDebt;
    }

    function getTCR(uint256 _price) internal view returns(uint256 TCR){
        uint256 entireSystemColl = getEntireBranchColl();
        uint256 entireSystemDebt = getEntireBranchDebt();
        TCR = LiquityMath._computeCR(entireSystemColl, entireSystemDebt, _price);
        return TCR;
    }

    function _checkBelowCriticalThreshold(uint256 _price , uint256 _CCR) internal view returns(bool){
        uint256 TCR = _getTCR(_price);
            return TCR < _CCR;
    }

}