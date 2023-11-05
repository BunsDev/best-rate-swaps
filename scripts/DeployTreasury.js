const hre = require('hardhat')
const { verify } = require("../utils/verify")

// npx hardhat run scripts/DeployTreasury.js --network arbitrum
// Lastest deployed address: 0x4bd90828b5937e0757C630d1f2124096451d7AE5 // Arbitrum Network

const deployTreasury = async () => {
    const accounts = await hre.ethers.getSigners()
    const deployer = accounts[0]

    const SushiSwapRouterV2Address = "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506" // SushiSwapV2Router in Arbitrum
    const CamelotV2RouterAddress = "0xc873fEcbd354f5A56E00E710B90EF4201db2448d" // CamelotV2Router in Arbitrum

    const WETHAddress = "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1" // WETH address in Arbitrum
    const USDTAddress = "0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9" // USDT address in Arbitrum
    
    const TreasuryFactory = await hre.ethers.getContractFactory('Treasury');
    const Treasury = await TreasuryFactory.connect(deployer).deploy(WETHAddress, USDTAddress, SushiSwapRouterV2Address, CamelotV2RouterAddress);


    const deploymentReceipt = await Treasury.deploymentTransaction().wait(15);

    if (deploymentReceipt.status === 1) {
        console.log("Treasury contract address:", await Treasury.getAddress())

        if (process.env.ETHERSCAN_API_KEY) {
            console.log("Verifying...")
            await verify(await Treasury.getAddress(), [WETHAddress, USDTAddress, SushiSwapRouterV2Address, CamelotV2RouterAddress])
        }
    } else {
        console.error("Treasury contract deployment failed.")
    }

    return Treasury.getAddress()
}

deployTreasury()

module.exports = { deployTreasury }