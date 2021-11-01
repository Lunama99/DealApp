//
//  InvoiceRepository.swift
//  DealApp
//
//  Created by Macbook on 19/10/2021.
//

import Foundation
import Result
import Moya

class InvoiceRepository: NetworkManager {
    func addInvoiceVoucher(PaymentMethod: Int, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.AddInvoiceVoucher(PaymentMethod: PaymentMethod)) { result  in
            completion(result)
        }
    }
    
    func getListInvoice(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListInvoice) { result  in
            completion(result)
        }
    }
}
