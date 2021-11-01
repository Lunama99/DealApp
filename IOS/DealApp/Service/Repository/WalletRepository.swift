//
//  WalletRepository.swift
//  DealApp
//
//  Created by Macbook on 07/10/2021.
//

import Foundation
import Result
import Moya

class WalletRepository: NetworkManager {
    func getWalletAddress(currency: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetWalletAddress(currency: currency)) { result  in
            completion(result)
        }
    }
    
    func getBalance(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetBalance) { result  in
            completion(result)
        }
    }
    
    func getTransaction(Page: Int, Limit: Int, Type: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetTransactionHistory(Page: Page, Limit: Limit, Type: Type)) { result  in
            completion(result)
        }
    }
    
    func getCoinDeposit(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetCoinDeposit) { result  in
            completion(result)
        }
    }
}
