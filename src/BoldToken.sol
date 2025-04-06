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


}