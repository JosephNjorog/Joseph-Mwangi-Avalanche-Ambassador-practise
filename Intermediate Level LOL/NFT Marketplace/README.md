# NFT Marketplace Smart Contract

## Overview
The NFT Marketplace contract enables users to list, buy, and sell NFTs. It supports ERC721 tokens and includes features for secure transactions and marketplace management.

## Features
- List NFTs for sale
- Purchase listed NFTs
- Track market items
- Manage listing fees
- View market inventory

## Technical Details

### Contract Structure
- `MarketItem`: Struct containing item details
  - `itemId`: Unique identifier
  - `nftContract`: NFT contract address
  - `tokenId`: Token identifier
  - `seller`: Seller's address
  - `owner`: Current owner's address
  - `price`: Sale price
  - `sold`: Sale status

### Main Functions
1. `createMarketItem(address nftContract, uint256 tokenId, uint256 price)`
   - Lists new NFT for sale
   - Requires listing fee
   - Transfers NFT to contract

2. `createMarketSale(address nftContract, uint256 itemId)`
   - Purchases listed NFT
   - Handles payment distribution
   - Transfers NFT to buyer

3. `fetchMarketItems()`
   - Returns all unsold items
   - Provides market inventory

## Setup and Deployment

### Prerequisites
- Solidity ^0.8.0
- OpenZeppelin contracts
- ERC721 implementation
- Web3 provider

### Deployment Steps
1. Deploy marketplace contract
2. Set listing price
3. Configure NFT contract integration
4. Test listing and purchase flow

## Usage Example
```javascript
// Deploy contract
const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
const marketplace = await NFTMarketplace.deploy();
await marketplace.deployed();

// List NFT
const listingPrice = await marketplace.getListingPrice();
await marketplace.createMarketItem(nftContract, tokenId, price, {
    value: listingPrice
});

// Purchase NFT
await marketplace.createMarketSale(nftContract, itemId, {
    value: price
});
```

## Security Considerations
- Reentrancy protection
- Secure payment handling
- NFT ownership verification
- Price validation
- Transfer verification

## Events
- `MarketItemCreated`: Emitted when item listed
- Details seller, price, and NFT information

## License
MIT License