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
    var isLoading: Bool = false
    var currentPage: Int? = 1
    
    func getTransaction(tyle: TransactionType) {
        guard let page = currentPage, !isLoading else { return }
        isLoading = true
        walletRepo.getTransaction(Page: page, Limit: 20, Type: tyle.rawValue) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(GetTransactionHistory.self)
                    if let transaction = model.result, model.status == true {
                        if self?.currentPage == 1 {
                            self?.listTransaction.value = transaction
                        } else {
                            self?.listTransaction.value = (self?.listTransaction.value ?? []) + transaction
                        }
                    } else {
                        Helper.shared.expire(message: model.message ?? "")
                    }
                    
                    if model.result?.count == 20 {
                        self?.currentPage = (self?.currentPage ?? 0) + 1
                    } else {
                        self?.currentPage = nil
                    }
                } catch {
                    print("get transaction history failed")
                }
            case .failure(_): break
            }
        }
    }
}

enum TransactionType: String {
    case BuyVoucher = "BuyVoucher"
    case Deposit = "Deposit"
    case WithDraw = "WithDraw"
    case All = "All"
}
