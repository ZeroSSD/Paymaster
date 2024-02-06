// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {Paymaster} from "../src/Paymaster.sol";

contract PaymasterTest is Test {
    Paymaster public paymaster;
    function setUp() public {
        paymaster = new Paymaster();
    }

    function test_deposit() public {
        address client = address(0xabcdef0123456789012345678901234567890123);
        uint256 amount = 100 ether;

        paymaster.addClient(client);
        paymaster.deposit(client, amount);

        assertEq(paymaster.clientBalances(client), amount);
        assertEq(console.log(paymaster.Deposit(client, amount)), true); // Check event emitted
    }
    function test_checkBalance() public {
        address client = address(0xabcdef0123456789012345678901234567890123);
        uint256 amount = 50 ether;

        paymaster.addClient(client);
        paymaster.deposit(client, amount);

        assertEq(paymaster.checkBalance(client), amount);
    }
    // function testAddClient() public {
    //     address client = address(0x1);
    //     paymaster.addClient(client);
    //     bool isClient = paymaster.isClient(client);
    //     assert.isTrue(isClient, "Client should be added successfully");
    // }

    // function testDeposit() public {
    //     address client = address(0x1);
    //     uint256 amount = 100;
    //     paymaster.addClient(client);
    //     paymaster.deposit(client, amount);
    //     uint256 balance = paymaster.checkBalance(client);
    //     assert.equal(balance, amount, "Client balance should be updated");
    // }

    // function testCheckBalance() public {
    //     address client = address(0x1);
    //     uint256 amount = 100;
    //     paymaster.addClient(client);
    //     paymaster.deposit(client, amount);
    //     uint256 balance = paymaster.checkBalance(client);
    //     assert.equal(balance, amount, "Client balance should be correct");
    // }
    // function setUp() public {
    //     paymaster = new paymaster();
    //     paymaster.setNumber(0);
    // }

    // function test_Increment() public {
    //     paymaster.increment();
    //     assertEq(paymaster.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     paymaster.setNumber(x);
    //     assertEq(paymaster.number(), x);
    // }
}
// assertEq(console.log(paymaster.ClientAdded(client)), true); // Check event emitted
