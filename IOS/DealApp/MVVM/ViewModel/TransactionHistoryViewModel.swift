//
//  TransactionHistoryViewModel.swift
//  DealApp
//
//  Created by Macbook on 07/10/2021.
//

import Foundation

class TransactionHistoryViewModel {
    
    var listTransaction: Observable<[TransactionHistory]> = Observable([])
    private let walletRepo = WalletRepository()
    
    func getTransaction(page: Int) {
        walletRepo.getTransaction(Page: page, Limit: 20, Order: nil) { result in
            switch result {
            case .success(let response):
                do {
                    let transactionResponse = try response.map(GetTransactionHistory.self)
                    if let transaction = transactionResponse.result, transactionResponse.status == true {
                        self.listTransaction.value = transaction
                    } else {
                        Helper.shared.expire(message: transactionResponse.message ?? "")
                    }
                } catch {
                    print("get transaction history failed")
                }
            case .failure(_): break
            }
        }
    }
}
