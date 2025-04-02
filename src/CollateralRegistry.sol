// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import "./Interfaces/ITroveManager.sol";
import "./Interfaces/IBoldToken.sol";
import "./Dependencies/Constants.sol";
import "./Dependencies/LiquityMath.sol";

import "./Interfaces/ICollateralRegistry.sol";

contract CollateralRegistry is ICollateralRegistry{

    uint256 public immutable totalCollaterals;

    IERC20Metadata internal immutable token0;
    IERC20Metadata internal immutable token1;
    IERC20Metadata internal immutable token2;
    IERC20Metadata internal immutable token3;
    IERC20Metadata internal immutable token4;
    IERC20Metadata internal immutable token5;
    IERC20Metadata internal immutable token6;
    IERC20Metadata internal immutable token7;
    IERC20Metadata internal immutable token8;
    IERC20Metadata internal immutable token9;

    ITroveManager internal immutable troveManager0;
    ITroveManager internal immutable troveManager1;
    ITroveManager internal immutable troveManager2;
    ITroveManager internal immutable troveManager3;
    ITroveManager internal immutable troveManager4;
    ITroveManager internal immutable troveManager5;
    ITroveManager internal immutable troveManager6;
    ITroveManager internal immutable troveManager7;
    ITroveManager internal immutable troveManager8;
    ITroveManager internal immutable troveManager9;

    IBoldToken public immutable boldToken;
    uint256 public baseRate;

    // The timestamp of the latest base operation

    uint256 public lastFeeOperationTime = block.timestamp;

    event baseRateUpdated(uint256 _baseRate);
    event lastFeeOpTimeUpdated(uint256 _lastFeeOpTime);

    constructor(
                IBoldToken _boldToken, 
                IERC20Metadata[] memory _tokens, 
                ITroveManager[] memory _troveManagers
                ){

            uint256 numTokens = _tokens.length;
            require(numTokens>0,"Collateral list cannot be empty");
            require(numTokens<=10,"Collateral list too long");

            totalCollaterals = numTokens;

            boldToken = _boldToken;

            token0 = _token[0];
            token1 =  numTokens > 1 ? _tokens[1] : IERC20Metadata(address(0));
            token2 =  numTokens > 2 ? _tokens[2] : IERC20Metadata(address(0));
            token3 =  numTokens > 3 ? _tokens[3] : IERC20Metadata(address(0)); 
            token4 =  numTokens > 4 ? _tokens[4] : IERC20Metadata(address(0));
            token5 =  numTokens > 5 ? _tokens[5] : IERC20Metadata(address(0));
            token6 =  numTokens > 6 ? _tokens[6] : IERC20Metadata(address(0));
            token7 =  numTokens > 7 ? _tokens[7] : IERC20Metadata(address(0));
            token8 =  numTokens > 8 ? _tokens[8] : IERC20Metadata(address(0));
            token9 =  numTokens > 9 ? _tokens[9] : IERC20Metadata(address(0));

            troveManager0 = _troveManagers[0];
            troveManager1 = numTokens > 1 ? _troveManagers[1] : IERC20Metadata(address(0));
            troveManager2 = numTokens > 2 ? _troveManagers[2] : IERC20Metadata(address(0));
            troveManager3 = numTokens > 3 ? _troveManagers[3] : IERC20Metadata(address(0));
            troveManager4 = numTokens > 4 ? _troveManagers[4] : IERC20Metadata(address(0));
            troveManager5 = numTokens > 5 ? _troveManagers[5] : IERC20Metadata(address(0));
            troveManager6 = numTokens > 6 ? _troveManagers[6] : IERC20Metadata(address(0));
            troveManager7 = numTokens > 7 ? _troveManagers[7] : IERC20Metadata(address(0));
            troveManager8 = numTokens > 8 ? _troveManagers[8] : IERC20Metadata(address(0));
            troveManager9 = numTokens > 9 ? _troveManagers[9] : IERC20Metadata(address(0));

            baseRate =  INITIAL_BASE_RATE;
            emit baseRateUpdated(INITIAL_BASE_RATE);
    }

}