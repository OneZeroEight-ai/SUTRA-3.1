const hre = require("hardhat");

async function main() {
  console.log("Deploying SUTRA 3 contracts...");

  // Get the deployer's address
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

  // Deploy ConfigurationManager
  const ConfigurationManager = await ethers.getContractFactory("ConfigurationManager");
  const configManager = await ConfigurationManager.deploy(deployer.address);
  await configManager.waitForDeployment();
  console.log("ConfigurationManager deployed to:", await configManager.getAddress());

  // Deploy AlignmentMetrics
  const AlignmentMetrics = await ethers.getContractFactory("AlignmentMetrics");
  const alignmentMetrics = await AlignmentMetrics.deploy(deployer.address);
  await alignmentMetrics.waitForDeployment();
  console.log("AlignmentMetrics deployed to:", await alignmentMetrics.getAddress());

  // Deploy AlignmentToken
  const AlignmentToken = await ethers.getContractFactory("AlignmentToken");
  const alignmentToken = await AlignmentToken.deploy(
    "Sustainable Token for Alignment", // Name
    "SUTRA",                           // Symbol
    deployer.address                   // Admin address
  );
  await alignmentToken.waitForDeployment();
  console.log("AlignmentToken deployed to:", await alignmentToken.getAddress());

  // Set up the contract references
  console.log("Setting up contract references...");

  // Set references in ConfigurationManager
  const configManagerAddress = await configManager.getAddress();
  const alignmentMetricsAddress = await alignmentMetrics.getAddress();
  const alignmentTokenAddress = await alignmentToken.getAddress();

  // Set references in ConfigurationManager
  await configManager.setTokenAddress(alignmentTokenAddress);
  await configManager.setMetricsAddress(alignmentMetricsAddress);
  console.log("ConfigurationManager references set");

  // Set references in AlignmentMetrics
  await alignmentMetrics.setTokenAddress(alignmentTokenAddress);
  await alignmentMetrics.setConfigManagerAddress(configManagerAddress);
  console.log("AlignmentMetrics references set");

  // Set references in AlignmentToken
  await alignmentToken.setAlignmentMetricsAddress(alignmentMetricsAddress);
  console.log("AlignmentToken references set");

  // Grant roles
  // Grant the metrics provider role to the deployer
  const METRICS_PROVIDER_ROLE = ethers.keccak256(ethers.toUtf8Bytes("METRICS_PROVIDER_ROLE"));
  await alignmentMetrics.grantRole(METRICS_PROVIDER_ROLE, deployer.address);
  
  // Grant the minter role to the deployer
  const MINTER_ROLE = ethers.keccak256(ethers.toUtf8Bytes("MINTER_ROLE"));
  await alignmentToken.grantRole(MINTER_ROLE, deployer.address);
  
  console.log("Roles granted to deployer");

  console.log("Deployment complete!");

  // Return the deployed contract addresses
  return {
    configManager: configManagerAddress,
    alignmentMetrics: alignmentMetricsAddress,
    alignmentToken: alignmentTokenAddress
  };
}

// Execute the deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });