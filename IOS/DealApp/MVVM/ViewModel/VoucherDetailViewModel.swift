//
//  VoucherDetailViewModel.swift
//  DealApp
//
//  Created by Macbook on 20/10/2021.
//

import Foundation

class VoucherDetailViewModel {
    private let voucherRepo = VoucherRepository()
    private let cartRepo = CartRepository()
    
    var voucher: GetVoucher = GetVoucher()
    var vendor: GetListVendorRegister = GetListVendorRegister()
    
    func getCart(completion: @escaping(()->Void)) {
        cartRepo.GetListCartUser { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let cart = try response.map(CartReponse.self)
                    Helper.shared.cart = cart
                } catch {
                    print("get cart failed")
                }
            case .failure(_): break
            }
            completion()
        }
    }
    
    func addVoucherToCart(completion: @escaping((Bool?, String?)->Void)) {
        cartRepo.addVoucherToCart(Id: nil, IdVoucher: voucher.id ?? "", Quantity: 1) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if model.status == true {
                        self?.getCart { }
                    }
                    completion(model.status, model.message)
                } catch {
                    print("get cart failed")
                }
            case .failure(_): break
            }
        }
    }
}
