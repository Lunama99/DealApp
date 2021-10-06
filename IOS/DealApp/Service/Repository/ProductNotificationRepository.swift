//
//  ProductNotificationRepository.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import Foundation
import Moya

class ProductNotificationRepository: NetworkManager {
    func getAllCategory(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListNotification) { result  in
            completion(result)
        }
    }
}
