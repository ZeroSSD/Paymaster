const { expect, assert } = require("chai");
const { ethers, deployments } = require("hardhat");

describe("Paymaster", () => {
      let accounts, paymaster;
      beforeEach(async () => {
        accounts = await ethers.getSigners();
        await deployments.fixture(["all"]);
        paymaster = await ethers.deployContract("Paymaster");
        // console.log("Paymaster address:", paymaster.address);
        // console.log("Paymaster bytecode:", paymaster.bytecode);
        // console.log("Paymaster instance:", paymaster);
        let tx = await paymaster.openAccount();
        await tx.wait();

        let tx1 = await paymaster.approveAccount(accounts[0].address);
        await tx1.wait();
      });

      describe("Starting Test", () => {
        it("Check owner, account status will be not requested", async () => {
          let owner = await paymaster.getOwner();
          assert.equal(accounts[0].address, owner);
          assert.equal(await paymaster.getAccountStatus(), 2);
        });
        it("Open new account and owner approve, cannot request new account if already open, cannot approve non existing account", async () => {
          assert.equal(await paymaster.getAccountStatus(), 2);

          await expect(
            paymaster.openAccount(),
            "openAccount(): You already opened a account"
          );

          await expect(
            paymaster.approveAccount(accounts[2].address),
            "approveAccount(): Account request does not exists"
          );
        });

        it("Cannot deposit if account not active, deposit amount should be greater than zero, can deposit and check balance, withdraw amount from account, cannot withdraw more than balance or account not active", async () => {
          let bank1 = await paymaster.connect(accounts[1]);
          await expect(
            bank1.deposit({ value: ethers.parseEther("1.00",) })
          ).to.be.revertedWith("Account not active");

          await expect(
            paymaster.deposit({ value: ethers.parseEther("0.00") })
          ).to.be.revertedWith(
            "deposit(): Deposit Amount should be greater than zero"
          );
          let tx = await paymaster.deposit({ value: ethers.parseEther("1.00") });
          await tx.wait();

          assert(
            (await paymaster.accountBalance()).toString() ==
              ethers.parseEther("1").toString()
          );

          let tx1 = await paymaster.withdraw(ethers.parseEther("0.5"));
          await tx1.wait();
          assert(
            (await paymaster.accountBalance()).toString() ==
              ethers.parseEther("0.5").toString()
          );

          await expect(
            paymaster.withdraw(ethers.parseEther("1"))
          ).to.be.revertedWith("withdraw(): Not enough balance");
          await expect(
            bank1.withdraw(ethers.parseEther("1"))
          ).to.be.revertedWith("Account not active");
        });

        it("Cannot transfer amount if dont have enough balance,", async () => {
          let bank1 = await paymaster.connect(accounts[1]);
          let tx_1 = await paymaster.deposit({
            value: ethers.parseEther("1"),
          });
          await tx_1.wait();
          await expect(
            bank1.transferAmount(
              accounts[1].address,
              ethers.parseEther("0.5")
            )
          ).to.be.revertedWith("Account not active");

          let tx = await paymaster.transferAmount(
            accounts[1].address,
            ethers.parseEther("0.5")
          );
          await tx.wait();

          let tx1 = await bank1.openAccount();
          await tx1.wait();
          await expect(
            bank1.approveAccount(accounts[1].address)
          ).to.be.revertedWith("You are not owner");
          let tx2 = await paymaster.approveAccount(accounts[1].address);
          await tx2.wait();

          assert.equal(
            (await bank1.accountBalance()).toString(),
            ethers.parseEther("0.5").toString()
          );
        });
        it("Pause/unpause account, cannot pause if not active, cannot unpause if not paused, close account, cannot close if account not active", async () => {
          let tx = await paymaster.pauseAccount();
          await tx.wait();
          assert.equal(await paymaster.getAccountStatus(), 3);
          await expect(paymaster.pauseAccount()).to.be.revertedWith(
            "Account not active"
          );

          let tx1 = await paymaster.unPauseAccount();
          await tx1.wait();
          assert.equal(await paymaster.getAccountStatus(), 2);
          await expect(paymaster.unPauseAccount()).to.be.revertedWith(
            "Account not paused"
          );
          let tx4 = await paymaster.deposit({ value: ethers.parseEther("1") });
          await tx4.wait();
          await expect(paymaster.closeAccount()).to.be.revertedWith(
            "closeAccount(): Withdraw all your balance to close"
          );
          let tx5 = await paymaster.withdraw(ethers.parseEther("1"));
          await tx5.wait();

          let tx2 = await paymaster.closeAccount();
          await tx2.wait();

          assert.equal(await paymaster.getAccountStatus(), 4);
          await expect(paymaster.closeAccount()).to.be.revertedWith(
            "Account not active"
          );
        });
      });
    });


