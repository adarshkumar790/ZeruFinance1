require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.0",
  networks: {
    arbitrumSepolia: {
      url: "https://arb-sepolia.g.alchemy.com/v2/zOqi5xn38BylY0ZbjEWNiK89EU7xnORO",
      accounts: [`0x7f780ccbb62bc4f5021beb0ae4800b021ae78f60b474705e0a3e27c71df6c252`]
    }
  },
  etherscan: {
    apiKey: {
      // mainnet: ETHERSCAN_API_KEY,
      // arbitrumOne: ARBISCAN_API_KEY,
      // avalanche: SNOWTRACE_API_KEY,
      // bsc: BSCSCAN_API_KEY,
      // polygon: POLYGONSCAN_API_KEY,
      // optimisticEthereum: OPTIMISTIC_API_KEY,
      // base: BASESCAN_API_KEY,
      arbitrumSepolia:"KR5VFMG3BRIYWPUCQH3Y1WXR79DNRFNCT2"
    },
    customChains: [
      {
        network: "arbitrumSepolia",
        chainId: 421614,
        urls: {
          apiURL: "https://api-sepolia.arbiscan.io/api",
          browserURL: "https://sepolia.arbiscan.io/"
        }
      }
    ]
  },
};
