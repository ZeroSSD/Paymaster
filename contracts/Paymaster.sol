// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {HTLC} from "AtomicSwap.sol";

contract Paymaster is HTLC {
    /**
     * Variable Declaration
     */
    enum Status {
        NOT_REQUESTED,
        REQUESTED,
        ACTIVE,
        PAUSED,
        CLOSED
    }

    mapping(address => Status) accountStatus;
    mapping(address => uint) balances;

    address owner;

    /**
     * Modifiers
     */

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    }

    modifier isAccountActive() {
        require(
            accountStatus[msg.sender] == Status.ACTIVE,
            "Account not active"
        );
        _;
    }

    modifier isAccountPaused() {
        require(
            accountStatus[msg.sender] == Status.PAUSED,
            "Account not paused"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * Functions
     */
    function openAccount() public {
        if (
            accountStatus[msg.sender] != Status.NOT_REQUESTED &&
            accountStatus[msg.sender] != Status.CLOSED
        ) {
            revert("openAccount(): You already opened a account");
        }
        accountStatus[msg.sender] = Status.REQUESTED;
    }

    function approveAccount(address account) public onlyOwner {
        require(
            accountStatus[account] == Status.REQUESTED,
            "approveAccount(): Account request does not exists"
        );
        accountStatus[account] = Status.ACTIVE;
    }

    function pauseAccount() public isAccountActive {
        accountStatus[msg.sender] = Status.PAUSED;
    }

    function unPauseAccount() public isAccountPaused {
        accountStatus[msg.sender] = Status.ACTIVE;
    }

    function closeAccount() public isAccountActive {
        require(
            balances[msg.sender] == 0,
            "closeAccount(): Withdraw all your balance to close"
        );
        accountStatus[msg.sender] = Status.CLOSED;
    }

    function deposit() public payable isAccountActive {
        require(
            msg.value > 0,
            "deposit(): Deposit Amount should be greater than zero"
        );
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public isAccountActive {
        require(
            balances[msg.sender] >= amount,
            "withdraw(): Not enough balance"
        );
        (bool status, ) = payable(msg.sender).call{value: amount}("");
        require(status, "withdraw(): Transfer failed");
        balances[msg.sender] -= amount;
    }

    function transferAmount(address to, uint256 amount) public isAccountActive {
        require(
            balances[msg.sender] >= amount,
            "transfer(): Not enough balance"
        );
        (bool status, ) = payable(to).call{value: amount}("");
        require(status, "transferAmount(): Transfer failed");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function getAccountStatus() public view returns (Status) {
        return accountStatus[msg.sender];
    }

    function accountBalance() public view returns (uint) {
        require(
            accountStatus[msg.sender] == Status.ACTIVE,
            "accountBalance(): Account not active"
        );
        return balances[msg.sender];
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function Htlc() public isAccountActive() {
        require(
            balances[msg.sender] >= amount,
            "Htlc(): Not enough balance"
        );
        balances[msg.sender]-=amount;
        balances[msg.sender]+=token;
    }
}