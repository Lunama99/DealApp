//
//  ToolRepository.swift
//  DealApp
//
//  Created by Macbook on 14/09/2021.
//

import Foundation
import Moya

class ToolRepository: NetworkManager {
    func getServerTime(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetServerTime) { result  in
            completion(result)
        }
    }

//
//    func getBalance(chainName: String, symbol: String, address: String, contract: String, decimals: Int, completion: @escaping (Result<Response, MoyaError>) -> Void) {
//        provider.request(.getBalance(chainName: chainName, symbol: symbol, address: address, contract: contract, decimals: decimals)) { result in
//            completion(result)
//        }
//    }
//
//    func getLogo(chainName: String, symbol: String?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
//        provider.request(.getLogo(chainName: chainName, symbol: symbol)) { result in
//            completion(result)
//        }
//    }
//
//    func getPrice(symbol: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
//        provider.request(.getPrice(symbol: symbol)) { result in
//            completion(result)
//        }
//    }
//
//    func getRecommendToken(chainName: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
//        provider.request(.getRecommendToken(chainName: chainName)) { result in
//            completion(result)
//        }
//    }
//
//    func searchToken(chainName: String, key: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
//        provider.request(.searchToken(chainName: chainName, key: key)) { result in
//            completion(result)
//        }
//    }
//
//    func searchTokenBySmartContract(chainName: String, smartContract: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
//        provider.request(.searchTokenBySmartContract(chainName: chainName, smartContract: smartContract)) { result in
//            completion(result)
//        }
//    }
}

