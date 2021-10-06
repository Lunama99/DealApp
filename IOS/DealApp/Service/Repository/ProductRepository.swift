//
//  ProductRepository.swift
//  DealApp
//
//  Created by Macbook on 04/10/2021.
//

import Foundation
import Moya

class ProductRepository: NetworkManager {
    func getNewProduct(Page: Int, Limit: Int, OrderType: String?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetNewProduct(Page: Page, Limit: Limit, OrderType: OrderType)) { result  in
            completion(result)
        }
    }
}
