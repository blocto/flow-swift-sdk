import Crypto

transaction(publicKey: PublicKey, hashAlgorithm: HashAlgorithm, weight: UFix64) {
    prepare(signer: AuthAccount) {
        let account = AuthAccount(payer: signer)

        // add a key to the account
        account.keys.add(publicKey: publicKey, hashAlgorithm: hashAlgorithm, weight: weight)
    }
}
