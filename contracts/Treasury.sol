// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract Treasury {

    mapping(address => uint256) usersWETHBalance;
    event ETHDeposited(address userAddress, uint256 amount);

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