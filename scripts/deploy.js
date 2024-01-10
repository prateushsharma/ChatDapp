const {ethers} = require("hardhat");
async function main() {
  const ChatApp = await ethers.getContractFactory("ChatApp");
  const chatApp = await ChatApp.deploy();
 
  if (typeof chatApp.deployed === "function") {
     await chatApp.deployed(); // Wait for the contract to be deployed
  }
  //chatApp.address was giving undefined hence
  // i used chatApp.target just to carry on with my project
  console.log(`contract addres using .address: ${chatApp.address}`);
  console.log(` Contract Address using .target: ${chatApp.target}`);
 }
 
 main().catch((error) => {
  console.error(error);
  process.exitcode = 1;
 });