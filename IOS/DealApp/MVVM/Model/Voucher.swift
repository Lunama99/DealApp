//
//  Voucher.swift
//  DealApp
//
//  Created by Macbook on 18/10/2021.
//

import Foundation

public class GetVoucher: Codable {
    var id: String?
    var name: String?
    var oldPrice: Double?
    var newPrice: Double?
    var image: String?
    var imageBase64: String?
    var description: String?
    var quantityWare: Int?
    var quantitySold: Int?
    var dateStart: String?
    var dateEnd: String?
    var status: Int?
    var dateCreate: String?
    var idVendor: String?
    var code: String?
    var active: Bool?
}

class AddVoucherReponse: Codable {
    var status: Bool?
    var message: String?
    var idVoucher: String?
    var idVendor: String?
}
