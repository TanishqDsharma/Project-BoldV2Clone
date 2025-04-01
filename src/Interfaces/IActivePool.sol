// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0; //@audit changing pragma

import "./IInterestRouter.sol";
import "./IBoldRewardsReceiver.sol";
import "../Types/TroveChange.sol";


interface IActivePool{

    // returns the address of the default pool
    function defaultPoolAddress() external view returns(address);

    // returns the address of the borrower operations contract
    function borrowerOperationsAddress() external view returns(address);

    // returns address of the troveManager contract
    function troveManagerAddress() external view returns(address);

    // Returns an instance of the IBoldRewardsReceiver interface
    function interestRouter() external view returns(IInterestRouter);

    // Returns an instance of the IBoldRewardsReceiver interface
    function stablityPool() external view returns(IBoldRewardsReceiver); //@audit typo for stablity pool

    // Balances and Debts

    /**
     * returns the collateral balance in the active pool, probably for a particular 
     * type of asset (eg: tokens or stable coin)
    */
    function getCollBalance() external view returns(uint256);

    // returns the total debt in the system
    function getBoldDebt() external view returns(uint256);

    // returns the lasttime the aggregate(agg) data was updated
    function lastAggUpdateTime() external view returns(uint256);

    // Returns the total recorded debt in the aggregate system, possibly across multiple troves or pools. 
    function aggRecordedDebt() external view returns(uint256);

    function aggWeightedDebtSum() external view returns(uint256);

    function aggBatchManageMentFees() external view returns(uint256);

    function aggWeightedBatchManagementFeeSum() external view returns(uint256);

    // Pending Calculation Functions

    function calcPendingAggInterest() external view returns(uint256);

    function calcPendingSPYield() external view returns(uint256);

    function calcPendingAggBatchManagementFee() external view returns(uint256);

    // functions for interest and Fees Management

    function getNewApproxAvgInterestRateFromTroveChange
        (TroveChange calldata _troveChange) external view returns(uint256);

    function mintAggInterest() external;

    function mintAggInterestAndAccountForTroveChange(TroveChange calldata _troveChange, 
        address _batchManager) external;
    
    function mintBatchManagementFeeAndAccountForChange(TroveChange calldata _troveChange, 
        address _batchAddress) external;
    
    // Shutdown Functions

    function setShutdownFlag() external;
    function hasBeenShutdown() external view returns(bool);
    function shutdownTime() external view returns(uint256);

    // Functions for Collateral Management

    function sendColl(address _account, uint256 _amount) external; 
    function sendCollToDefaultPool(uint256 _amount) external;
    function receiveColl(uint256 _amount) external;

}