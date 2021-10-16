//
//  Vendor.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import Foundation

class GetListVendorRegister: Codable {
    var imageList: [ImageList]?
    var imageListBase64: [ImageList]?
    var id: String?
    var name: String?
    var idCategory: String?
    var idUser: String?
    var dateJoin: String?
    var status: Int?
    var description: String?
    var avatar: String?
    var paymentDiscountPercent: Double?
    var dateCreate: String?
    var license: String?
    var licenseType: Int?
    var address: [VendorAddress]?
}

public class VendorAddress: Codable {
    var id: String?
    var phoneNumber: String?
    var street: String?
    var ward: String?
    var district: String?
    var city: String?
    var state: String?
    var country: String?
}
