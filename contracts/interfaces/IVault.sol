// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0;

interface IVault {
    function totalToken() external view returns (uint256);
    function totalSupply() external view returns (uint256);
}
