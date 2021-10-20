//
//  VoucherRepository.swift
//  DealApp
//
//  Created by Macbook on 18/10/2021.
//

import Foundation
import Moya

class VoucherRepository: NetworkManager {
    func getListVoucherByIDVendor(IdVendor: String, Page: Int, Limit: Int, OrderType: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListVoucherByIDVendor(IdVendor: IdVendor, Page: Page, Limit: Limit, OrderType: OrderType)) { result  in
            completion(result)
        }
    }
    
    func getListVoucher(Page: Int, Limit: Int, OrderType: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListVoucher(Page: Page, Limit: Limit, OrderType: OrderType)) { result  in
            completion(result)
        }
    }
    
    func addVoucher(voucher: GetVoucher, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.AddVoucher(voucher: voucher)) { result  in
            completion(result)
        }
    }
    
    func deleteVoucher(IdVoucher: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.DeleteVoucher(IdVoucher: IdVoucher)) { result  in
            completion(result)
        }
    }
}
