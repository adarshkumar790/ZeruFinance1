async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Protocol = await ethers.getContractFactory("Protocol");
  const protocol = await Protocol.deploy(
    "0x0000000000000000000000000000000000000001", // CHAINLINK_ARB_ADDRESS
    "0x0000000000000000000000000000000000000002", // CHAINLINK_USDC_ADDRESS
    "0x0000000000000000000000000000000000000003", // UNISWAP_V3_POOL_ADDRESS
    "0x0000000000000000000000000000000000000004", // UNISWAP_V3_ROUTER_ADDRESS
    "0x0000000000000000000000000000000000000005", // ARB_TOKEN_ADDRESS
    "0x0000000000000000000000000000000000000006"  // USDC_TOKEN_ADDRESS
  );

  console.log("Protocol deployed to:", protocol.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
