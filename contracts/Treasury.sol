// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./interfaces/IUniswapRouterV2.sol";
import "./interfaces/IUniswapV2Router01.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Treasury {
    using SafeERC20 for IERC20;

    IUniswapRouterV2 public sushiswapV2Router;
    IUniswapV2Router01 public camelotV2Router;

    address public WETH;
    address public USDT;
    uint256 public WETHAmount;
    event ETHDeposited(address userAddress, uint256 amount);
    event TokenSwapped(address userAddress, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address WETHAddress, address USDTAddress, address sushiswapV2RouterAddress, address camelotV2RouterAddress) {
        sushiswapV2Router = IUniswapRouterV2(sushiswapV2RouterAddress);
        camelotV2Router = IUniswapV2Router01(camelotV2RouterAddress);
        USDT = USDTAddress;
        WETH = WETHAddress;
    }

    // @notice: Function use for depositing ETH to the treasury
    function depositWETH(uint256 amount) public {
        WETHAmount += amount;
        IERC20(WETH).safeTransferFrom(msg.sender, address(this), amount);
        emit ETHDeposited(msg.sender, amount);
    }

    function swapWETHforUSDT(uint256 swapAmount, uint8 selectRouter, uint256 minAmountOut, uint256 deadline) public {
        require(WETHAmount >= swapAmount, "User has not enough balance for swap");
        WETHAmount -= swapAmount;

        if (selectRouter == 0) {
            IERC20(WETH).approve(address(sushiswapV2Router), swapAmount);
            sushiswapV2Router.swapExactTokensForTokens(swapAmount, minAmountOut, path, msg.sender, deadline);
        }

        emit TokenSwapped(msg.sender, WETH, USDT, swapAmount, amountOut);


    }


  
}