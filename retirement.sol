pragma solidity >=0.5.0 <0.7.5;
// "SPDX-License-Identifier: UNLICENSED"

contract coins {
    address public minter;
    mapping (address => uint) public balances;
    
    event Sent(address from, address to, uint amount);
    
    constructor() {
        minter = msg.sender;
    }
    
    function mint(address receiver, uint amount) public {
        require(msg.sender == receiver);
        require(amount < 1e60);
        balances[receiver] += amount;
    }
    
    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }

}

contract disbursementCondition {
    bool public isRetired;
    uint256 retirementDate;
    address public conditionAddress;

    constructor() {
        conditionAddress = msg.sender;
        isRetired = false;
        retirementDate = block.timestamp + 5 minutes;
    }

    function get() public returns (bool) {
        if (block.timestamp >= retirementDate) {
            isRetired = true;
        } 
        else if (block.timestamp < retirementDate){
            isRetired = false;
        }
        return isRetired;
    }
}

contract retirementAccount {
    address public worker;
    address public rAccount;
    uint256 balance = 1;
    coins coinSystem = coins(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    disbursementCondition condition = disbursementCondition(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);

    constructor() {
        rAccount = msg.sender;
        worker = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
    }
    
    function disburseFunds() public {
        require(condition.get()==true, "Retirement conditions not met");
        coinSystem.send(worker, balance);
    }
}
