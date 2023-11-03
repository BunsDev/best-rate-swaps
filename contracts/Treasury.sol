// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "./interfaces/IUniswapRouterV2.sol";
import "./interfaces/IUniswapV2Router01.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Treasury {
    using SafeERC20 for IERC20;

    IUniswapRouterV2 public sushiswapV2Router;
    IUniswapV2Router01 public camelotV2Router;

    address public USDT;
    mapping(address => uint256) public usersWETHBalance;
    event ETHDeposited(address userAddress, uint256 amount);

    constructor(address USDTAddress, address sushiswapV2RouterAddress, address camelotV2RouterAddress) {
        sushiswapV2Router = IUniswapRouterV2(sushiswapV2RouterAddress);
        camelotV2Router = IUniswapV2Router01(camelotV2RouterAddress);
        USDT = USDTAddress;
    }

    // @notice: Function use for depositing ETH to the treasury
    function depositWETH(uint256 amount) public {
        usersWETHBalance[msg.sender] += amount;
        IERC20(USDT).safeTransferFrom(msg.sender, address(this), amount);
        emit ETHDeposited(msg.sender, amount);
    }

    function swapWETHforUSDT(uint256 amount) public {
        require(usersWETHBalance[msg.sender] >= amount, "Not enought WETH amount");
        usersWETHBalance[msg.sender] -= amount;


    }


  
}