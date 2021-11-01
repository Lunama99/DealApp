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
    var vendorSearchText: Observable<String> = Observable("")
    var voucherSearchText: Observable<String> = Observable("")
    var isLoading: Bool = false
    var vendorId: String = ""
    var vendorPage: Int? = 1
    var voucherPage: Int? = 1
    
    
    func getListVendor(completion: @escaping(()->Void)) {
        guard let page = vendorPage, !isLoading else { return }
        isLoading = true
        vendorRepo.getListVendor(Page: page, Limit: 20, orderType: "string") { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetListVendorRegister].self)
                    if self?.vendorPage == 1 {
                        self?.listVendor.value = model
                    } else {
                        self?.listVendor.value = (self?.listVendor.value ?? []) + model
                    }
                    
                    if model.count == 20 {
                        self?.vendorPage = (self?.vendorPage ?? 0) + 1
                    } else {
                        self?.vendorPage = nil
                    }
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
        guard let page = voucherPage, !isLoading else { return }
        isLoading = true
        voucherRepo.getListVoucher(Page: page, Limit: 20, OrderType: "string") { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetVoucher].self)
                    if self?.voucherPage == 1 {
                        self?.listVoucher.value = model
                    } else {
                        self?.listVoucher.value = (self?.listVoucher.value ?? []) + model
                    }
                    
                    if model.count == 20 {
                        self?.voucherPage = (self?.voucherPage ?? 0) + 1
                    } else {
                        self?.voucherPage = nil
                    }
                    completion()
                } catch {
                    print("get list vendor failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchVendor(key: String, completion: @escaping(()->Void)) {
        guard let page = vendorPage, !isLoading else { return }
        isLoading = true
        vendorRepo.searchVendor(key: key, page: page, limit: 20) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetListVendorRegister].self)
                    if self?.vendorPage == 1 {
                        self?.listVendor.value = model
                    } else {
                        self?.listVendor.value = (self?.listVendor.value ?? []) + model
                    }
                    
                    if model.count == 20 {
                        self?.vendorPage = (self?.vendorPage ?? 0) + 1
                    } else {
                        self?.vendorPage = nil
                    }
                    completion()
                } catch {
                    print("get list vendor failed")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchVoucher(key: String, completion: @escaping(()->Void)) {
        guard let page = voucherPage, !isLoading else { return }
        isLoading = true
        voucherRepo.searchVoucher(key: key, page: page, limit: 20) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([GetVoucher].self)
                    if self?.voucherPage == 1 {
                        self?.listVoucher.value = model
                    } else {
                        self?.listVoucher.value = (self?.listVoucher.value ?? []) + model
                    }
                    
                    if model.count == 20 {
                        self?.voucherPage = (self?.voucherPage ?? 0) + 1
                    } else {
                        self?.voucherPage = nil
                    }
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
