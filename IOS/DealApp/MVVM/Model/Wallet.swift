//
//  Wallet.swift
//  DealApp
//
//  Created by Macbook on 07/10/2021.
//

import Foundation

class GetWalletAddress: Codable {
    var status: Bool?
    var message: String?
    var result: [WalletAddress]?
}

public class WalletAddress: Codable {
    var currency: String?
    var type: String?
    var address: String?
}

class GetWalletBalance: Codable {
    var status: Bool?
    var message: String?
    var result: [WalletBalance]?
}

class WalletBalance: Codable {
    var currency: String?
    var available: Double?
    var lock: Double?
    var total: Double?
}

class GetTransactionHistory: Codable {
    var status: Bool?
    var message: String?
    var result: [TransactionHistory]?
}

class TransactionHistory: Codable {
    var userInccured: String?
    var currency: String?
    var code: String?
    var status: Bool?
    var confirmPayment: Bool?
    var lock: Bool?
    var amount: Double?
    var fee: Double?
    var userAddress: String?
    var txid: String?
    var dateCreate: String?
    var type: String?
    var typeCommission: String?
    var source: String?
}

class GetCoinDeposit: Codable {
    var status: Bool?
    var message: String?
    var result: [CoinDeposit]?
}

class CoinDeposit: Codable {
    var logo: String?
    var currency: String?
    var name: String?
    var price: Double?
}
