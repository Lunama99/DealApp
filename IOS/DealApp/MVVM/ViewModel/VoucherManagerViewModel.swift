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
    var searchText: Observable<String> = Observable("")
    
    func getListVoucherByIDVendor(completion: @escaping(()->Void)) {
        voucherRepo.getListVoucherByIDVendor(IdVendor: idVendor) { [weak self] result in
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
    
    func filterVoucher() -> [GetVoucher] {
        if let string = searchText.value, string != "" {
            return listVoucher.value?.filter({$0.status == 0}).filter({ item in
                if (item.name?.lowercased() ?? "").contains(searchText.value?.lowercased() ?? "") {
                    return true
                }
                    return false
                }) ?? []
        } else {
            return listVoucher.value ?? []
        }
    }
}
