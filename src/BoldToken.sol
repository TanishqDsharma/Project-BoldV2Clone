// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.24;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "./Dependencies/Ownable.sol";
import "./Interfaces/IBoldToken.sol";


/**
 * @notice
 * Transfer Protection: blacklist of addresses that are invalid recipients (i.e. core Liquity contracts) in external
 * transfer() and transferFrom() calls. The purpose is to protect users from losing tokens by mistakenly sending BOLD directly to a Liquity
 * core contract, when they should rather call the right function.
 * 
 * sendToPool() and returnFromPool(): functions callable only Liquity core contracts, 
 * which move BOLD tokens between Liquity <-> user.
 */


contract BoldToken is Ownable, IBoldToken, ERC20Permit {
   
   // Defines the Token name 
   string internal constant _name = "BOLD Stablecoin";
   // Define the Token symbol
   string internal constant _symbol = "BOLD";

    address public collateralRegistryAddress;
    mapping(address=>bool)  troveManagerAddresses;
    mapping(address=>bool)  stabilityPoolAddresses;
    mapping(address=>bool)  borrowerOperationsAddresses;
    mapping(address=>bool)  activePoolAddresses;

    //////////////////////
    /////// Events ////// 
    ///////////////////// 

    event CollateralRegistryAddressChanged(address _newCollateralRegistryAddress);
    event TroveManagerAddressAdded(address _newTroveManagerAddress);
    event StabilityPoolAddressAdded(address _newStabilityPoolAddress);
    event BorrowerOperationsAddressAdded(address _newBorrowerOperationsAddress);
    event ActivePoolAddressAdded(address _newActivePoolAddress);

    constructor(address _owner) Ownable(owner) ERC20(_name,_symbol) ERC20Permit(_name) {

    }

    /** 
     * @param _troveManagerAddress Address of the troveManager
     * @param _stabilityPoolAddress Address of the stablityPool contract 
     * @param _borrowerOperationsAddress  Address of the BorrowerOperations contract
     * @param _activePoolAddress Address of the activePool contract to be authorized
     */

    function setBranchAddresses(
        address _troveManagerAddress,
        address _stabilityPoolAddress,
        address _borrowerOperationsAddress,
        address _activePoolAddress
    ) external override onlyOwner {
        
        troveManagerAddresses[_troveManagerAddress] = true;
        emit TroveManagerAddressAdded(_troveManagerAddress);

        stabilityPoolAddresses[_stabilityPoolAddress] = true;
        emit StabilityPoolAddressAdded(_stabilityPoolAddress);

        borrowerOperationsAddresses[_borrowerOperationsAddress] = true;
        emit BorrowerOperationsAddressAdded(_borrowerOperationsAddress);

        activePoolAddresses[_activePoolAddress] = true;
        emit ActivePoolAddressAdded(_activePoolAddress);
        
    }

    function setCollateralRegistry(address _collateralRegistryAddress) 
        external override onlyOwner{
            // sets the collateralRegistryAddress
            collateralRegistryAddress = _collateralRegistryAddress;
            emit CollateralRegistryAddressChanged(_collateralRegistryAddress);
            // it permanently revokes the ownership of the contract. After this:
            // No one will be able to call onlyOwner functions anymore.
            _renounceOwnership();
    }


    function mint(address _account, uint256 _amount) external override{
        _requireCallerIsBOorAP();
        _mint(_account,_amount);
    }

    function burn(address _account, uint256 _amount) external override{
        _requireCallerIsCRorBOorTMorSP();
        _burn(_account,_amount);
    }

    function sendToPool(address _sender, address poolAddress, uint256 _amount) 
        external override{
        _requireCallerIsStabilityPool();
        _transfer(_sender, _poolAddress, _amount);
    }

    function returnFromPool(address _poolAddress, address _reciver, uint256 _amount)
         external override{
        _requireCallerIsStabilityPool();
        _transfer(_poolAddress, _receiver, _amount);
    }

    // External Functions

    function transfer(address recipient, uint256 amount) public override(ERC,IERC20) returns(bool){
        _requireValidRecipient(recipient);
        return super.transfer(recipient,amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount)
        public 
        override(ERC20,IERC20)
        returns (bool) {
            _requireValidRecipient(recipient);
            return super.transferFrom(sender, recipient, amount);
        }

    function _requireValidRecipient(address recipient) internal view {
        require(_recipient != address(0) && _recipient != address(this),
        "BoldToken: Cannot transfer tokens directly to the Bold token contract or the zero address"
        );    }

    function _requireCallerIsBOorAP() internal view{
        require(
            borrowerOperationsAddresses[msg.sender] || activePoolAddresses[msg.sender],
            "BoldToken: Caller is not BO or AP"
        );
    }

    
    function _requireCallerIsCRorBOorTMorSP() internal view {
        require(
            msg.sender == collateralRegistryAddress || borrowerOperationsAddresses[msg.sender]
                || troveManagerAddresses[msg.sender] || stabilityPoolAddresses[msg.sender],
            "BoldToken: Caller is neither CR nor BorrowerOperations nor TroveManager nor StabilityPool"
        );
    }

    function _requireCallerIsStabilityPool() internal view {
        require(stabilityPoolAddresses[msg.sender], "BoldToken: Caller is not the StabilityPool");
    }
}