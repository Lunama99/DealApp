//
//  NotificationRepository.swift
//  DealApp
//
//  Created by Macbook on 03/11/2021.
//

import Foundation
import Result
import Moya

class NotificationRepository: NetworkManager {
    
    func getListNotification(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListNotification) { result  in
            completion(result)
        }
    }
}
