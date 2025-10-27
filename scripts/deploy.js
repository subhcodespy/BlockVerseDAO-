const hre = require("hardhat");

async function main() {
  console.log("Starting deployment...");
  
  // Get the deployer account
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  
  // Get account balance
  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(balance), "CORE");

  // Deploy the Project contract
  console.log("\nDeploying BlockVerseDAO Project contract...");
  const Project = await hre.ethers.getContractFactory("Project");
  const project = await Project.deploy();
  
  await project.waitForDeployment();
  const projectAddress = await project.getAddress();

  console.log("\n✅ BlockVerseDAO Project contract deployed successfully!");
  console.log("📍 Contract Address:", projectAddress);
  console.log("🔗 Network: Core Testnet 2");
  console.log("🌐 RPC URL: https://rpc.test2.btcs.network");
  
  console.log("\n📋 Contract Details:");
  console.log("- Owner:", await project.owner());
  console.log("- Member Count:", (await project.memberCount()).toString());
  console.log("- Proposal Count:", (await project.proposalCount()).toString());

  console.log("\n📝 Save this information:");
  console.log("================================");
  console.log(`CONTRACT_ADDRESS=${projectAddress}`);
  console.log("================================");
  
  console.log("\n🎉 Deployment completed successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:");
    console.error(error);
    process.exit(1);
  });