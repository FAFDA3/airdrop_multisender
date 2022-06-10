pragma solidity ^0.8.7;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Airdrop  {
    address public owner;
    uint256 public balance;
    uint256 public next_receiver = 1;
    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);
    uint256 public amount_for_client = 0;
    constructor() {
        owner = msg.sender;
    }
    
    receive() payable external {
        balance += msg.value;
        emit TransferReceived(msg.sender, msg.value);
    }    

    function set_for_client(uint amount) public {
        require(msg.sender == owner, "Only owner can set amount for client"); 
        amount_for_client = amount;
    }
    mapping(uint => address) public balances;

    function updateBalance() private {
        balances[next_receiver] = msg.sender;
        next_receiver += 1;
    }

    function updateBalance_2(address new_receiver) private {
        balances[next_receiver] = new_receiver;
        next_receiver += 1;
    }

      function bulkAirdropERC20(address payable[] calldata _to, uint256 amount_for_client2) public {
        for (uint256 i = 0; i < _to.length; i++) {
                    
        payable(_to[i]).transfer(amount_for_client2);
        }
    }

    function getAll() public view returns (address[] memory){
        address[] memory ret = new address[](next_receiver);
        for (uint i = 0; i < next_receiver; i++) {
            ret[i] = balances[i];
        }
        return ret;
    }
    function verify() public view returns (bool paid){
        int verified = 0;
        for (uint i = 0; i < next_receiver; i++) {
            if (balances[i] == msg.sender){
                verified = verified + 1 ;
            }
        }
        if( verified > 0){
            paid = true;
        }

        return paid;
    }


    function sendETHtoContract(uint256 j) public payable {
    //msg.value is the amount of wei that the msg.sender sent with this transaction. 
    //If the transaction doesn't fail, then the contract now has this ETH.
    }


    function withdraw(uint amount, address payable destAddr) public {
        require(msg.sender == owner, "Only owner can withdraw funds"); 
        require(amount <= balance, "Insufficient funds");
        
        destAddr.transfer(amount);
        balance -= amount;
        emit TransferSent(msg.sender, destAddr, amount);
    }

    
    function receive_amount_msgsender() public returns ( string memory transaction) {
        bool paid = verify();
        require(paid ==  false, "You received the amount necessary for the minting");
        
        payable(msg.sender).transfer(amount_for_client);
        transaction = "transaction ok";
        updateBalance_2(msg.sender);
        
        return transaction;
    }

  
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }



}