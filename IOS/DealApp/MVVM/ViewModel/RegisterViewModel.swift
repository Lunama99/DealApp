//
//  RegisterViewModel.swift
//  DealApp
//
//  Created by Macbook on 09/10/2021.
//

import Foundation

class RegisterViewModel {
    
    private let productCategoryRepo = ProductCategoryReposistory()
    private let vendorRepo = VendorRepository()
    private let accountRepo = AccountRepository()
    
    var listCategory: Observable<[GetAllCategory]> = Observable([])
    
    func getCategory(completion: @escaping(()->Void)) {
        productCategoryRepo.getAllCategory { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetAllCategory].self)
                    self?.listCategory.value = model
                    completion()
                } catch {
                    print("verify account failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func registerVendor(ID: String?, IDCategory: String, Name: String, PaymentDiscountPercent: String, LicenseBase64: String, completion: @escaping((Bool, String?)->Void)) {
        vendorRepo.registerVendor(ID: ID, IDCategory: IDCategory, Name: Name, PaymentDiscountPercent: PaymentDiscountPercent, LicenseBase64: LicenseBase64) { [weak self] result in
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
                    print("verify account failed")
                    completion(false, nil)
                }
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func getUser(completion: @escaping(()->Void)) {
        accountRepo.getUser { result in
            switch result {
            case .success(let response):
                do {
                    let userResponse = try response.map(GetUserResponse.self)
                    if let user = userResponse.result, userResponse.status == true {
                        Helper.shared.user = user
                        completion()
                    }
                } catch {
                    print("get user failed")
                }
            case .failure(_): break
            }
        }
    }
}
