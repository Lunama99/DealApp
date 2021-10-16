//
//  MyVendorViewModel.swift
//  DealApp
//
//  Created by Macbook on 12/10/2021.
//

import Foundation

class MyVendorViewModel {
    
    private let vendorRepo = VendorRepository()
    var listVendorVerified: Observable<[GetListVendorRegister]> = Observable([])
    var listVendorPending: Observable<[GetListVendorRegister]> = Observable([])
    
    func getListVendor(completion: @escaping(()->Void)) {
        vendorRepo.getListVendorRegisted { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetListVendorRegister].self)
                    self?.listVendorVerified.value = model.filter({$0.status == 1})
                    self?.listVendorPending.value = model.filter({$0.status == 0})
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
