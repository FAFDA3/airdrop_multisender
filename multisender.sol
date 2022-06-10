pragma solidity ^0.8.7;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract FeeCollector  {
    address public owner;
    uint256 public balance;
    uint256 public next_receiver = 1;
    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);
    
    


    constructor() {
        owner = msg.sender;
    }
    
    receive() payable external {
        balance += msg.value;
        emit TransferReceived(msg.sender, msg.value);
    }    

    address [] public  clients;

    function setmapping1(address[] memory _addresses) public {
        clients = _addresses;
    }

    mapping(uint => address) public balances;

    function updateBalance() public {
        balances[next_receiver] = msg.sender;
        next_receiver += 1;
    }

    function updateBalance_2(address new_receiver) public {
        balances[next_receiver] = new_receiver;
        next_receiver += 1;
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

    
    function deposit(uint256 amount) payable public {
        require(msg.value == amount);
    // nothing else to do!
    }

    function deposit_eth(uint256 amount) payable public {
        require(msg.value == amount*10*18);
    // nothing else to do!
    }

    function receive_amount_msgsender(uint amount) public returns ( string memory transaction) {
        bool paid = verify();
        if (paid == false){
        payable(msg.sender).transfer(amount);
        transaction = "transaction ok";
        updateBalance_2(msg.sender);
        }else{
            transaction = "transaction failed";
        }
        return transaction;
    }

    
    
    function receive_amount(uint amount, address payable destAddr) public {
        destAddr.transfer(amount);

    }

    function receive_1m() public {
        payable(msg.sender).transfer(10**18);
    }


    function transferERC20(IERC20 token, address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw funds"); 
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");
        token.transfer(to, amount);
        emit TransferSent(msg.sender, to, amount);
    }   

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }



}