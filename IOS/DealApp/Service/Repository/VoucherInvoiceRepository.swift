//
//  VoucherInvoiceRepository.swift
//  DealApp
//
//  Created by Macbook on 28/10/2021.
//

import Foundation
import Result
import Moya

class VoucherInvoiceRepository: NetworkManager {
    func updateStatusVoucher(code: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.UpdateStatusVoucher(code: code)) { result  in
            completion(result)
        }
    }
}
