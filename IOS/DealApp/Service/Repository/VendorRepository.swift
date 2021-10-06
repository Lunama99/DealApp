//
//  VendorRepository.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import Foundation
import Moya

class VendorRepository: NetworkManager {
    func getAllCategory(IdCategory: String, Page: Int, Limit: Int, orderType: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListVendor(IdCategory: IdCategory, Page: Page, Limit: Limit, orderType: orderType)) { result  in
            completion(result)
        }
    }
}
