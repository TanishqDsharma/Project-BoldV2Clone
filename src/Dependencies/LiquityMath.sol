// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {DECIMAL_PRECISION} from "./Constants.sol";

library liquityMath{

    function _min(uint256 a, uint256 b) public view returns(uint256){
        return a < b ? a :b;
    }

    function _max(uint256 a, uint256 b) public view returns(uint256){
        return a >= b ? a :b ;
    }

    function _sub_min_0(uint256 a, uint256 b) public view returns(uint256){
        return a > b ? a-b:0;
    }

    function decMull(uint256 a, uint256 y) public view returns(uint256 decProd){
        prod_ab = a * b;
        decProd = (prod_xy + DECIMAL_PRECISION / 2) / DECIMAL_PRECISION;
    }

    function _decPow(uint256 _base, uint256 _minutes) public view returns(uint256){
         if (_minutes > 525600000) _minutes = 525600000; // cap to avoid overflow

        if (_minutes == 0) return DECIMAL_PRECISION;

        uint256 a=_base;
        uint256 b=DECIMAL_PRECISION;
        uint256 n=_minutes;

        while(n>1){
            if(n%2==0){
                    a = decMull(a,a);
                    n=n/2;
                } else {
                // if (n % 2 != 0)
                y = decMul(x, y);
                x = decMul(x, x);
                n = (n - 1) / 2;
            }
        } 
    }

    function _getAbsoluteDifference(uint256 a, uint256 b) internal pure returns(uint256){
        return a>=b ? a-b : b-a;
    }

    function _computeCR(uint256 _coll, uint256 _debt, uint256 _price) internal pure returns(uint256){
        if(_debt>0){
            uint256 newCollRatio = _coll * _price / _debt;   
            return newCollRatio; 
        }
        // Return the maximal value for uint256 if the debt is 0. Represents "infinite" CR.
        else {
            // if (_debt == 0)
            return 2 ** 256 - 1;
        }
    }


}
