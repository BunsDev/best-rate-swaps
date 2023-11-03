// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

interface IUniswapV2Router01 {
    
function swapExactTokensForTokensSupportingFeeOnTransferTokens(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    address referrer,
    uint deadline
  ) external;

}