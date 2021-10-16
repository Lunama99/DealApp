//
//  WalletRepository.swift
//  DealApp
//
//  Created by Macbook on 07/10/2021.
//

import Foundation
import Moya

class WalletRepository: NetworkManager {
    func getWalletAddress(currency: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetWalletAddress(currency: currency)) { result  in
            completion(result)
        }
    }
    
    func getBalance(currency: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetBalance(currency: currency)) { result  in
            completion(result)
        }
    }
    
    func getTransaction(Page: Int, Limit: Int, Order: String?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetTransactionHistory(Page: Page, Limit: Limit, Order: Order)) { result  in
            completion(result)
        }
    }
    
    func getCoinDeposit(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetCoinDeposit) { result  in
            completion(result)
        }
    }
}
