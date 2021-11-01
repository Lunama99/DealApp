//
//  CartRepository.swift
//  DealApp
//
//  Created by Macbook on 21/10/2021.
//

import Foundation
import Result
import Moya

class CartRepository: NetworkManager {
    func GetListCartUser(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListCartUser) { result  in
            completion(result)
        }
    }
    
    func addVoucherToCart(Id: String?, IdVoucher: String, Quantity: Int, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.AddVoucherToCart(Id: Id, IdVoucher: IdVoucher, Quantity: Quantity)) { result  in
            completion(result)
        }
    }
    
    func updateStatusItemCart(Id: [String], Status: Bool, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.UpdateStatusItemCart(Id: Id, Status: Status)) { result  in
            completion(result)
        }
    }
}
