//
//  Product.swift
//  DealApp
//
//  Created by Macbook on 04/10/2021.
//

import Foundation

class GetNewProduct: Codable {
    var imageList: [ImageList]?
    var id: String
    var name: String?
    var slug: String?
    var description: String?
    var oldPrice: Double?
    var newPrice: Double?
    var status: Int?
    var salePercent: Int?
    var image: String?
    var dateCreate: String?
    var code: String?
    var taxPercent: Double?
    var active: Bool
    var quantityWareHouse: Int?
    var quantitySold: Int?
    var type: Int?
    var dateActive: String?
    var idCategory: String?
    var idUser: String?
    var idVendor: String?
}

class ImageList: Codable {
    var id: String?
    var idParent: String?
    var path: String?
    var type: Int?
    var displayOrder: Int?
}
