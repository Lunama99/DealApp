//
//  VendorViewModel.swift
//  DealApp
//
//  Created by Macbook on 16/10/2021.
//

import Foundation

class VendorViewModel {
    
    private let vendorRepo = VendorRepository()
    var listVendor: Observable<[GetListVendorRegister]> = Observable([])
    var vendorId: String = ""
    
    func getListVendor(completion: @escaping(()->Void)) {
        vendorRepo.getListVendor(Page: 1, Limit: 20, orderType: "string") { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetListVendorRegister].self)
                    self?.listVendor.value = model
                    completion()
                } catch {
                    print("get list vendor failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
