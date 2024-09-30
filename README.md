![Flow Swift SDK](./images/logo.jpg)

<a href="https://dl.circleci.com/status-badge/redirect/gh/portto/flow-swift-sdk/tree/main"><img src="https://dl.circleci.com/status-badge/img/gh/portto/flow-swift-sdk/tree/main.svg?style=svg"></a>
<a href="https://cocoapods.org/pods/FlowSDK"><img src="https://img.shields.io/cocoapods/v/FlowSDK.svg?style=flat"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat"></a>

The Flow Swift SDK provides Swift developers to build decentralized apps on Apple devices that interact with the Flow blockchain.

# Getting Started

## Installation

### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'ExampleApp' do
  pod 'FlowSDK', '~> 0.7.1'
end
```

### Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/portto/flow-swift-sdk.git`
- Select "Up to Next Major" with "0.7.0"

# Usage

Before sending out any transactions, please install [flow-cli](https://docs.onflow.org/flow-cli/install/) and [start emulator](https://docs.onflow.org/flow-cli/start-emulator/) first.

Check out [Flow Access API Specification](https://docs.onflow.org/access-api/) for all apis.

## Generating Key

Flow blockchain uses ECDSA with SHA2-256 or SHA3-256 to grant access to control user accounts.

Create a random private key for P256 and secp256k1 curve:
```swift
import FlowSDK

let privateKey1 = try PrivateKey(signatureAlgorithm: .ecdsaP256)
let privateKey2 = try PrivateKey(signatureAlgorithm: .ecdsaSecp256k1)
```

A private key has an accompanying public key:
```swift
let publicKey = privateKey.publicKey
```

## Creating an Account

You must start emulator to send this transaction. Once you have a key pair, you can create a new account using:
```swift
import FlowSDK
import BigInt

// Generate a new private key
let privateKey = try PrivateKey(signatureAlgorithm: .ecdsaSecp256k1)

// Get the public key
let publicKey = privateKey.publicKey

// Get flow grpc client
let client = Client(network: .emulator)

// Define creating account script
let script = """
import Crypto

transaction(publicKey: PublicKey, hashAlgorithm: HashAlgorithm, weight: UFix64) {
    prepare(signer: AuthAccount) {
        let account = AuthAccount(payer: signer)

        // add a key to the account
        account.keys.add(publicKey: publicKey, hashAlgorithm: hashAlgorithm, weight: weight)
    }
}
"""

// Get service account info
let (payerAccount, payerAccountKey, payerSigner) = try await serviceAccount(client: client)

// Get latest reference block id
let referenceBlockId = try await client.getLatestBlock(isSealed: true)?.id

// Define creating account transaction
var transaction = try Transaction(
    script: script.data(using: .utf8)!,
    arguments: [
        publicKey.cadenceArugment,
        HashAlgorithm.sha3_256.cadenceArugment,
        .ufix64(1000)
    ],
    referenceBlockId: referenceBlockId!,
    gasLimit: 100,
    proposalKey: .init(
        address: payerAccount.address,
        keyIndex: payerAccountKey.index,
        sequenceNumber: payerAccountKey.sequenceNumber),
    payer: payerAccount.address,
    authorizers: [payerAccount.address])

// Sign transaction
try transaction.signEnvelope(
    address: payerAccount.address,
    keyIndex: payerAccountKey.index,
    signer: payerSigner)

// Send out transaction
let txId = try await client.sendTransaction(transaction: transaction)

// Get transaction result
var result: TransactionResult?
while result?.status != .sealed  {
    result = try await client.getTransactionResult(id: txId)
    sleep(3)
}
debugPrint(result)

private func serviceAccount(client: Client) async throws -> (account: Account, accountKey: AccountKey, signer: InMemorySigner) {
    let serviceAddress = Address(hexString: "f8d6e0586b0a20c7")
    let serviceAccount = try await client.getAccountAtLatestBlock(address: serviceAddress)!
    let servicePrivateKey = try PrivateKey(
        data: Data(hex: "7aac2988c5c3df3325d8cd679563cc974271f9505245da53e887fa3cc36c064f"),
        signatureAlgorithm: .ecdsaP256)
    let servicePublicKey = servicePrivateKey.publicKey
    let serviceAccountKeyIndex = serviceAccount.keys.firstIndex(where: { $0.publicKey == servicePublicKey })!
    let serviceAccountKey = serviceAccount.keys[serviceAccountKeyIndex]
    let signer = InMemorySigner(privateKey: servicePrivateKey, hashAlgorithm: .sha3_256)
    return (account: serviceAccount, accountKey: serviceAccountKey, signer: signer)
}
```

## Signing a Transaction

Below is a simple transaction of printing "Hello World!"
```swift
import FlowSDK

let myAddress: Address
let myAccountKey: AccountKey
let myPrivateKey: PrivateKey

// Get flow grpc client
let client = Client(network: .emulator)

// Get latest reference block id
let referenceBlockId = try await client.getLatestBlock(isSealed: true)!.id

var transaction = Transaction(
    script: "transaction { execute { log(\"Hello, World!\") } }".data(using: .utf8)!,
    referenceBlockId: referenceBlockId,
    gasLimit: 100,
    proposalKey: .init(
        address: myAddress,
        keyIndex: myAccountKey.index,
        sequenceNumber: myAccountKey.sequenceNumber),
    payer: myAddress)
```

Transaction signing is done through the Signer protocol. The simplest (and least secure) implementation of Signer is InMemorySigner.
```swift
// create a signer from your private key and configured hash algorithm
let mySigner = InMemorySigner(privateKey: myPrivateKey, hashAlgorithm: myAccountKey.hashAlgorithm)

try transaction.signEnvelope(
    address: myAddress,
    keyIndex: myAccountKey.index,
    signer: mySigner)
```

Flow introduces new concepts that allow for more flexibility when creating and signing transactions. Before trying the examples below, we recommend that you read through the [transaction signature documentation](https://github.com/onflow/flow/blob/master/docs/content/concepts/accounts-and-keys.md#signing-a-transaction).

### [Single party, single signature](https://github.com/onflow/flow/blob/master/docs/accounts-and-keys.md#single-party-single-signature)

- Proposer, payer and authorizer are the same account (`0x01`).
- Only the envelope must be signed.
- Proposal key must have full signing weight.

| Account   | Key ID | Weight |
|-----------|--------|--------|
| `0x01`    | 1      | 1000   |

```swift
let client = Client(network: .emulator)

guard let referenceBlockId = try await client.getLatestBlock(isSealed: true)?.id else {
    return
}

guard let account1 = try await client.getAccountAtLatestBlock(address: Address(hexString: "01")) else {
    return
}
let key1 = account1.keys[0]

// create signer from securely-stored private key
let key1Signer: Signer = getSignerForKey1()

var transaction = Transaction(
    script: """
    transaction {
        prepare(signer: AuthAccount) { log(signer.address) }
    }
    """.data(using: .utf8)!,
    referenceBlockId: referenceBlockId,
    gasLimit: 100,
    proposalKey: .init(
        address: account1.address,
        keyIndex: key1.index,
        sequenceNumber: key1.sequenceNumber),
    payer: account1.address,
    authorizers: [account1.address])

// account 1 signs the envelope with key 1
try transaction.signEnvelope(address: account1.address, keyIndex: key1.index, signer: key1Signer)
```

### [Single party, multiple signatures](https://github.com/onflow/flow/blob/master/docs/accounts-and-keys.md#single-party-multiple-signatures)

- Proposer, payer and authorizer are the same account (`0x01`).
- Only the envelope must be signed.
- Each key has weight 500, so two signatures are required.

| Account   | Key ID | Weight |
|-----------|--------|--------|
| `0x01`    | 1      | 500    |
| `0x01`    | 2      | 500    |

```swift
let client = Client(network: .emulator)

guard let referenceBlockId = try await client.getLatestBlock(isSealed: true)?.id else {
    return
}

guard let account1 = try await client.getAccountAtLatestBlock(address: Address(hexString: "01")) else {
    return
}
let key1 = account1.keys[0]
let key2 = account1.keys[1]

// create signer from securely-stored private key
let key1Signer: Signer = getSignerForKey1()
let key2Signer: Signer = getSignerForKey2()

var transaction = Transaction(
    script: """
    transaction {
        prepare(signer: AuthAccount) { log(signer.address) }
    }
    """.data(using: .utf8)!,
    referenceBlockId: referenceBlockId,
    gasLimit: 100,
    proposalKey: .init(
        address: account1.address,
        keyIndex: key1.index,
        sequenceNumber: key1.sequenceNumber),
    payer: account1.address,
    authorizers: [account1.address])

// account 1 signs the envelope with key 1
try transaction.signEnvelope(address: account1.address, keyIndex: key1.index, signer: key1Signer)

// account 1 signs the envelope with key 2
try transaction.signEnvelope(address: account1.address, keyIndex: key2.index, signer: key2Signer)
```

### [Multiple parties](https://github.com/onflow/flow/blob/master/docs/accounts-and-keys.md#multiple-parties)

- Proposer and authorizer are the same account (`0x01`).
- Payer is a separate account (`0x02`).
- Account `0x01` signs the payload.
- Account `0x02` signs the envelope.
  - Account `0x02` must sign last since it is the payer.

| Account   | Key ID | Weight |
|-----------|--------|--------|
| `0x01`    | 1      | 1000   |
| `0x02`    | 3      | 1000   |

```swift
let client = Client(network: .emulator)

guard let referenceBlockId = try await client.getLatestBlock(isSealed: true)?.id else {
    return
}

guard let account1 = try await client.getAccountAtLatestBlock(address: Address(hexString: "01")) else {
    return
}
guard let account2 = try await client.getAccountAtLatestBlock(address: Address(hexString: "02")) else {
    return
}
let key1 = account1.keys[0]
let key3 = account2.keys[0]

// create signer from securely-stored private key
let key1Signer: Signer = getSignerForKey1()
let key3Signer: Signer = getSignerForKey3()

var transaction = Transaction(
    script: """
    transaction {
        prepare(signer: AuthAccount) { log(signer.address) }
    }
    """.data(using: .utf8)!,
    referenceBlockId: referenceBlockId,
    gasLimit: 100,
    proposalKey: .init(
        address: account1.address,
        keyIndex: key1.index,
        sequenceNumber: key1.sequenceNumber),
    payer: account2.address,
    authorizers: [account1.address])

// account 1 signs the envelope with key 1
try transaction.signPayload(address: account1.address, keyIndex: key1.index, signer: key1Signer)

// account 2 signs the envelope with key 3
try transaction.signEnvelope(address: account2.address, keyIndex: key3.index, signer: key3Signer)
```

### [Multiple parties, two authorizers](https://github.com/onflow/flow/blob/master/docs/accounts-and-keys.md#multiple-parties)

- Proposer and authorizer are the same account (`0x01`).
- Payer is a separate account (`0x02`).
- Account `0x01` signs the payload.
- Account `0x02` signs the envelope.
  - Account `0x02` must sign last since it is the payer.
- Account `0x02` is also an authorizer to show how to include two AuthAccounts into an transaction

| Account   | Key ID | Weight |
|-----------|--------|--------|
| `0x01`    | 1      | 1000   |
| `0x02`    | 3      | 1000   |

```swift
let client = Client(network: .emulator)

guard let referenceBlockId = try await client.getLatestBlock(isSealed: true)?.id else {
    return
}

guard let account1 = try await client.getAccountAtLatestBlock(address: Address(hexString: "01")) else {
    return
}
guard let account2 = try await client.getAccountAtLatestBlock(address: Address(hexString: "02")) else {
    return
}
let key1 = account1.keys[0]
let key3 = account2.keys[0]

// create signer from securely-stored private key
let key1Signer: Signer = getSignerForKey1()
let key3Signer: Signer = getSignerForKey3()

var transaction = Transaction(
    script: """
    transaction {
        prepare(signer1: AuthAccount, signer2: AuthAccount) {
            log(signer.address)
            log(signer2.address)
        }
    }
    """.data(using: .utf8)!,
    referenceBlockId: referenceBlockId,
    gasLimit: 100,
    proposalKey: .init(
        address: account1.address,
        keyIndex: key1.index,
        sequenceNumber: key1.sequenceNumber),
    payer: account2.address,
    authorizers: [account1.address, account2.address])

// account 1 signs the envelope with key 1
try transaction.signPayload(address: account1.address, keyIndex: key1.index, signer: key1Signer)

// account 2 signs the envelope with key 3
// note: payer always signs last
try transaction.signEnvelope(address: account2.address, keyIndex: key3.index, signer: key3Signer)
```

### [Multiple parties, multiple signatures](https://github.com/onflow/flow/blob/master/docs/accounts-and-keys.md#multiple-parties-multiple-signatures)

- Proposer and authorizer are the same account (`0x01`).
- Payer is a separate account (`0x02`).
- Account `0x01` signs the payload.
- Account `0x02` signs the envelope.
  - Account `0x02` must sign last since it is the payer.
- Both accounts must sign twice (once with each of their keys).

| Account   | Key ID | Weight |
|-----------|--------|--------|
| `0x01`    | 1      | 500    |
| `0x01`    | 2      | 500    |
| `0x02`    | 3      | 500    |
| `0x02`    | 4      | 500    |

```swift
let client = Client(network: .emulator)

guard let referenceBlockId = try await client.getLatestBlock(isSealed: true)?.id else {
    return
}

guard let account1 = try await client.getAccountAtLatestBlock(address: Address(hexString: "01")) else {
    return
}
guard let account2 = try await client.getAccountAtLatestBlock(address: Address(hexString: "02")) else {
    return
}
let key1 = account1.keys[0]
let key2 = account1.keys[1]
let key3 = account2.keys[0]
let key4 = account2.keys[1]

// create signer from securely-stored private key
let key1Signer: Signer = getSignerForKey1()
let key2Signer: Signer = getSignerForKey2()
let key3Signer: Signer = getSignerForKey3()
let key4Signer: Signer = getSignerForKey4()

var transaction = Transaction(
    script: """
    transaction {
        prepare(signer: AuthAccount) { log(signer.address) }
    }
    """.data(using: .utf8)!,
    referenceBlockId: referenceBlockId,
    gasLimit: 100,
    proposalKey: .init(
        address: account1.address,
        keyIndex: key1.index,
        sequenceNumber: key1.sequenceNumber),
    payer: account2.address,
    authorizers: [account1.address])

// account 1 signs the envelope with key 1
try transaction.signPayload(address: account1.address, keyIndex: key1.index, signer: key1Signer)

// account 1 signs the payload with key 2
try transaction.signPayload(address: account1.address, keyIndex: key2.index, signer: key2Signer)

// account 2 signs the envelope with key 3
// note: payer always signs last
try transaction.signEnvelope(address: account2.address, keyIndex: key3.index, signer: key3Signer)

// account 2 signs the envelope with key 4
// note: payer always signs last
try transaction.signEnvelope(address: account2.address, keyIndex: key4.index, signer: key4Signer)
```

## Sending a Transaction

You can submit a transaction to the network using the Access API client.
```swift
import FlowSDK

let client = Client(host: "localhost", port: 3569)
// or
// let client = Client(network: .emulator)

try await client.sendTransaction(transaction: transaction)
```

## Querying Transaction Results
After you have submitted a transaction, you can query its status by transaction ID:
```swift
let result = try await client.getTransactionResult(id: txId)
```

`result.status` will be one of the following values:
- unknown
- pending
- finalized
- executed
- sealed
- expired

Check out [the documentation](https://docs.onflow.org/fcl/reference/api/#transaction-statuses) for more details.

## Executing a Script
You can use the `executeScriptAtLatestBlock` method to execute a read-only script against the latest sealed execution state.

Here is a simple script with a single return value:
```cadence
pub fun main(): UInt64 {
    return 1 as UInt64
}
```

Run script and decode as Swift type:
```swift
import FlowSDK

let client = Client(network: .testnet)

let script = """
pub fun main(): UInt64 {
    return 1 as UInt64
}
"""

let cadenceValue: Cadence.Value = try await client.executeScriptAtLatestBlock(script: script.data(using: .utf8)!)
let value: UInt64 = try cadenceValue.toSwiftValue()
```

## Querying Blocks

You can use the `getLatestBlock` method to fetch the latest block with sealed boolean flag:

```swift
import FlowSDK

let client = Client(network: .testnet)

let isSealed: Bool = true
let block = try await client.getLatestBlock(isSealed: isSealed)
```

Block contains BlockHeader and BlockPayload. BlockHeader contains the following fields:
- id: the ID (hash) of the block
- parentId: the ID of the previous block.
- height: the height of the block.
- timestamp: the block timestamp.

BlockPayload contains the folowing fields:
- collectionGuarantees: an attestation signed by the nodes that have guaranteed a collection.
- seals: the attestation by verification nodes that the transactions in a previously executed block have been verified.

## Querying Events

You can use the `getEventsForHeightRange` method to query events.

```swift
import FlowSDK

let client = Client(network: .testnet)

let events: [BlockEvents] = try await client.getEventsForHeightRange(
    eventType: "flow.AccountCreated",
    startHeight: 10,
    endHeight: 15)
```

### Event Type

An event type contains the following fields:

The event type to filter by. Event types are namespaced by the account and contract in which they are declared.

For example, a `Transfer` event that was defined in the `Token` contract deployed at account `0x55555555555555555555` will have a type of `A.0x55555555555555555555.Token.Transfer`.

Read the [language documentation](https://docs.onflow.org/cadence/language/events/) for more information on how to define and emit events in Cadence.

### Querying Accounts

You can use getAccountAtLatestBlock to query the state of an account.

```swift
let client = Client(network: .testnet)

let address = Address(hexString: "0xcb2d04fc89307107")
let account = try await client.getAccountAtLatestBlock(address: address)
```

An `Account` contains the following fields:
- address: the account address.
- balance: the account balance.
- keys: a list of the public keys associated with this account.
- contracts: the contract code deployed at this account.

# Examples

Check out [example](./example/) that how to use the SDK to interact wit Flow blockchain.

# Development

This repo was inspired from [flow-go-sdk](https://github.com/onflow/flow-go-sdk) and make it more Swifty.

## Generate protobuf swift files

```
make install
make generate-protobuf
```

# License

Flow Swift SDK is available under the Apache 2.0 license. Same with [gRPC-Swift](https://github.com/grpc/grpc-swift).
