//
//  MyVendorDetailViewModel.swift
//  DealApp
//
//  Created by Macbook on 14/10/2021.
//

import Foundation

class MyVendorDetailViewModel {
    
    private let vendorRepo = VendorRepository()
    var vendor: Observable<GetListVendorRegister> = Observable(GetListVendorRegister())
    var vendorId: String = ""
    
    func getVendorById(completion: @escaping(()->Void)) {
        vendorRepo.getVendorById(ID: vendorId) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(GetListVendorRegister.self)
                    model.imageList =  model.imageList?.sorted(by: {($0.displayOrder ?? 0) < ($1.displayOrder ?? 0)})
                    self?.vendor.value = model
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
