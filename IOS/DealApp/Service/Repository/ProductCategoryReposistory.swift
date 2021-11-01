//
//  ProductCategoryReposistory.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import Foundation
import Result
import Moya

class ProductCategoryReposistory: NetworkManager {
    func getAllCategory(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetAllCategory) { result  in
            completion(result)
        }
    }
}
