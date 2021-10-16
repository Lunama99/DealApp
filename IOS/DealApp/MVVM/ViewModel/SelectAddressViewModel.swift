//
//  SelectAddressViewModel.swift
//  DealApp
//
//  Created by Macbook on 07/10/2021.
//

import Foundation

class SelectAddressViewModel: ToolRepository {
    
    private let walletRepo = WalletRepository()
    var listAdress: Observable<[WalletAddress]> = Observable([])
//    var balance: Observable<WalletBalance> = Observable(WalletBalance())
    var currency: String = ""
    
//    func getBalance(completion: @escaping(()->Void)) {
//        walletRepo.getBalance(currency: currency) { [weak self] result in
//            switch result {
//            case .success(let response):
//                do {
//                    let balanceResponse = try response.map(GetWalletBalance.self)
//                    if let walletBalance = balanceResponse.result, balanceResponse.status == true {
//                        self?.balance.value = walletBalance
//                        completion()
//                    } else {
//                        Helper.shared.expire(message: balanceResponse.message ?? "")
//                    }
//                } catch {
//                    print("get balance failed")
//                }
//            case .failure(_): break
//            }
//        }
//    }
    
}
