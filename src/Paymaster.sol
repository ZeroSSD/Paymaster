// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Paymaster - Managing accounts and transactions
/// @author Sahil S. Dhumale
/// @notice This contract allows a Bank to manage account balances with values of a single currency on behalf of its Clients.

contract Paymaster {
    address public bank;
    address public client;
    mapping(address => uint256) public balances;

    /// @dev Restricts the access to only the Bank.
    modifier onlyBank() {
        require(msg.sender == bank, "Access restricted to the Bank");
        _;
    }

    /// @dev Restricts the access to only the Client.
    modifier onlyClient() {
        require(msg.sender == client, "Access restricted to the Client");
        _;
    }

    /// @dev Initializes the contract with the address of the Bank and the Client.
    constructor(address _bank, address _client) {
        bank = _bank;
        client = _client;
    }

    /// @notice Get the balance remaining in the client's account.
    /// @dev Returns the balance as a uint256.
    /// @return Balance remaining in the client's account.
    function balanceOf() external view onlyBank() returns (uint256) {
        return balances[client];
    }

    /// @notice Deposit funds into the specified address.
    /// @dev Only the client can deposit funds.
    /// @param toAddress The address to which funds are deposited.
    /// @param amount The amount of funds to deposit.
    function deposit(address toAddress, uint256 amount) public onlyClient {
        balances[toAddress] += amount;
    }

    /// @notice Transfer funds from one address to another.
    /// @dev Only the client can initiate the transfer.
    /// @param fromAddress The address from which funds are transferred.
    /// @param toAddress The address to which funds are transferred.
    /// @param amount The amount of funds to transfer.
    function transferFrom(address fromAddress, address toAddress, uint256 amount) public onlyClient {
        require(balances[fromAddress] >= amount, "Insufficient funds for transfer");
        balances[fromAddress] -= amount;
        balances[toAddress] += amount;
    }
}







// Acceptance Criteria:

// Create a private GitHub repository and make sure to push your code into that repository and share it with us.
// Both Bank and their Clients have Ethereum addresses (Externally Owned Accounts).
// We can query for the balances of a specific Client/user by calling the balanceOf(address) function.
// Clients accounts have a balance represented by a uint256 value.
// Clients can call a deposit(toAddress, amount) function to initiate adding value to a client's balance, but each specific transaction must be approved by banks before the balance is updated.
// Clients can call a transferFrom(fromAddress, toAddress, amount) function to transfer value between Client accounts, but each specific transaction must be authorized by both the Client owner and the Bank before the balance can be updated.
// The contract(s) should be correct and secure. Include any unit tests or security specifications. You may use any testing framework you’re comfortable with, but Foundry is preferred.
// Add a README.md detailing how to run your tests from a fresh machine.
// Suggestions / Tips
// Help your users - document the code using NatSpec, emit appropriate events.
// You may use any existing smart contract libraries or EIP standards where applicable.
// The contract should be gas efficient, but readability is still the top priority.
// Bonus
// Use conventional commits specification Conventional Commits
// Create an atomic swap contract that allows someone to exchange a specific amount of balance from PaymasterLedger with a specific amount of a standard ERC20 token (e.g. WETH9). You may add additional functions to the PaymasterLedger but note that existing security assumptions remain. e.g.:
// Funds cannot be moved from an account without both the Client owner and the Bank’s approval (implicit or explicit - you may list any assumptions or rationale in your README.md file).








