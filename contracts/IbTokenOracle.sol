// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;
pragma experimental ABIEncoderV2;

import "usingberry/contracts/UsingBerry.sol";
import "./common/Ownable.sol";
import "./interfaces/IVault.sol";
import "./libraries/SafeMath.sol";


contract IbTokenOracle is UsingBerry,Ownable {

    using SafeMath for uint256;

    mapping (address => uint) public ibTokenInfo;

    constructor(
        address payable _berryAddress
    ) public UsingBerry(_berryAddress) 
    {
        //
    }

    function setIbTokenInfo(address _ibtoken, uint _requestId) public onlyOwner {
        ibTokenInfo[_ibtoken] = _requestId;
    }

    function getCurrentIbTokenValue(address _ibtoken) public view
            returns (bool, uint256, uint256) {
        uint _requestId = ibTokenInfo[_ibtoken];
        if (_requestId == 0) {
            return (false, 0, 0);
        }

        bool _didGet;
        uint256 _timestamp;
        uint256 _value;

        (_didGet, _value, _timestamp) = getCurrentValue(_requestId);
        if (_didGet == false) {
            return (false, 0, 0);
        }

        uint256 totalToken = IVault(_ibtoken).totalToken();
        uint256 totalSupply = IVault(_ibtoken).totalSupply();

        _value = _value.mul(totalToken).div(totalSupply);

        return (true, _value, _timestamp);
    }

}