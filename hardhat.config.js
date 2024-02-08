require("@nomicfoundation/hardhat-toolbox");
require('hardhat-deploy');
require('@nomicfoundation/hardhat-ethers');
require('hardhat-deploy-ethers');

/** @type import('hardhat/config').HardhatUserConfig */

const SEPOLIA_RPC_URL =
    "https://eth-sepolia.g.alchemy.com/v2/XDehziHF9iCoSqkHftGed6mcttpD03Gs"
const PRIVATE_KEY =
    "26ff954bfa6ac8fb4408eba97c2b44a12155015555cda894f1c533a289d89202"
const ETHERSCAN_API_KEY = "HGZ8FBD8QYTN64IS8E1JZKJKVIGEYK24SA"
module.exports = {
  solidity: "0.8.17",
  networks: {sepolia: {
    url: SEPOLIA_RPC_URL,
    accounts: [PRIVATE_KEY]
  }},
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};