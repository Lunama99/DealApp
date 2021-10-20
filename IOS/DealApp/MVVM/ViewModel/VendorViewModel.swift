//
//  VendorViewModel.swift
//  DealApp
//
//  Created by Macbook on 16/10/2021.
//

import Foundation

class VendorViewModel {
    
    private let vendorRepo = VendorRepository()
    private let voucherRepo = VoucherRepository()
    
    var listVendor: Observable<[GetListVendorRegister]> = Observable([])
    var listVoucher: Observable<[GetVoucher]> = Observable([])
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
    
    func getListVoucher(completion: @escaping(()->Void)) {
        voucherRepo.getListVoucher(Page: 1, Limit: 20, OrderType: "string") { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetVoucher].self)
                    self?.listVoucher.value = model
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
