//
//  Invoices.swift
//  DealApp
//
//  Created by Macbook on 26/10/2021.
//

import Foundation

class GetInvoices: Codable {
    var id: String?
    var idUser: String?
    var idParent: String?
    var status: Int?
    var totalPrice: Double?
    var code: String?
    var type: Int?
    var dateCreate: String?
    var paymentMethod: Int?
    var statusPayment: Bool?
    var netPay: Double?
    var listProduct: String?
    var voucherInvoices: [VoucherInvoices]?
}

class VoucherInvoices: Codable {
    var nameVendor: String?
    var name: String?
    var image: String?
    var dateEnd: String?
    var dateStart: String?
    var id: String?
    var idInvoice: String?
    var idVoucher: String?
    var price: Double?
    var codeVoucher: String?
    var code: String?
    var status: Bool?
}
