// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {HTLC} from "AtomicSwap.sol";

/**
 * @title Paymaster contract - Manages accounts, balances, and transactions
 * @dev This contract allows users to open, close, and manage their accounts,
 * as well as deposit, withdraw, and transfer funds.
 */
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

    /**
     * @dev Modifier that allows only the owner of the contract to execute the function
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    }

    /**
     * @dev Modifier that checks if the account is active
     */
    modifier isAccountActive() {
        require(
            accountStatus[msg.sender] == Status.ACTIVE,
            "Account not active"
        );
        _;
    }

    /**
     * @dev Modifier that checks if the account is paused
     */
    modifier isAccountPaused() {
        require(
            accountStatus[msg.sender] == Status.PAUSED,
            "Account not paused"
        );
        _;
    }

    /**
     * Constructor
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * Functions
     */

    /**
     * @dev Opens an account for the caller
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

    /**
     * @dev Approves an account
     * @param account The address of the account to approve
     */
    function approveAccount(address account) public onlyOwner {
        require(
            accountStatus[account] == Status.REQUESTED,
            "approveAccount(): Account request does not exists"
        );
        accountStatus[account] = Status.ACTIVE;
    }

    /**
     * @dev Pauses the caller's account
     */
    function pauseAccount() public isAccountActive {
        accountStatus[msg.sender] = Status.PAUSED;
    }

    /**
     * @dev Unpauses the caller's account
     */
    function unPauseAccount() public isAccountPaused {
        accountStatus[msg.sender] = Status.ACTIVE;
    }

    /**
     * @dev Closes the caller's account
     */
    function closeAccount() public isAccountActive {
        require(
            balances[msg.sender] == 0,
            "closeAccount(): Withdraw all your balance to close"
        );
        accountStatus[msg.sender] = Status.CLOSED;
    }

    /**
     * @dev Deposits funds into the caller's account
     */
    function deposit() public payable isAccountActive {
        require(
            msg.value > 0,
            "deposit(): Deposit Amount should be greater than zero"
        );
        balances[msg.sender] += msg.value;
    }

    /**
     * @dev Withdraws funds from the caller's account
     * @param amount The amount of funds to withdraw
     */
    function withdraw(uint256 amount) public isAccountActive {
        require(
            balances[msg.sender] >= amount,
            "withdraw(): Not enough balance"
        );
        (bool status, ) = payable(msg.sender).call{value: amount}("");
        require(status, "withdraw(): Transfer failed");
        balances[msg.sender] -= amount;
    }

    /**
     * @dev Transfers funds from the caller's account to another account
     * @param to The address to transfer funds to
     * @param amount The amount of funds to transfer
     */
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

    /**
     * @dev Gets the status of the caller's account
     * @return The status of the caller's account
     */
    function getAccountStatus() public view returns (Status) {
        return accountStatus[msg.sender];
    }

    /**
     * @dev Gets the balance of the caller's account
     * @return The balance of the caller's account
     */
    function accountBalance() public view returns (uint) {
        require(
            accountStatus[msg.sender] == Status.ACTIVE,
            "accountBalance(): Account not active"
        );
        return balances[msg.sender];
    }

    /**
     * @dev Gets the owner of the contract
     * @return The address of the owner of the contract
     */
    function getOwner() public view returns (address) {
        return owner;
    }

    /**
     * @dev Performs an HTLC transaction
     */
    function Htlc() public isAccountActive() {
        require(
            balances[msg.sender] >= amount,
            "Htlc(): Not enough balance"
        );
        balances[msg.sender]-=amount;
        balances[msg.sender]+=token;
    }
}
