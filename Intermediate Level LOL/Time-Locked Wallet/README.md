# Time-Locked Wallet Smart Contract

## Overview
The Time-Locked Wallet contract enables users to lock funds for a specified period, ensuring they cannot be withdrawn before the designated release time.

## Features
- Lock funds with custom release time
- Multiple separate locks
- Secure release mechanism
- Balance tracking
- Time remaining queries

## Technical Details

### Contract Structure
- `Lock`: Struct containing lock details
  - `amount`: Locked amount
  - `releaseTime`: Release timestamp
  - `released`: Release status

### Main Functions
1. `deposit(uint256 _releaseTime)`
   - Creates new time lock
   - Requires funds
   - Returns lock ID

2. `release(uint256 _lockId)`
   - Releases locked funds
   - Verifies release time
   - Only callable by owner

3. `getLock(uint256 _lockId)`
   - Returns lock details
   - Shows status and timing

4. `timeUntilRelease(uint256 _lockId)`
   - Calculates remaining time
   - Returns time in seconds

## Setup and Deployment

### Prerequisites
- Solidity ^0.8.0
- Ethereum development environment
- Web3 provider

### Deployment Steps
1. Deploy wallet contract
2. Test deposit function
3. Verify time calculations
4. Document contract address

## Usage Example
```javascript
// Deploy contract
const TimeLockedWallet = await ethers.getContractFactory("TimeLockedWallet");
const wallet = await TimeLockedWallet.deploy();
await wallet.deployed();

// Create lock
const releaseTime = Math.floor(Date.now() / 1000) + 86400; // 24 hours
const lockId = await wallet.deposit(releaseTime, {
    value: amount
});

// Check time remaining
const timeLeft = await wallet.timeUntilRelease(lockId);

// Release funds (after time has passed)
await wallet.release(lockId);
```

## Security Considerations
- Owner-only release
- Time validation
- Release status verification
- Balance checks
- Direct deposit prevention

## Events
- `FundsDeposited`
- `FundsReleased`

## License
MIT License