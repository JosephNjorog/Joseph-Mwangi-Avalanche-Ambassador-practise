// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedEscrow {
    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED }
    
    struct EscrowTransaction {
        address payable buyer;
        address payable seller;
        uint256 amount;
        State state;
        uint256 createdAt;
    }
    
    mapping(uint256 => EscrowTransaction) public transactions;
    uint256 public transactionCount;
    uint256 public constant DISPUTE_PERIOD = 7 days;
    
    event EscrowInitiated(uint256 indexed transactionId, address buyer, address seller, uint256 amount);
    event DeliveryConfirmed(uint256 indexed transactionId);
    event FundsReleased(uint256 indexed transactionId);
    event FundsRefunded(uint256 indexed transactionId);
    
    modifier onlyBuyer(uint256 _transactionId) {
        require(msg.sender == transactions[_transactionId].buyer, "Only buyer can call this");
        _;
    }
    
    modifier onlySeller(uint256 _transactionId) {
        require(msg.sender == transactions[_transactionId].seller, "Only seller can call this");
        _;
    }
    
    modifier inState(uint256 _transactionId, State _state) {
        require(transactions[_transactionId].state == _state, "Invalid state");
        _;
    }
    
    function initiateEscrow(address payable _seller) external payable returns (uint256) {
        require(msg.value > 0, "Amount must be greater than 0");
        require(_seller != address(0) && _seller != msg.sender, "Invalid seller address");
        
        uint256 transactionId = transactionCount++;
        
        transactions[transactionId] = EscrowTransaction({
            buyer: payable(msg.sender),
            seller: _seller,
            amount: msg.value,
            state: State.AWAITING_PAYMENT,
            createdAt: block.timestamp
        });
        
        emit EscrowInitiated(transactionId, msg.sender, _seller, msg.value);
        
        return transactionId;
    }
    
    function confirmDelivery(uint256 _transactionId) 
        external 
        onlyBuyer(_transactionId)
        inState(_transactionId, State.AWAITING_PAYMENT)
    {
        EscrowTransaction storage transaction = transactions[_transactionId];
        transaction.state = State.AWAITING_DELIVERY;
        
        emit DeliveryConfirmed(_transactionId);
    }
    
    function releaseFunds(uint256 _transactionId)
        external
        onlyBuyer(_transactionId)
        inState(_transactionId, State.AWAITING_DELIVERY)
    {
        EscrowTransaction storage transaction = transactions[_transactionId];
        transaction.state = State.COMPLETE;
        transaction.seller.transfer(transaction.amount);
        
        emit FundsReleased(_transactionId);
    }
    
    function refund(uint256 _transactionId)
        external
        onlySeller(_transactionId)
        inState(_transactionId, State.AWAITING_DELIVERY)
    {
        EscrowTransaction storage transaction = transactions[_transactionId];
        transaction.state = State.REFUNDED;
        transaction.buyer.transfer(transaction.amount);
        
        emit FundsRefunded(_transactionId);
    }
    
    function getTransaction(uint256 _transactionId) 
        external 
        view 
        returns (
            address buyer,
            address seller,
            uint256 amount,
            State state,
            uint256 createdAt
        )
    {
        EscrowTransaction storage transaction = transactions[_transactionId];
        return (
            transaction.buyer,
            transaction.seller,
            transaction.amount,
            transaction.state,
            transaction.createdAt
        );
    }
}