//
//  ViewModel.swift
//  Example
//
//  Created by Scott on 2022/7/26.
//

import Foundation
import FlowSDK
import Cadence

@MainActor class ViewModel: ObservableObject {
    @Published var publicKeyText: String = ""
    @Published var ping: Bool?
    @Published var latestBlockText: String = ""
    @Published var sendTransactionText: String = ""
    @Published var getTransactionText: String = ""
    @Published var getTransactionResultText: String = ""
    @Published var getAccountAtLatestBlockText: String = ""
    @Published var executeScriptAtLatestBlockText: String = ""
    @Published var getEventsForHeightRangeText: String = ""
    @Published var getNetworkParametersText: String = ""

    private let client = Client(network: .testnet)
    private lazy var address = Address(hexString: "0x04ed751d5dda4a60")
    private lazy var privateKey = try! PrivateKey(
        data: Data(hex: "1634cab06b346fa22509c7f12d5ccbfd6f70c29b27038c9909df74e3c01843d2"),
        signatureAlgorithm: .ecdsaSecp256k1)

    func callPing() async {
        do {
            _ = try await client.ping()
            ping = true
        } catch {
            ping = false
        }
    }

    func callGetLastest() async {
        do {
            if let block = try await client.getLatestBlock(isSealed: true) {
                latestBlockText = "\(block)"
            } else {
                latestBlockText = "nil"
            }
        } catch {
            latestBlockText = "\(error)"
        }
    }

    func sendTransaction() async {
        do {
            guard let latestBlock = try await client.getLatestBlock(isSealed: true) else {
                throw Error.noLastestBlock
            }
            guard let account = try await client.getAccountAtLatestBlock(address: address) else {
                throw Error.noAccount
            }
            guard let accountKey = account.keys.first(where: { privateKey.publicKey == $0.publicKey }) else {
                throw Error.noAccountKey
            }

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

            let newPrivateKey = try PrivateKey(signatureAlgorithm: .ecdsaP256)
            let signer = InMemorySigner(
                privateKey: privateKey,
                hashAlgorithm: .sha3_256)
            var transaction = try Transaction(
                script: script.data(using: .utf8) ?? Data(),
                arguments: [
                    newPrivateKey.publicKey.cadenceArugment,
                    HashAlgorithm.sha3_256.cadenceArugment,
                    .ufix64(1000)
                ],
                referenceBlockId: latestBlock.id,
                gasLimit: 100,
                proposalKey: .init(
                    address: address,
                    keyIndex: accountKey.index,
                    sequenceNumber: accountKey.sequenceNumber),
                payer: address,
                authorizers: [address])
            try transaction.signEnvelope(
                address: address,
                keyIndex: accountKey.index,
                signer: signer)
            let txId = try await client.sendTransaction(transaction: transaction)
            debugPrint(txId.description)
            sendTransactionText = "txId: \(txId.description)"
        } catch {
            sendTransactionText = "\(error)"
        }
    }

    func getTransaction() async {
        do {
            let id = Identifier(hexString: "54aa361b51b1895db55a4da97f682f31b54602e6ca00237c1b76db419f57c1ff")
            guard let transaction = try await client.getTransaction(id: id) else {
                throw Error.noTransaction
            }
            getTransactionText = "\(transaction)"
        } catch {
            getTransactionText = "\(error)"
        }
    }

    func getTransactionResult() async {
        do {
            let id = Identifier(hexString: "54aa361b51b1895db55a4da97f682f31b54602e6ca00237c1b76db419f57c1ff")
            let result = try await client.getTransactionResult(id: id)
            getTransactionResultText = "\(result)"
        } catch {
            getTransactionResultText = "\(error)"
        }
    }

    func getAccountAtLatestBlock() async {
        do {
            guard let account = try await client.getAccountAtLatestBlock(address: address) else {
                throw Error.noAccount
            }
            getAccountAtLatestBlockText = "\(account)"
        } catch {
            getAccountAtLatestBlockText = "\(error)"
        }
    }

    func executeScriptAtLatestBlock() async {
        do {
            let script = """
            pub fun main(): UInt64 {
                return 1 as UInt64
            }
            """
            let result = try await client.executeScriptAtLatestBlock(script: script.data(using: .utf8)!)
            executeScriptAtLatestBlockText = "\(result)"
        } catch {
            executeScriptAtLatestBlockText = "\(error)"
        }
    }

    func getEventsForHeightRange() async {
        do {
            let events = try await client.getEventsForHeightRange(
                eventType: "A.7e60df042a9c0868.FlowToken", startHeight: 74804668, endHeight: 74804669)
            getEventsForHeightRangeText = "\(events)"
        } catch {
            getEventsForHeightRangeText = "\(error)"
        }
    }

    func getNetworkParameters() async {
        do {
            getNetworkParametersText = try await client.getNetworkParameters()
        } catch {
            getNetworkParametersText = "\(error)"
        }
    }

}

// MARK: - Error

extension ViewModel {

    enum Error: Swift.Error {
        case noLastestBlock
        case noAccount
        case noAccountKey
        case noTransaction
    }
}
