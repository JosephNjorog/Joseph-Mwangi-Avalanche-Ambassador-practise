# Voting System Smart Contract

## Overview
The Voting System smart contract allows organizations to conduct transparent and decentralized voting. It enables the addition of candidates, vote tracking, and secure voting management.

## Features
- Add candidates to the ballot
- Track votes for each candidate
- Prevent double voting
- End voting period
- View voting results

## Technical Details

### Contract Structure
- `Candidate`: Struct containing candidate information
  - `name`: Candidate's name
  - `voteCount`: Number of votes received

### Main Functions
1. `addCandidate(string memory _name)`
   - Adds a new candidate to the ballot
   - Only callable by contract owner
   - Must be called before voting ends

2. `vote(uint256 _candidateId)`
   - Allows users to vote for a candidate
   - Prevents double voting
   - Must be called before voting ends

3. `endVoting()`
   - Ends the voting period
   - Only callable by contract owner
   - Irreversible action

4. `getCandidateCount()`
   - Returns the total number of candidates

5. `getCandidate(uint256 _candidateId)`
   - Returns candidate information
   - Returns name and vote count

## Setup and Deployment

### Prerequisites
- Solidity ^0.8.0
- Ethereum development environment (Hardhat/Truffle)
- Web3 provider (MetaMask)

### Deployment Steps
1. Deploy the contract
2. Add candidates using `addCandidate` function
3. Share contract address with voters
4. Monitor voting progress
5. End voting when appropriate

## Usage Example
```javascript
// Deploy contract
const VotingSystem = await ethers.getContractFactory("VotingSystem");
const votingSystem = await VotingSystem.deploy();
await votingSystem.deployed();

// Add candidates
await votingSystem.addCandidate("Candidate 1");
await votingSystem.addCandidate("Candidate 2");

// Cast votes
await votingSystem.vote(0); // Vote for Candidate 1

// End voting
await votingSystem.endVoting();

// Get results
const [name, voteCount] = await votingSystem.getCandidate(0);
```

## Security Considerations
- Only owner can add candidates and end voting
- Each address can only vote once
- Voting must be active for votes to be cast
- Public vote counts ensure transparency

## Events
- `CandidateAdded`: Emitted when a new candidate is added
- `Voted`: Emitted when a vote is cast
- `VotingEnded`: Emitted when voting period ends

## License
MIT License