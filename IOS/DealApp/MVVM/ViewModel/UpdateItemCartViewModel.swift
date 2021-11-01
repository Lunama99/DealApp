//
//  UpdateItemCartViewModel.swift
//  DealApp
//
//  Created by Macbook on 22/10/2021.
//

import Foundation

class UpdateItemCartViewModel {
    private let voucherRepo = VoucherRepository()
    private let cartRepo = CartRepository()
    
    var item = CartItem()
    
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
    
    func updateItemCart(completion: @escaping(()->Void)) {
        cartRepo.addVoucherToCart(Id: item.id ?? "", IdVoucher: item.idVoucher ?? "", Quantity: item.quantity ?? 0) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if model.status == true {
                        self?.getCart { }
                        completion()
                    }
                } catch {
                    print("get cart failed")
                }
            case .failure(_): break
            }
            completion()
        }
    }
}
