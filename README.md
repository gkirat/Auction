# Advance Auction Smart Contract


Auction is a Solidity smart contract that facilitates auction functionality for various items.

## Getting Started

1. Clone this repository: `git clone https://github.com/gkirat/Auction-new-features.git`
2. Install the required dependencies: [Solidity Compiler](https://soliditylang.org/), [Truffle Framework](https://www.trufflesuite.com/truffle)
3. Deploy the smart contract to your preferred Ethereum network.

## Features

- Register individual items for auction, including item name, base price, and minimum bid increment.
- Track the status of each item's auction (Beforeauction, Auctionlive, Sold, Auctionended).
- Keep records of the highest bid and highest bidder for each item.
- Allow the auctioneer to mark an item as "sold" once the highest bid surpasses the base price.
- Set an auction time limit for the entire auction.
- Prevent new bids and automatically mark ongoing auctions as "Auctionended" once the auction time limit is reached.
- Include an `Emergencyend()` function for the auctioneer to end the auction prematurely.
- Safeguard certain functions using modifiers to ensure they can only be executed by the contract owner or when the contract is not destroyed.

## Usage

1. Deploy the smart contract to your preferred Ethereum network.
2. Use the `registeritems()` function to register items for auction, providing the item name, base price, and minimum bid increment.
3. Participants can bid on registered items using the `bidding()` function, specifying the item ID and the bid amount.
4. The auctioneer can mark an item as "sold" using the `sold()` function once the highest bid surpasses the base price.
5. After the auction time limit is reached, the highest bidder can transfer the bid amount to the auctioneer using the `transfer()` function.
6. In case of an emergency, the auctioneer can use the `Emergencyend()` function to end the auction and destruct the contract.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
Feel free to customize the information as per your requirements and project details. The Readme files provide an overview of the features and usage instructions for each smart contract.


## Note


- This smart contract is implemented in Solidity version 0.8.0.

Feel free to update the information as needed, such as adding instructions on how to deploy the contract to a specific network and how to interact with it using a web3 provider or a client-side application. Make sure to include any additional details that would be helpful for users or developers who want to utilize your smart contract.
