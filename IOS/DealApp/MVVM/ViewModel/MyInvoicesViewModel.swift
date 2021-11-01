//
//  MyInvoicesViewModel.swift
//  DealApp
//
//  Created by Macbook on 26/10/2021.
//

import Foundation

class MyInvoicesViewModel {
    
    private let invoiceRepo = InvoiceRepository()
    var listInvoices: Observable<[GetInvoices]> = Observable([])
    var searchBarTex: Observable<String> = Observable("")
    
    func getListInvoice(completion: @escaping(()->Void)) {
        invoiceRepo.getListInvoice { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let listInvoices = try response.map([GetInvoices].self)
                    self?.listInvoices.value = listInvoices
                    completion()
                } catch {
                    print("get list invoices failed")
                }
            case .failure(_): break
            }
        }
    }
    
    func listInvoicesFilter() -> [GetInvoices] {
        if let string = searchBarTex.value, string != "" {
            return listInvoices.value?.filter({ item in
                if (item.code?.lowercased() ?? "").contains(string.lowercased()) {
                    return true
                } else if (item.listProduct?.lowercased() ?? "").contains(string.lowercased()) {
                    return true
                }
                
                return false
            }) ?? []
        } else {
            return listInvoices.value ?? []
        }
    }
}
