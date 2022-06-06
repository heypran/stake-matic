// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./USDC.sol";

contract StakingRewards2 {

    uint public rewardRate = 31668017; // for min 0.01 MATIC  10% APY - 31668017 PER SEC 

    // user rewards
    mapping(address => uint) public rewards;

    // amount staked
    uint public _totalSupply;

    mapping(address => uint) public _balances;
    mapping(address => uint) public startTime;
    mapping(address => uint256) public userRewardPaid;

    // chainlink price feed
    AggregatorV3Interface private priceFeed;

    DevUSDC public devUsdc;

    constructor() {
        devUsdc = new DevUSDC("devUSDC", "dUSDC");
        priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
    }

    function rewardPerSec() public view returns (uint) {
        // realPrice = price * 10^ number of decimals 
        // rewared per sec = apy reward per sec * realPrice 
       return rewardRate * uint(getLatestPrice())/ 10 ** 8;
    }

    function earned(address account) public view returns (uint) {
        // staking time * amountStaked ( divided by 1e16 cuz our APY reward emission is for 0.01 MATIC)
        // then add previous rewards
        return  ((block.timestamp- startTime[account]) * (_balances[account] / 1e16) * rewardPerSec()) + rewards[account];
    }
   
    modifier updateReward(address account) {
        rewards[account] = earned(account);
        startTime[account]=block.timestamp;
        _;
    }

    function stake() payable external updateReward(msg.sender) {
        require(msg.value >=0.01 ether,"Min stake is 0.01");

        _totalSupply += msg.value;
        _balances[msg.sender] += msg.value;

    }

    function withdraw(uint _amount) external updateReward(msg.sender) {
        require(_balances[msg.sender] > 0,"No stake"); 
        
      
        _totalSupply -= _amount;
        _balances[msg.sender] -= _amount;
    
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success,"Fail to withdraw");

        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        devUsdc.mint(reward, msg.sender);
        userRewardPaid[msg.sender]+=reward;
    }

    function getReward() external updateReward(msg.sender) {
        require(rewards[msg.sender]>0,"No rewards");

        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;       
        devUsdc.mint(reward, msg.sender);
        userRewardPaid[msg.sender]+=reward;
    }

    function getLatestPrice() public view returns (int) {
        (
            , 
            int price,
            ,
            ,
            
        ) = priceFeed.latestRoundData();
        return price;
    }

    receive() external payable {}
}

