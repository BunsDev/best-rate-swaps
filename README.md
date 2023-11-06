# BEST RATES SWAPS

Welcome to Best Swaps Rates. Within this application, you will have the opportunity to perform WETH-USDT swaps across various decentralized exchanges (DEXs) while selecting the most favorable exchange rate available. Currently deployed in Arbitrum.

- Deployed website: [Best-Rates-Swaps](https://best-rates-swaps-ui.vercel.app/).
- Best Rates Swaps UI repository: [Repository](https://github.com/JMariadlcs/best-rates-swaps-ui).
- Smart Contract address: [Treasury.sol](0x997d3168776d9AF7A60d3664E1e69704e72F38b0).

The contract has been deployed to the Arbitrum network an its main functionalities are:
1. Any user has the option to deposit WETH tokens, and these tokens are pooled together within the contract without individual tracking for each user.
2. Any user can access the platform and initiate a swap for the entire WETH balance held within the contract. The swap is facilitated through the exchange that provides the most favorable rate, as indicated by our frontend interface.
3. Any user can withdraw the USDT amount of tokens held in the Treasury.
4. There is a button available for users to retrieve the WETH and USDT token balances of the Treasury contract at any given moment.