// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

error NotOwner();
error TransactionDoesntExist();
error AlreadyApproved();
error AlreadyExecuted();
error OwnersRequired();
error InvalidOwnersNumber();
error InvalidOwner();
error NotUniqueOwner();
error ApprovalsLessThanRequired();
error TransactionFailed();
error TransactionNotApproved();

contract MultiSig {

    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed transactionId);
    event Approve(address indexed owner, uint256 indexed transactionId);
    event Revoke(address indexed owner, uint256 indexed transactionId);
    event Execute(uint256 indexed transactionId);

    uint256 public immutable required;

    mapping (address => bool) public isOwner;
    mapping (uint256 => mapping (address => bool)) public approved;

    modifier onlyOwner {
        if (!isOwner[msg.sender]) revert NotOwner();
        _;
    }

    modifier transactionExists(uint256 transactionId) {
        uint256 transactionsLength = transactions.length;
        if (transactionId > transactionsLength || transactionId == transactionsLength) revert TransactionDoesntExist();
        _;
    }

    modifier notApproved(uint256 transactionId) {
        if (approved[transactionId][msg.sender]) revert AlreadyApproved();
        _;
    }

    modifier notExecuted(uint256 transactionId) {
        if (transactions[transactionId].executed) revert AlreadyExecuted();
        _;
    }

    address[] public owners;

    struct Transaction {
        address to;
        uint256 amount;
        bytes data;
        bool executed;
    }

    Transaction[] public transactions;

    constructor(address[] memory _owners, uint256 _required) {
        uint256 ownersLength = _owners.length;
        if (ownersLength == 0) revert OwnersRequired();
        if (_required == 0 || _required > ownersLength) revert InvalidOwnersNumber();
        for (uint256 i; i < ownersLength;) {
            address owner = _owners[i];
            if (owner == address(0)) revert InvalidOwner();
            if (isOwner[owner]) revert NotUniqueOwner();
            isOwner[owner] = true;
            owners.push(owner);
            unchecked {i++;}
        }
        required = _required;
    }

    function submit(address _to, uint256 _amount, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({to: _to, amount: _amount, data: _data, executed: false}));
        uint256 transactionsLength = transactions.length;
        emit Submit(transactionsLength - 1);
    }

    function approve(uint256 transactionId) external onlyOwner transactionExists(transactionId) notApproved(transactionId) notExecuted(transactionId) {
        approved[transactionId][msg.sender] = true;
        emit Approve(msg.sender, transactionId);
    }

    function _getApprovalCount(uint256 transactionId) private view returns (uint256 count) {
        uint256 ownersLength = owners.length;
        for (uint256 i; i < ownersLength;) {
            if (approved[transactionId][owners[i]]) count++;
            unchecked {i++;}
        }
    }

    function execute(uint256 transactionId) external transactionExists(transactionId) notExecuted(transactionId) {
        if (_getApprovalCount(transactionId) < required) revert ApprovalsLessThanRequired();
        Transaction storage transaction = transactions[transactionId];
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.amount}(transaction.data);
        if (success) revert TransactionFailed();
        emit Execute(transactionId);
    }

    function revoke(uint256 transactionId) external onlyOwner transactionExists(transactionId) notExecuted(transactionId) {
        if (!approved[transactionId][msg.sender]) revert TransactionNotApproved();
        approved[transactionId][msg.sender] = false;
        emit Revoke(msg.sender, transactionId);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
