//
//  VoucherManagerViewModel.swift
//  DealApp
//
//  Created by Macbook on 18/10/2021.
//

import Foundation

class VoucherManagerViewModel {
    
    private let voucherRepo = VoucherRepository()
    var idVendor: String = ""
    var listVoucher: Observable<[GetVoucher]> = Observable([])
    var vendor: GetListVendorRegister = GetListVendorRegister()
    
    func getListVoucherByIDVendor(completion: @escaping(()->Void)) {
        voucherRepo.getListVoucherByIDVendor(IdVendor: idVendor, Page: 1, Limit: 20, OrderType: "string") { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetVoucher].self)
                    self?.listVoucher.value = model
                    completion()
                } catch {
                    print("get list voucher failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
