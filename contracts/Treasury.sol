// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./interfaces/IUniswapRouterV2.sol";
import "./interfaces/IUniswapV2Router01.sol";

contract Treasury {

    IUniswapRouterV2 public uniswapV2Router;
    IUniswapV2Router01 public camelotV2Router;

    address public USDT;
    mapping(address => uint256) public usersWETHBalance;
    event ETHDeposited(address userAddress, uint256 amount);

    constructor(address USDTAddress, address uniswapV2RouterAddress, address camelotV2RouterAddress) {
        uniswapV2Router = IUniswapRouterV2(uniswapV2RouterAddress);
        camelotV2Router = IUniswapV2Router01(camelotV2RouterAddress);
        USDT = USDTAddress;
    }

    // @notice: Function use for depositing ETH to the treasury
    function depositWETH() public payable {
        usersWETHBalance[msg.sender] += msg.value;
        emit ETHDeposited(msg.sender, msg.value);
    }

    function swapWETHforUSDT(uint256 amount) public {
        require(usersWETHBalance[msg.sender] >= amount, "Not enought WETH amount");
        usersWETHBalance[msg.sender] -= amount;


    }


  
}