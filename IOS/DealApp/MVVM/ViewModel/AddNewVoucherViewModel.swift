//
//  AddNewVoucherViewModel.swift
//  DealApp
//
//  Created by Macbook on 18/10/2021.
//

import Foundation

class AddNewVoucherViewModel {
    private let voucherRepo = VoucherRepository()
    var voucher: Observable<GetVoucher> = Observable(GetVoucher())
    
    func addNewVoucher(completion: @escaping((Bool, String?)->Void)) {
        guard let voucher = voucher.value else { return }
        voucherRepo.addVoucher(voucher: voucher) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map(AddVoucherReponse.self)
                    if model.status == true {
                        print(model)
                        completion(true, model.message)
                    } else {
                        completion(false, model.message)
                    }
                } catch {
                    print("get list voucher failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteVoucher(completion: @escaping((Bool, String?)->Void)) {
        guard let voucher = voucher.value else { return }
        voucherRepo.deleteVoucher(IdVoucher: voucher.id ?? "") { [weak self] result in
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
                    print("get list voucher failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
