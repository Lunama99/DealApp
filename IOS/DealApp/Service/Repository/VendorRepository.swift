//
//  VendorRepository.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import Foundation
import Result
import Moya

class VendorRepository: NetworkManager {
    func registerVendor(IDCategory: String, Name: String, PaymentDiscountPercent: String, LicenseBase64: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.RegisterVendor(IDCategory: IDCategory, Name: Name, PaymentDiscountPercent: PaymentDiscountPercent, LicenseBase64: LicenseBase64)) { result  in
            completion(result)
        }
    }
    
    func getListVendorRegisted(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListVendorRegisted) { result  in
            completion(result)
        }
    }
    
    func updateVendorInformation(ID: String, Name: String, Description: String, AvatarBase64: String?, ImageListBase64: [String]?, address: [VendorAddress]?, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.UpdateVendorInformation(ID: ID, Name: Name, Description: Description, AvatarBase64: AvatarBase64, ImageListBase64: ImageListBase64, address: address)) { result  in
            completion(result)
        }
    }
    
    func getVendorById(ID: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetVendortById(Id: ID)) { result  in
            completion(result)
        }
    }
    
    func getListVendor(Page: Int, Limit: Int, orderType: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListVendor(Page: Page, Limit: Limit, orderType: orderType)) { result  in
            completion(result)
        }
    }
    
    func getListVendorByIDVendorType(IdCategory: String, Page: Int, Limit: Int, orderType: String, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.GetListVendorByIDVendorType(IdCategory: IdCategory, Page: Page, Limit: Limit, OrderType: orderType)) { result  in
            completion(result)
        }
    }
    
    func searchVendor(key: String, page: Int, limit: Int, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.SearchVendor(key: key, page: page, limit: limit)) { result  in
            completion(result)
        }
    }
}
