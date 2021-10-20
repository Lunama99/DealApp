//
//  HomeViewModel.swift
//  DealApp
//
//  Created by Macbook on 14/09/2021.
//

import Foundation

class HomeViewModel: ToolRepository {
    
    var time: Observable<String> = Observable("")
    var productCategory: Observable<[GetAllCategory]> = Observable([])
    
    private let vendorRepo = VendorRepository()
    private let voucherRepo = VoucherRepository()
    private let accountRepo = AccountRepository()
    private let productCategoryRepo = ProductCategoryReposistory()
    
    var listVendor: Observable<[GetListVendorRegister]> = Observable([])
    var listVoucher: Observable<[GetVoucher]> = Observable([])
    
    func getServerTime(completion: @escaping(()->Void)) {
        getServerTime { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let string = try response.map(String.self)
                    let date = string.toDate(format: Date.DateFormatted.format2)
                    self?.time.value = date?.getTimeSession()
                } catch {
                    print("get server time failed")
                }
            case .failure(_): break
//                ShowAlert.shared.showResponseMassage(string: R.string.localize.failed(preferredLanguages: self?.lang), isSuccess: false)
            }
            completion()
        }
    }
    
    func getUser(completion: @escaping(()->Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.accountRepo.getUser { result in
                switch result {
                case .success(let response):
                    do {
                        let userResponse = try response.map(GetUserResponse.self)
                        if let user = userResponse.result, userResponse.status == true {
                            Helper.shared.user = user
                            completion()
                        } else {
                            Helper.shared.expire(message: userResponse.message ?? "")
                        }
                        completion()
                    } catch {
                        print("get user failed")
                    }
                case .failure(_): break
                }
            }
        }
    }
    
    func getAllCategory(completion: @escaping(()->Void)) {
        productCategoryRepo.getAllCategory { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    self?.productCategory.value = try response.map([GetAllCategory].self)
                    completion()
                } catch {
                    print("get category failed")
                }
            case .failure(_): break
//                ShowAlert.shared.showResponseMassage(string: R.string.localize.failed(preferredLanguages: self?.lang), isSuccess: false)
            }
        }
    }
    
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

