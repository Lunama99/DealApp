//
//  MyVendorViewModel.swift
//  DealApp
//
//  Created by Macbook on 12/10/2021.
//

import Foundation

class MyVendorViewModel {
    
    private let vendorRepo = VendorRepository()
    var listVendorOrigin: Observable<[GetListVendorRegister]> = Observable([])
    private var listVendorVerified: [GetListVendorRegister] = []
    private var listVendorPending: [GetListVendorRegister] = []
    var searchText: Observable<String> = Observable("")
    
    func getListVendor(completion: @escaping(()->Void)) {
        vendorRepo.getListVendorRegisted { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetListVendorRegister].self)
                    self?.listVendorOrigin.value = model
                    completion()
                } catch {
                    print("get list vendor failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterVendorVerified() -> [GetListVendorRegister] {
        if let string = searchText.value, string != "" {
            return listVendorOrigin.value?.filter({$0.status == 1}).filter({ item in
                if (item.name?.lowercased() ?? "").contains(searchText.value?.lowercased() ?? "") {
                    return true
                }
                    return false
                }) ?? []
        } else {
            return listVendorOrigin.value?.filter({$0.status == 1}) ?? []
        }
    }
    
    func filterVendorPending() -> [GetListVendorRegister] {
        if let string = searchText.value, string != "" {
            return listVendorOrigin.value?.filter({$0.status == 0}).filter({ item in
                if (item.name?.lowercased() ?? "").contains(searchText.value?.lowercased() ?? "") {
                    return true
                }
                    return false
                }) ?? []
        } else {
            return listVendorOrigin.value?.filter({$0.status == 1}) ?? []
        }
    }
}
