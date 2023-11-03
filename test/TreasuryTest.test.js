const { assert } = require("chai")
const { ethers } = require("hardhat")
const { networks } = require("../hardhat.config")

const deployerAddress = "0x01f4e56D5ee46e84Edf8595ca7A7B62a3306De76" // Random account with funds for impersonating ----Change to mine when get funds----

let deployedTreasuryAddress = "" // Deployed Treasury address in mainnet (Arbitrum)

const SushiSwapRouterV2Address = "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506" // SushiSwapV2Router in Arbitrum
const CamelotV2RouterAddress = "0xc873fEcbd354f5A56E00E710B90EF4201db2448d" // CamelotV2Router in Arbitrum

const WETHAddress = "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1" // WETH address in Arbitrum
const USDTAddress = "0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9" // USDT address in Arbitrum
let deployer

describe("Treasury tests", async function () {
    this.beforeAll(async () => {
        console.log("BeforeAll")
        Treasury = await ethers.getContractAt("Treasury", deployedTreasuryAddress)

        await hre.network.provider.request({
            method: "hardhat_impersonateAccount",
            params: [deployerAddress],
        });

        deployer = await ethers.getSigner(deployerAddress)

        // Get WETH
        const WETH = await ethers.getContractAt("IWETH", WETHAddress)
        const amountIn = 10e18.toString()
        await WETH.connect(deployer).deposit({ value: amountIn })

    });

    describe("constructor", () => {
        it("Sets starting values correctly", async function () {
            const SushiRouterV2Address_ = await Treasury.sushiswapV2Router()
            const CamelotRouterV2Address_ = await Treasury.camelotV2Router()
            const WETHAddress_ = await Treasury.WETH()
            const USDTAddress_ = await Treasury.USDC()
            assert.equal(SushiRouterV2Address_, SushiSwapRouterV2Address)
            assert.equal(CamelotRouterV2Address_, CamelotV2RouterAddress)
            assert.equal(WETHAddress_, WETHAddress)
            assert.equal(USDTAddress_, USDTAddress)
        });
    });

    describe("Deposit function", () => {
        it("Deposits any token correctly into the Treasury", async function () {
            const WETH = await ethers.getContractAt("IWETH", WETHAddress)
            const WETHBalanceBefore = await WETH.balanceOf(deployerAddress)
            const TreasuryWETHBalanceBefore = await Treasury.WETHAmount()
            await WETH.connect(deployer).approve(await Treasury.getAddress(), WETHBalanceBefore)

            const amountIn = 1e18.toString()
            const deposit = await Treasury.connect(deployer).depositWETH(amountIn)

            const WETHBalanceAfter = await WETH.balanceOf(deployerAddress)
            const TreasuryWETHBalanceAfter = await Treasury.WETHAmount()

            await WETH.connect(deployer).balanceOf()
            assert(WETHBalanceBefore > WETHBalanceAfter)
            assert(TreasuryWETHBalanceBefore < TreasuryWETHBalanceAfter)
        });
    })
})