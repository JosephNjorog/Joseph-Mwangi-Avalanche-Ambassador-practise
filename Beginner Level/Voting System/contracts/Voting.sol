// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Candidate {
        string name;
        uint256 voteCount;
    }
    
    address public owner;
    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;
    bool public votingEnded;
    
    event CandidateAdded(string name);
    event Voted(address voter, uint256 candidateId);
    event VotingEndeded(uint256 timestamp);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier votingActive() {
        require(!votingEnded, "Voting has ended");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function addCandidate(string memory _name) public onlyOwner votingActive {
        candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));
        emit CandidateAdded(_name);
    }
    
    function vote(uint256 _candidateId) public votingActive {
        require(_candidateId < candidates.length, "Invalid candidate ID");
        require(!hasVoted[msg.sender], "Already voted");
        
        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;
        
        emit Voted(msg.sender, _candidateId);
    }
    
    function endVoting() public onlyOwner votingActive {
        votingEnded = true;
        emit VotingEndeded(block.timestamp);
    }
    
    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }
    
    function getCandidate(uint256 _candidateId) public view returns (string memory name, uint256 voteCount) {
        require(_candidateId < candidates.length, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }
}