// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "Solidity Project - Shared Wallet/Owner.sol";

contract Wallet is Owner{
    mapping(address => uint) public balanceList;
    uint public walletBalance;
    
    modifier ownerOrAllowed(uint _amt){
        require(msg.sender==owner || balanceList[msg.sender]>=_amt, "You are neither owner nor allowed!");
        _;
    }
    
    event allowanceAdded(address _addr, uint _amountAdded, uint _currentAllowance);
    event fundsReceived(address _from, uint _amt);
    event fundsWithdrawn(address _to, uint _amt);
    
    function receiveMoney() public payable{
        walletBalance += msg.value;
        
        emit fundsReceived(msg.sender, msg.value);
    }
    
    //Fallback function
    /*receive() external payable{
        receiveMoney();
    }*/
    
    function addAllowance(address _addr, uint _amt) onlyOwner public{
        balanceList[_addr] += _amt;
        
        emit allowanceAdded(_addr, _amt, balanceList[_addr]);
    }
    
    function withdrawMoney(address payable _addr, uint _amt) ownerOrAllowed(_amt) public{
        require(walletBalance>=_amt, "Insufficient funds in wallet!");
        balanceList[msg.sender] -= _amt;
        walletBalance -= _amt;
        _addr.transfer(_amt);
        
        emit fundsWithdrawn(_addr, _amt);
    }
    
    function destroyWallet() public payable{
        selfdestruct(owner);
    }
}