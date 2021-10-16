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
}

