// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface  IAddRemoveManagers {
    function setAddManager(uint256 _troveId, address manager) external;
    function setRemoveManager(uint256 _troveId, address manager) external;
    function setRemoveManagerWithReceiver(
        uint256 _troveId,
        address manager,
        address receiver
    ) external;

    function addManagerOf(uint245 _troveId) external view returns(address);

    function receiverManagerReceiverOf(uint256 _troveId) external view returns(address,address);
}