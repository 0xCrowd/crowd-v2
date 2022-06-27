pragma solidity ^0.8.4;

contract Fundraising {

    constructor() {}

    mapping(address => mapping(address => uint256)) deposits; // sender => dao => amount
    mapping(address => uint256) deposits_total; // dao => amount
    mapping(address => uint256) funds_used; // dao => amount

    function deposit(address to) public payable {
        deposits_total[to] += msg.value;
        deposits[msg.sender][to] += msg.value;
    }

    function withdraw(address from, uint256 amount) public payable {
        uint256 total = deposits_total[from];
        uint256 user_deposit = deposits[msg.sender][from];
        uint256 share = user_deposit / total;
        // ToDo CToken?

        require(amount <= deposits[msg.sender][from]);
        deposits[msg.sender][from] -= amount;
        deposits_total[from] -= amount;
        payable(msg.sender).call{value: amount}("");
    }

}
