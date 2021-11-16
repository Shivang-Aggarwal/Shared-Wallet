// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Owner{
    address payable public owner;
    
    constructor(){
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner(){
        require(msg.sender==owner, "You are not the owner!");
        _;
    }
}