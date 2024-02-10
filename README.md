<h1 align="center">Paymaster Ledger</h3>


# Table of Contents

* [Problem Statement](#ps)
* [Acceptance Criteria](#acceptance-criteria)
* [Tools Used](#tools-used)
* [System Architecture](#system-architecture)
* [Assumptions](#assumptions)
* [Implementation Details](#implementation)


## Problem Statement

As a Bank, I want to be able to manage account balances with values of a single currency on behalf of my Clients.

## Acceptance Criteria:

1. Create a private GitHub repository and make sure to push your code into that repository and share it with us. 
2. Both Bank and their Clients have Ethereum addresses (Externally Owned Accounts).
3. We can query for the balances of a specific Client/user by calling the balanceOf(address) function.
4. Clients accounts have a balance represented by a uint256 value.
5. Clients can call a deposit(toAddress, amount) function to initiate adding value to a client's balance, but each specific transaction must be approved by banks before the balance is updated.
6. Clients can call a transferFrom(fromAddress, toAddress, amount) function to transfer value between Client accounts, but each specific transaction must be authorized by both the Client owner and the Bank before the balance can be updated.
7. The contract(s) should be correct and secure. Include any unit tests or security specifications. You may use any testing framework you’re comfortable with, but Foundry is preferred.
8. Add a README.md detailing how to run your tests from a fresh machine.

### Suggestions / Tips

1. Help your users - document the code using NatSpec, emit appropriate events.
2. You may use any existing smart contract libraries or EIP standards where applicable.
3. The contract should be gas efficient, but readability is still the top priority.

### Bonus

1. Use conventional commits specification Conventional Commits
2. Create an atomic swap contract that allows someone to exchange a specific amount of balance from PaymasterLedger with a specific amount of a standard ERC20 token (e.g. WETH9). You may add additional functions to the PaymasterLedger but note that existing security assumptions remain. e.g.:
3. Funds cannot be moved from an account without both the Client owner and the Bank’s approval (implicit or explicit - you may list any assumptions or rationale in your README.md file).

## Tools Used

1. Solidity
2. HardHat
3. Sepolia TestNet
4. Alchemy


## System Architecture




## Assumptions

1. The implementation of deposit(), balanceOf() and tranferFrom() functions has been done in a single contract while a separate contract has been created for atomic swap.
2. To provide a proper definition of account approval an account status parameter has been implemented which considers the 5 statuses- Not Requested, Requested, Paused, Active, Closed. If the account has requested for a deposit or transfer of amount, it's status is checked by the bank for approval purpose


## Implementation Details

### Functions
* openAccount()
* approveAccount()
* pauseAccount()
* unPauseAccount()
* closeAccount()
* deposit()
* withdraw()
* transferAccount()
* getAccountStatus()
* accountBalance()
* getOwner()
* Htlc()

### Modifiers
* onlyOwner()
* isAccountPaused()
* isAccountActive()
