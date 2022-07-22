# Multi Signature Wallet
**A multi signature wallet is a wallet which acts just like a normal wallet, but with the very important and secure feature that multiple signatures are required to confirm a transaction, hence the name "multi signature". This is a decentralized way of signing transactions, but don't forget, the owner of these wallets can be the same person. So it is a protection for entire decentralized entities (e.g. DAOs) and additionally for individuals.**

```
Deposit
```
*Fired when ETH is deposited into the multi sig wallet.*

```
Submit
```
*Fired when a transaction is submitted, waiting for other owners to approve.*

```
Approve
```
*Fired when owners have approved the transaction.*

```
Revoke
```
*Fired when owners have changed changed their mind and decided to revoke the transaction.*

```
Execute
```
*Fired once there's a sufficient amount of approvals.*

```
owners
```
*All owners of the multi signature wallet.*

```
isOwner
```
*Checks if the message sender is an owner. Returns true if message sender is owner, otherwise false.*

```
approved
```
*Mapping for approving transactions.*

```
required
```
*Number of approvals required before a transaction can be executed.*

```
onlyOwner
```
*Checks if message sender is owner, throws if not.*

```
transactionExists
```
*Checks if transaction exists or not. If `transactionId` is less than `transactions.length`*

```
notApproved
```
*Checks if transaction is not approved by msg.sender, throws if it is.*

```
notExecuted
```
*Checks if transaction was already executed, throws if it was.*

```
Transaction
```
*Stores the transaction (details).*

```
transactions
```
*List of all the transactions.*

```
receive()
```
*Enables addresses to deposit ETH by directly funding the smart contract.*

```
submit()
```
*Function only callable by owners to submit a transaction.*

```
approve()
```
*Allows only owners to approve transactions. Must neither be approved nor executed before it is called.*

```
_getApprovalCount
```
*Counter of approvals made.*

```
execute()
```
*Executes given transaction, only callable by the owners. Transaction must exist and couldn't have previously been executed.*

```
revoke()
```
*Function that undoes / cancels an approved transaction. Transaction must exist and couldn't have previously been executed.*
