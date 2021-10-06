//
//  Vendor.swift
//  DealApp
//
//  Created by Macbook on 05/10/2021.
//

import Foundation

class GetListVendor: Codable {
    var imageListContent: [ImageList]?
    var imageListSlide: [ImageList]?
    var id: String?
    var name: String?
    var idCategory: String?
    var idUser: String?
    var code: String?
    var codeRef: String?
    var dateJoin: String?
    var status: Bool?
    var description: String?
    var avatar: String?
    var paymentDiscountPercent: Int?
    var dateCreate: String?
}
