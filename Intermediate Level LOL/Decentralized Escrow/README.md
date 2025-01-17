# Decentralized Escrow Smart Contract

## Overview
The Decentralized Escrow contract facilitates secure transactions between buyers and sellers by holding funds in escrow until delivery conditions are met.

## Features
- Secure fund holding
- Multi-stage transaction process
- Buyer and seller protection
- Refund capability
- Transaction tracking

## Technical Details

### Contract Structure
- `EscrowTransaction`: Struct containing transaction details
  - `buyer`: Buyer's address
  - `seller`: Seller's address
  - `amount`: Transaction amount
  - `state`: Current transaction state
  - `createdAt`: Creation timestamp

### States
1. `AWAITING_PAYMENT`
2. `AWAITING_DELIVERY`
3. `COMPLETE`
4. `REFUNDED`

### Main Functions
1. `initiateEscrow(address payable _seller)`
   - Creates new escrow transaction
   - Requires payment
   - Returns transaction ID

2. `confirmDelivery(uint256 _transactionId)`
   - Confirms delivery receipt
   - Only callable by buyer
   - Updates transaction state

3. `releaseFunds(uint256 _transactionId)`
   - Releases funds to seller
   - Only callable by buyer
   - Completes transaction

4. `refund(uint256 _transactionId)`
   - Returns funds to buyer
   - Only callable by seller
   - Cancels transaction

## Setup and Deployment

### Prerequisites
- Solidity ^0.8.0
- Ethereum development environment
- Web3 provider

### Deployment Steps
1. Deploy escrow contract
2. Test transaction flow
3. Verify security measures
4. Document contract address

## Usage Example
```javascript
// Deploy contract
const DecentralizedEscrow = await ethers.getContractFactory("DecentralizedEscrow");
const escrow = await DecentralizedEscrow.deploy();
await escrow.deployed();

// Initiate escrow
const txId = await escrow.initiateEscrow(sellerAddress, {
    value: amount
});

// Confirm delivery
await escrow.confirmDelivery(txId);

// Release funds
await escrow.releaseFunds(txId);
```

## Security Considerations
- Role-based access control
- State transition validation
- Secure fund handling
- Dispute period
- Transaction verification

## Events
- `EscrowInitiated`
- `DeliveryConfirmed`
- `FundsReleased`
- `FundsRefunded`

## License
MIT License