

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Paymaster = await ethers.getContractFactory("Paymaster");
  const paymaster = await Paymaster.deploy();
  await paymaster.waitForDeployment();

  console.log("Contract deployed to address:", paymaster.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});

