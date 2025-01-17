# Multi-Signature Wallet Smart Contract

## Overview
The Multi-Signature Wallet implements a secure transaction system requiring multiple approvals before execution. This contract is ideal for shared funds management and enhanced security implementations.

## Features
- Multiple wallet owners
- Configurable number of required approvals
- Transaction submission and approval system
- Secure execution of approved transactions

## Technical Details

### Contract Structure
- `Transaction`: Struct containing transaction details
  - `to`: Destination address
  - `value`: Amount to transfer
  - `data`: Transaction data
  - `executed`: Execution status
  - `approvalCount`: Number of approvals received

### Main Functions
1. `submitTransaction(address _to, uint256 _value, bytes memory _data)`
   - Submits a new transaction for approval
   - Only callable by owners
   - Returns transaction ID

2. `approveTransaction(uint256 _txIndex)`
   - Approves a pending transaction
   - Only callable by owners
   - Cannot approve same transaction twice

3. `executeTransaction(uint256 _txIndex)`
   - Executes an approved transaction
   - Requires minimum approval threshold
   - Only callable by owners

4. `getTransactionCount()`
   - Returns total number of transactions

## Setup and Deployment

### Prerequisites
- Solidity ^0.8.0
- Ethereum development environment
- Multiple owner addresses

### Deployment Steps
1. Prepare list of owner addresses
2. Determine required number of approvals
3. Deploy contract with owners and approval threshold
4. Verify owner access

## Usage Example
```javascript
// Deploy contract
const owners = [address1, address2, address3];
const requiredApprovals = 2;
const MultiSigWallet = await ethers.getContractFactory("MultiSigWallet");
const wallet = await MultiSigWallet.deploy(owners, requiredApprovals);
await wallet.deployed();

// Submit transaction
const txIndex = await wallet.submitTransaction(recipient, amount, data);

// Approve transaction
await wallet.approveTransaction(txIndex);

// Execute transaction
await wallet.executeTransaction(txIndex);
```

## Security Considerations
- Multiple signatures required for execution
- Owner verification for all operations
- Transaction existence verification
- Prevention of double approvals
- Reentrancy protection

## Events
- `OwnerAdded`: Emitted when new owner is added
- `TransactionSubmitted`: Emitted for new transactions
- `TransactionApproved`: Emitted for transaction approvals
- `TransactionExecuted`: Emitted after successful execution

## License
MIT License