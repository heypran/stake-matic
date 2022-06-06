# Staking contracts

Refer contracts inside `contracts` folder

[Contract](https://mumbai.polygonscan.com/address/0x34fac770D9C4F36462d14f361889F13Bdc8d78B2)
`0x34fac770D9C4F36462d14f361889F13Bdc8d78B2`

https://mumbai.polygonscan.com/address/0x34fac770D9C4F36462d14f361889F13Bdc8d78B2

Min Stake - 0.01 Matic

Some considerations -

- Since reward pool is not fixed, like in version of Synthetics, reward emission is based on price
- Chainlink adapters can be used to update rewardEmissionRate on daily basis
- Reward token can be deployed separately with permission to allow main Staking contract to mint
- Events can be added
