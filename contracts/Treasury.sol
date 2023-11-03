// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./interfaces/IUniswapRouterV2.sol";
import "./interfaces/IUniswapV2Router01.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Treasury is ReentrancyGuard {
    using SafeERC20 for IERC20;

    IUniswapRouterV2 public sushiswapV2Router;
    IUniswapV2Router01 public camelotV2Router;

    address public WETH;
    address public USDT;
    uint256 public WETHAmount;
    event ETHDeposited(address userAddress, uint256 amount);
    event USDTWithdrew(uint256 amount, address receiver);
    event TokenSwapped(address userAddress, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address WETHAddress, address USDTAddress, address sushiswapV2RouterAddress, address camelotV2RouterAddress) {
        sushiswapV2Router = IUniswapRouterV2(sushiswapV2RouterAddress);
        camelotV2Router = IUniswapV2Router01(camelotV2RouterAddress);
        USDT = USDTAddress;
        WETH = WETHAddress;
    }

    // @notice: Function use for depositing WETH to the treasury
    function depositWETH(uint256 amount) public {
        WETHAmount += amount;
        IERC20(WETH).safeTransferFrom(msg.sender, address(this), amount);
        emit ETHDeposited(msg.sender, amount);
    }

    // @notice: Function use for swapping from WETH to USDT using 2 different providers
    function swapWETHforUSDT(address[] memory path, uint256 swapAmount, uint8 selectRouter, uint256 minAmountOut, uint256 deadline) nonReentrant public {
        require(path[0] == WETH, "You are only allowed to swap from WETH");
        require(path[path.length - 1] == USDT, "You are only allowed to swap to USDT");
        require(WETHAmount >= swapAmount, "User has not enough balance for swap");
        WETHAmount -= swapAmount;

        uint256 USDTAmountBefore = IERC20(USDT).balanceOf(address(this));
        if (selectRouter == 0) {
            IERC20(WETH).approve(address(sushiswapV2Router), swapAmount);
            sushiswapV2Router.swapExactTokensForTokens(swapAmount, minAmountOut, path, address(this), deadline);
        } else {
            IERC20(WETH).approve(address(camelotV2Router), swapAmount);
            camelotV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(swapAmount, minAmountOut, path, address(this), address(this), deadline);
        }
        uint256 USDTAmountAfter = IERC20(USDT).balanceOf(address(this));

        emit TokenSwapped(msg.sender, WETH, USDT, swapAmount, USDTAmountAfter - USDTAmountBefore);
    }

    // @notice: Function use for withdrawing all the USDT in the Treasury
    function withdrawAllUSDT() nonReentrant public {
        uint256 USDTAmount = IERC20(USDT).balanceOf(address(this));
        IERC20(USDT).transfer(msg.sender, USDTAmount);
        emit USDTWithdrew(USDTAmount, msg.sender);
    }
}