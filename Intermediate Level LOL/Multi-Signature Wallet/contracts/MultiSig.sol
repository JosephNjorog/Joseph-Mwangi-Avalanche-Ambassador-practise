// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 approvalCount;
    }
    
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public requiredApprovals;
    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approvals;
    
    event OwnerAdded(address owner);
    event TransactionSubmitted(uint256 indexed txIndex, address indexed to, uint256 value);
    event TransactionApproved(uint256 indexed txIndex, address indexed owner);
    event TransactionExecuted(uint256 indexed txIndex);
    
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }
    
    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }
    
    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }
    
    modifier notApproved(uint256 _txIndex) {
        require(!approvals[_txIndex][msg.sender], "Transaction already approved");
        _;
    }
    
    constructor(address[] memory _owners, uint256 _requiredApprovals) {
        require(_owners.length > 0, "Owners required");
        require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, 
                "Invalid number of required approvals");
        
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");
            
            isOwner[owner] = true;
            owners.push(owner);
        }
        
        requiredApprovals = _requiredApprovals;
    }
    
    receive() external payable {}
    
    function submitTransaction(address _to, uint256 _value, bytes memory _data) 
        public onlyOwner returns (uint256) 
    {
        uint256 txIndex = transactions.length;
        
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            approvalCount: 0
        }));
        
        emit TransactionSubmitted(txIndex, _to, _value);
        return txIndex;
    }
    
    function approveTransaction(uint256 _txIndex) 
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notApproved(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.approvalCount += 1;
        approvals[_txIndex][msg.sender] = true;
        
        emit TransactionApproved(_txIndex, msg.sender);
    }
    
    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        
        require(transaction.approvalCount >= requiredApprovals, 
                "Not enough approvals");
        
        transaction.executed = true;
        
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "Transaction failed");
        
        emit TransactionExecuted(_txIndex);
    }
    
    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }
}