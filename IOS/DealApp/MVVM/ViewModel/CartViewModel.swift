//
//  CartViewModel.swift
//  DealApp
//
//  Created by Macbook on 23/10/2021.
//

import Foundation

class CartViewModel {
    
    private let cartRepo = CartRepository()
    private let invoiceRepo = InvoiceRepository()
    
    var item = CartReponse()
    
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
    
    func updateStatusItemCart(Id: [String], Status: Bool, completion: @escaping(()->Void)) {
        cartRepo.updateStatusItemCart(Id: Id, Status: Status) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if model.status == true {
                        self?.getCart { }
                    }
                    completion()
                } catch {
                    print("update status item failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addInvoiceVoucher(completion: @escaping((Bool, String?)->Void)) {
        invoiceRepo.addInvoiceVoucher(PaymentMethod: 0) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(DefaultResponse.self)
                    if model.status == true {
                        print(model)
                        completion(true, model.message)
                    } else {
                        completion(false, model.message)
                    }
                } catch {
                    print("get cart failed")
                }
            case .failure(_): break
            }
        }
    }
}
