// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedWallet {
    struct Lock {
        uint256 amount;
        uint256 releaseTime;
        bool released;
    }
    
    address public owner;
    mapping(uint256 => Lock) public locks;
    uint256 public lockCount;
    
    event FundsDeposited(uint256 indexed lockId, uint256 amount, uint256 releaseTime);
    event FundsReleased(uint256 indexed lockId, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function deposit(uint256 _releaseTime) external payable returns (uint256) {
        require(msg.value > 0, "Amount must be greater than 0");
        require(_releaseTime > block.timestamp, "Release time must be in the future");
        
        uint256 lockId = lockCount++;
        
        locks[lockId] = Lock({
            amount: msg.value,
            releaseTime: _releaseTime,
            released: false
        });
        
        emit FundsDeposited(lockId, msg.value, _releaseTime);
        
        return lockId;
    }
    
    function release(uint256 _lockId) external onlyOwner {
        Lock storage lock = locks[_lockId];
        
        require(!lock.released, "Funds already released");
        require(block.timestamp >= lock.releaseTime, "Funds are still locked");
        require(lock.amount > 0, "No funds to release");
        
        lock.released = true;
        
        payable(owner).transfer(lock.amount);
        
        emit FundsReleased(_lockId, lock.amount);
    }
    
    function getLock(uint256 _lockId) external view returns (
        uint256 amount,
        uint256 releaseTime,
        bool released
    ) {
        Lock storage lock = locks[_lockId];
        return (lock.amount, lock.releaseTime, lock.released);
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    function timeUntilRelease(uint256 _lockId) external view returns (uint256) {
        Lock storage lock = locks[_lockId];
        if (block.timestamp >= lock.releaseTime) {
            return 0;
        }
        return lock.releaseTime - block.timestamp;
    }
    
    receive() external payable {
        revert("Use deposit function to lock funds");
    }
}